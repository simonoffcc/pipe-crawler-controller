#include "wheel_controller.h"

WheelController::WheelController(std::shared_ptr<rclcpp::Node> node, QObject* parent)
    : QObject(parent)
    , node_(node)
    , current_pairs_grouping_mode_(PairsGroupingMode::AllPairs)
    , current_drive_mode_(DriveMode::AllWheelDrive)
{
    qmlRegisterUncreatableType<PairsGroupingMode>("pairsGroupingMode", 1, 0, "PairsGroupingMode", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<DriveMode>("driveMode", 1, 0, "DriveMode", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<JointName>("jointName", 1, 0, "JointName", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<ControllerName>("controllerName", 1, 0, "ControllerName", "Not creatable as it is an enum type.");
    qmlRegisterSingletonInstance<WheelController>("WheelController", 1, 0, "WheelController", this);

    createROSInterfaces();

    updateActiveControllers();

    joint_speeds_[JointName::FrontLeftOuter] = 0.0;
    joint_speeds_[JointName::FrontLeftInner] = 0.0;
    joint_speeds_[JointName::FrontUpOuter] = 0.0;
    joint_speeds_[JointName::FrontUpInner] = 0.0;
    joint_speeds_[JointName::FrontRightOuter] = 0.0;
    joint_speeds_[JointName::FrontRightInner] = 0.0;
    joint_speeds_[JointName::BackLeftOuter] = 0.0;
    joint_speeds_[JointName::BackLeftInner] = 0.0;
    joint_speeds_[JointName::BackUpOuter] = 0.0;
    joint_speeds_[JointName::BackUpInner] = 0.0;
    joint_speeds_[JointName::BackRightOuter] = 0.0;
    joint_speeds_[JointName::BackRightInner] = 0.0;
    // emit jointSpeedsChanged();
}

void WheelController::setDriveMode(int mode)
{
    if (current_drive_mode_ != mode) {
        current_drive_mode_ = mode;
        updateActiveControllers();
    }
}

void WheelController::setPairsGroupingMode(int mode)
{
    if (current_pairs_grouping_mode_ != mode) {
        current_pairs_grouping_mode_ = mode;
        updateActiveControllers();
    }
}

void WheelController::updateActiveControllers()
{
    active_controllers_.clear();

    if (current_pairs_grouping_mode_ == PairsGroupingMode::AllPairs) {
        switch (current_drive_mode_) {
            case DriveMode::AllWheelDrive:
                active_controllers_.push_back(ControllerName::FrontLeft);
                active_controllers_.push_back(ControllerName::FrontUp);
                active_controllers_.push_back(ControllerName::FrontRight);
                active_controllers_.push_back(ControllerName::BackLeft);
                active_controllers_.push_back(ControllerName::BackUp);
                active_controllers_.push_back(ControllerName::BackRight);
                break;

            case DriveMode::FrontDrive:
                active_controllers_.push_back(ControllerName::FrontLeft);
                active_controllers_.push_back(ControllerName::FrontUp);
                active_controllers_.push_back(ControllerName::FrontRight);
                break;

            case DriveMode::RearDrive:
                active_controllers_.push_back(ControllerName::BackLeft);
                active_controllers_.push_back(ControllerName::BackUp);
                active_controllers_.push_back(ControllerName::BackRight);
                break;

            default:
                break;
        }
    }
    else if (current_pairs_grouping_mode_ == PairsGroupingMode::LeftRight) {
        switch (current_drive_mode_) {
            case DriveMode::AllWheelDrive:
                active_controllers_.push_back(ControllerName::FrontLeft);
                active_controllers_.push_back(ControllerName::FrontRight);
                active_controllers_.push_back(ControllerName::BackLeft);
                active_controllers_.push_back(ControllerName::BackRight);
                break;

            case DriveMode::FrontDrive:
                active_controllers_.push_back(ControllerName::FrontLeft);
                active_controllers_.push_back(ControllerName::FrontRight);
                break;

            case DriveMode::RearDrive:
                active_controllers_.push_back(ControllerName::BackLeft);
                active_controllers_.push_back(ControllerName::BackRight);
                break;

            default:
                break;
        }
    }

    emit activeControllersChanged();
}

void WheelController::createROSInterfaces()
{
    pair_velocity_publishers_.clear();

    for (int i = 0; i < 6; ++i) {
        auto controller_enum = static_cast<ControllerName::Name>(i);
        std::string controller_name = ControllerName::toString(controller_enum);

        auto publisher = node_->create_publisher<std_msgs::msg::Float64MultiArray>(
            "/" + controller_name + "/commands", 100);
        pair_velocity_publishers_[controller_enum] = publisher;
    }

    joint_state_subscriber_ = node_->create_subscription<sensor_msgs::msg::JointState>(
        "/joint_states", 100,
        std::bind(&WheelController::jointStateCallback, this, std::placeholders::_1)
    );
}

void WheelController::jointStateCallback(const sensor_msgs::msg::JointState::SharedPtr msg)
{
    bool speeds_changed = false;

    for (size_t i = 0; i < msg->name.size(); i++) {
        const std::string& joint_name = msg->name[i];
        const double velocity = msg->velocity[i];

        auto joint_enum = JointName::fromString(joint_name);
        if (joint_enum != JointName::Unknown) {
            if (std::abs(joint_speeds_[joint_enum] - velocity) > precision) {
                joint_speeds_[joint_enum] = velocity;
                RCLCPP_INFO(node_->get_logger(), "Joint %s speed updated to: %.2f rad/s",
                    JointName::toString(joint_enum).c_str(), velocity);
                speeds_changed = true;
            }
        }
    }

    if (speeds_changed) {
        RCLCPP_INFO(node_->get_logger(), "------- Wheel speeds updated -------");
        for (const auto& [joint, speed] : joint_speeds_) {
            RCLCPP_INFO(node_->get_logger(), "%s: %.2f rad/s",
                JointName::toString(joint).c_str(), speed);
        }
        RCLCPP_INFO(node_->get_logger(), "--------------------------------");
        emit jointSpeedsChanged();
    }
}

QVariantMap WheelController::jointSpeeds() const
{
    QVariantMap speeds;
    for (const auto& [joint, speed] : joint_speeds_) {
        speeds[QString::number(joint)] = qRadiansToDegrees(speed);
    }
    return speeds;
}

void WheelController::publishGlobalSpeed(double speed)
{
    std_msgs::msg::Float64MultiArray msg;
    double speed_in_radians = qDegreesToRadians(speed);
    msg.data = {speed_in_radians, speed_in_radians};

    for (const auto& controller_enum : active_controllers_) {
        auto controller = static_cast<ControllerName::Name>(controller_enum);
        if (pair_velocity_publishers_.find(controller) != pair_velocity_publishers_.end()) {
            pair_velocity_publishers_[controller]->publish(msg);
        }
    }
}

// void publishLocalSpeed(double speed, const int& controller_name)
// {
//     // публикация в ros топик
// }

// void publishIndependentSpeed(double speed, const int& controller_name)
// {
//     // публикация в ros топик
// }
