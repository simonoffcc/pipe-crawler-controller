#include "wheel_controller.h"

WheelController::WheelController(std::shared_ptr<rclcpp::Node> node, QObject* parent)
: QObject(parent),
node_(node),
{
    for (const auto& controller : CONTROLLER_NAMES) {
        wheel_publishers_[controller] = node_->create_publisher<std_msgs::msg::Float64MultiArray>(
            "/" + controller + "/commands", 10);
    }

    joint_state_sub_ = node_->create_subscription<sensor_msgs::msg::JointState>(
        "/joint_states", 10,
        std::bind(&WheelController::jointStateCallback, this, std::placeholders::_1));

    for (const auto& joint : JOINT_NAMES) {
        wheel_speeds_[QString::fromStdString(joint)] = 0.0;
    }
}

void WheelController::setDriveMode(DriveMode mode) {
    if (drive_mode_ != mode) {
        drive_mode_ = mode;
        emit driveModeChanged();
    }
}

void WheelController::setLeftRightWheelsSpeeds(double left_speed, double right_speed) {
    switch (drive_mode_) {
        case DriveMode::FRONT_DRIVE:
            publishWheelCommands("front_left_wheels_controller", left_speed, left_speed);
            publishWheelCommands("front_right_wheels_controller", right_speed, right_speed);
            break;
        case DriveMode::REAR_DRIVE:
            publishWheelCommands("back_left_wheels_controller", left_speed, left_speed);
            publishWheelCommands("back_right_wheels_controller", right_speed, right_speed);
            break;
        case DriveMode::ALL_WHEEL_DRIVE:
            publishWheelCommands("front_left_wheels_controller", left_speed, left_speed);
            publishWheelCommands("front_right_wheels_controller", right_speed, right_speed);
            publishWheelCommands("back_left_wheels_controller", left_speed, left_speed);
            publishWheelCommands("back_right_wheels_controller", right_speed, right_speed);
            break;
    }
}

void WheelController::setAllWheelsSpeeds(double speed) {
    switch (drive_mode_) {
        case DriveMode::FRONT_DRIVE:
            for (const auto& controller : {"front_left_wheels_controller", 
                                         "front_right_wheels_controller",
                                         "front_up_wheels_controller"}) {
                publishWheelCommands(controller, speed, speed);
            }
            break;
        case DriveMode::REAR_DRIVE:
            for (const auto& controller : {"back_left_wheels_controller", 
                                         "back_right_wheels_controller",
                                         "back_up_wheels_controller"}) {
                publishWheelCommands(controller, speed, speed);
            }
            break;
        case DriveMode::ALL_WHEEL_DRIVE:
            for (const auto& controller : CONTROLLER_NAMES) {
                publishWheelCommands(controller, speed, speed);
            }
            break;
    }
}

void WheelController::jointStateCallback(const sensor_msgs::msg::JointState::SharedPtr msg) {
    bool speeds_updated = false;
    
    // Обновляем скорости только для тех колес, информация о которых есть в сообщении
    for (size_t i = 0; i < msg->name.size(); ++i) {
        const auto& joint_name = msg->name[i];
        if (i < msg->velocity.size()) {  // Проверяем, есть ли данные о скорости
            QString qjoint_name = QString::fromStdString(joint_name);
            if (wheel_speeds_.contains(qjoint_name)) {
                wheel_speeds_[qjoint_name] = msg->velocity[i];
                speeds_updated = true;
            }
        }
    }

    if (speeds_updated) {
        emit wheelSpeedsChanged();
    }
}

void WheelController::publishWheelCommands(const std::string& controller_name, 
                                         double outer_speed, double inner_speed) {
    auto msg = std::make_unique<std_msgs::msg::Float64MultiArray>();
    msg->data = {outer_speed, inner_speed};
    wheel_publishers_[controller_name]->publish(std::move(msg));
} 