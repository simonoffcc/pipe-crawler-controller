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

    controllers_ = {
        {
         ControllerName::FrontLeft,  ControlState::GLOBAL,
         {JointName::FrontLeftOuter,  0.0}, {JointName::FrontLeftInner,  0.0}
        },
        {
         ControllerName::FrontUp,    ControlState::GLOBAL,
         {JointName::FrontUpOuter,    0.0}, {JointName::FrontUpInner,    0.0}
        },
        {
         ControllerName::FrontRight, ControlState::GLOBAL,
         {JointName::FrontRightOuter, 0.0}, {JointName::FrontRightInner, 0.0}
        },
        {
         ControllerName::BackLeft,   ControlState::GLOBAL,
         {JointName::BackLeftOuter,   0.0}, {JointName::BackLeftInner,   0.0}
        },
        {
         ControllerName::BackUp,     ControlState::GLOBAL,
         {JointName::BackUpOuter,     0.0}, {JointName::BackUpInner,     0.0}
        },
        {
         ControllerName::BackRight,  ControlState::GLOBAL,
         {JointName::BackRightOuter,  0.0}, {JointName::BackRightInner,  0.0}
        }
    };
}

void WheelController::setDriveMode(int mode)
{
    if (current_drive_mode_ != mode) {
        current_drive_mode_ = mode;
        emit driveModeChanged();
        updateActiveControllers();
    }
}

void WheelController::setPairsGroupingMode(int mode)
{
    if (current_pairs_grouping_mode_ != mode) {
        current_pairs_grouping_mode_ = mode;
        emit pairsGroupingModeChanged();
        updateActiveControllers();
    }
}

void WheelController::setControllerState(int controller_name, int state)
{
    auto controller_enum = static_cast<ControllerName::Name>(controller_name);
    auto state_enum = static_cast<ControlState>(state);

    for (auto& controller : controllers_) {
        if (controller.name == controller_enum) {
            controller.state = state_enum;
            emit controllersChanged();
            break;
        }
    }
}

void WheelController::updateActiveControllers()
{
    for (auto& controller : controllers_) {
        controller.state = ControlState::LOCAL;
    }

    if (current_pairs_grouping_mode_ == PairsGroupingMode::AllPairs) {
        switch (current_drive_mode_) {
            case DriveMode::AllWheelDrive:
                for (auto& controller : controllers_) {
                    controller.state = ControlState::GLOBAL;
                }
                break;

            case DriveMode::FrontDrive:
                for (auto& controller : controllers_) {
                    if (controller.name == ControllerName::FrontLeft ||
                        controller.name == ControllerName::FrontUp ||
                        controller.name == ControllerName::FrontRight) {
                        controller.state = ControlState::GLOBAL;
                    }
                }
                break;

            case DriveMode::RearDrive:
                for (auto& controller : controllers_) {
                    if (controller.name == ControllerName::BackLeft ||
                        controller.name == ControllerName::BackUp ||
                        controller.name == ControllerName::BackRight) {
                        controller.state = ControlState::GLOBAL;
                    }
                }
                break;
        }
    }
    else if (current_pairs_grouping_mode_ == PairsGroupingMode::LeftRight) {
        switch (current_drive_mode_) {
            case DriveMode::AllWheelDrive:
                for (auto& controller : controllers_) {
                    if (controller.name == ControllerName::FrontLeft ||
                        controller.name == ControllerName::FrontRight ||
                        controller.name == ControllerName::BackLeft ||
                        controller.name == ControllerName::BackRight) {
                        controller.state = ControlState::GLOBAL;
                    }
                }
                break;

            case DriveMode::FrontDrive:
                for (auto& controller : controllers_) {
                    if (controller.name == ControllerName::FrontLeft ||
                        controller.name == ControllerName::FrontRight) {
                        controller.state = ControlState::GLOBAL;
                    }
                }
                break;

            case DriveMode::RearDrive:
                for (auto& controller : controllers_) {
                    if (controller.name == ControllerName::BackLeft ||
                        controller.name == ControllerName::BackRight) {
                        controller.state = ControlState::GLOBAL;
                    }
                }
                break;
        }
    }

    emit controllersChanged();
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
            for (auto& controller : controllers_) {
                Joint* target_joint = nullptr;

                if (controller.outer_joint.name == joint_enum) {
                    target_joint = &controller.outer_joint;
                } else if (controller.inner_joint.name == joint_enum) {
                    target_joint = &controller.inner_joint;
                }

                if (target_joint && std::abs(target_joint->velocity - velocity) > velocity_step) {
                    target_joint->velocity = velocity;
                    speeds_changed = true;
                }
            }
        }
    }

    if (speeds_changed) {
        emit controllersChanged();
    }
}

QVariantList WheelController::controllers() const
{
    QVariantList result;
    for (const auto& controller : controllers_) {
        QVariantMap controllerMap;
        controllerMap["name"] = static_cast<int>(controller.name);
        controllerMap["state"] = static_cast<int>(controller.state);
        controllerMap["outerJoint"] = QVariantMap{
            {"name", static_cast<int>(controller.outer_joint.name)},
            {"velocity", qRadiansToDegrees(controller.outer_joint.velocity)}
        };
        controllerMap["innerJoint"] = QVariantMap{
            {"name", static_cast<int>(controller.inner_joint.name)},
            {"velocity", qRadiansToDegrees(controller.inner_joint.velocity)}
        };
        result.append(controllerMap);
    }
    return result;
}

void WheelController::addLogMessage(const QString& message) {
    log_messages_.prepend(message);
    while (log_messages_.size() > MAX_LOG_MESSAGES) {
        log_messages_.removeLast();
    }
    emit logMessagesChanged();
}

void WheelController::publishSpeed(rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr publisher, std_msgs::msg::Float64MultiArray msg) {
    std::string topic_name = publisher->get_topic_name();
    
    if (publisher->get_subscription_count() > 0) {
        publisher->publish(msg);
        QString logMsg = QString("Publishing speed %1 rad/s to %2")
                        .arg(msg.data.at(0), 0, 'f', 2)
                        .arg(QString::fromStdString(topic_name));
        addLogMessage(logMsg);
    }
    else {
        QString logMsg = QString("Failed publishing speed %1 rad/s to %2: There are no subscribers for this topic")
                        .arg(msg.data.at(0), 0, 'f', 2)
                        .arg(QString::fromStdString(topic_name));
        addLogMessage(logMsg);
    }
}

void WheelController::publishGlobalSpeed(double speed)
{
    std_msgs::msg::Float64MultiArray msg;
    double speed_in_radians = qDegreesToRadians(speed);
    msg.data = {speed_in_radians, speed_in_radians};

    for (const auto& controller : controllers_) {
        if (controller.state == ControlState::GLOBAL) {
            if (pair_velocity_publishers_.find(controller.name) != pair_velocity_publishers_.end()) {
                publishSpeed(pair_velocity_publishers_[controller.name], msg);
            }
        }
    }
}

void WheelController::publishLocalSpeed(double speed, int controller_name)
{

    auto controller_enum = static_cast<ControllerName::Name>(controller_name);
    std_msgs::msg::Float64MultiArray msg;
    double speed_in_radians = qDegreesToRadians(speed);
    msg.data = {speed_in_radians, speed_in_radians};

    for (auto& controller : controllers_) {
        if (controller.name == controller_enum && controller.state == ControlState::LOCAL) {
            if (pair_velocity_publishers_.find(controller.name) != pair_velocity_publishers_.end()) {
                publishSpeed(pair_velocity_publishers_[controller.name], msg);
            }
            break;
        }
    }
}

void WheelController::publishIndependentSpeed(double speed, int controller_name, bool is_outer_joint)
{
    auto controller_enum = static_cast<ControllerName::Name>(controller_name);
    std_msgs::msg::Float64MultiArray msg;
    double speed_in_radians = qDegreesToRadians(speed);
    
    for (auto& controller : controllers_) {
        if (controller.name == controller_enum && controller.state == ControlState::INDEPENDENT) {
            double outer_speed = is_outer_joint ? speed_in_radians : controller.outer_joint.velocity;
            double inner_speed = is_outer_joint ? controller.inner_joint.velocity : speed_in_radians;
            
            msg.data = {outer_speed, inner_speed};
            
            if (pair_velocity_publishers_.find(controller.name) != pair_velocity_publishers_.end()) {
                publishSpeed(pair_velocity_publishers_[controller.name], msg);
            }
            break;
        }
    }
}
