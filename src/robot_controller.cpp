#include "robot_controller.h"

RobotController::RobotController(std::shared_ptr<rclcpp::Node> node, QObject* parent)
    : QObject(parent)
    , node_(node)
    , current_pairs_grouping_mode_(PairsGroupingMode::AllPairs)
    , current_drive_mode_(DriveMode::AllWheelDrive)
{
    qmlRegisterUncreatableType<PairsGroupingMode>("pairsGroupingMode", 1, 0, "PairsGroupingMode", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<DriveMode>("driveMode", 1, 0, "DriveMode", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<WheelJointName>("wheelJointName", 1, 0, "WheelJointName", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<WheelsControllerName>("wheelsControllerName", 1, 0, "WheelsControllerName", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<WheelsControllerState>("wheelsControllerState", 1, 0, "WheelsControllerState", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<RayName>("rayName", 1, 0, "RayName", "Not creatable as it is an enum type.");
    qmlRegisterSingletonInstance<RobotController>("RobotController", 1, 0, "RobotController", this);

    createROSInterfaces();

    controllers_ = {
        {
         WheelsControllerName::FrontLeft, RayName::FrontLeft, WheelsControllerState::Global,
         {WheelJointName::FrontLeftOuter, 0.0}, {WheelJointName::FrontLeftInner, 0.0}, 0.0
        },
        {
         WheelsControllerName::FrontUp, RayName::FrontUp, WheelsControllerState::Global,
         {WheelJointName::FrontUpOuter, 0.0}, {WheelJointName::FrontUpInner, 0.0}, 0.0
        },
        {
         WheelsControllerName::FrontRight, RayName::FrontRight, WheelsControllerState::Global,
         {WheelJointName::FrontRightOuter, 0.0}, {WheelJointName::FrontRightInner, 0.0}, 0.0
        },
        {
         WheelsControllerName::BackLeft, RayName::BackLeft, WheelsControllerState::Global,
         {WheelJointName::BackLeftOuter, 0.0}, {WheelJointName::BackLeftInner, 0.0}, 0.0
        },
        {
         WheelsControllerName::BackUp, RayName::BackUp, WheelsControllerState::Global,
         {WheelJointName::BackUpOuter, 0.0}, {WheelJointName::BackUpInner, 0.0}, 0.0
        },
        {
         WheelsControllerName::BackRight, RayName::BackRight, WheelsControllerState::Global,
         {WheelJointName::BackRightOuter, 0.0}, {WheelJointName::BackRightInner, 0.0}, 0.0
        }
    };

    updateGlobalControllersCount();
}

void RobotController::setDriveMode(int mode)
{
    if (current_drive_mode_ != mode) {
        current_drive_mode_ = mode;
        emit driveModeChanged();
        updateActiveControllers();
    }
}

void RobotController::setPairsGroupingMode(int mode)
{
    if (current_pairs_grouping_mode_ != mode) {
        current_pairs_grouping_mode_ = mode;
        emit pairsGroupingModeChanged();
        updateActiveControllers();
    }
}

void RobotController::setWheelsControllerState(int controller_name, int state)
{
    auto controller_enum = static_cast<WheelsControllerName::Name>(controller_name);
    auto state_enum = static_cast<WheelsControllerState::State>(state);

    for (auto& controller : controllers_) {
        if (controller.wheel_pair_name == controller_enum) {
            bool wasGlobal = controller.state == WheelsControllerState::Global;
            bool willBeGlobal = state_enum == WheelsControllerState::Global;

            if (wasGlobal != willBeGlobal) {
                global_controllers_count_ += willBeGlobal ? 1 : -1;
            }

            controller.state = state_enum;
            emit controllersChanged();
            break;
        }
    }
}

void RobotController::updateActiveControllers()
{
    for (auto& controller : controllers_) {
        controller.state = WheelsControllerState::Local;
    }

    global_controllers_count_ = 0;

    if (current_pairs_grouping_mode_ == PairsGroupingMode::AllPairs) {
        switch (current_drive_mode_) {
            case DriveMode::AllWheelDrive:
                for (auto& controller : controllers_) {
                    controller.state = WheelsControllerState::Global;
                }
                global_controllers_count_ = controllers_.size();
                break;

            case DriveMode::FrontDrive:
                for (auto& controller : controllers_) {
                    if (controller.wheel_pair_name == WheelsControllerName::FrontLeft ||
                        controller.wheel_pair_name == WheelsControllerName::FrontUp ||
                        controller.wheel_pair_name == WheelsControllerName::FrontRight) {
                        controller.state = WheelsControllerState::Global;
                        global_controllers_count_++;
                    }
                }
                break;

            case DriveMode::RearDrive:
                for (auto& controller : controllers_) {
                    if (controller.wheel_pair_name == WheelsControllerName::BackLeft ||
                        controller.wheel_pair_name == WheelsControllerName::BackUp ||
                        controller.wheel_pair_name == WheelsControllerName::BackRight) {
                        controller.state = WheelsControllerState::Global;
                        global_controllers_count_++;
                    }
                }
                break;
        }
    }
    else if (current_pairs_grouping_mode_ == PairsGroupingMode::LeftRight) {
        switch (current_drive_mode_) {
            case DriveMode::AllWheelDrive:
                for (auto& controller : controllers_) {
                    if (controller.wheel_pair_name == WheelsControllerName::FrontLeft ||
                        controller.wheel_pair_name == WheelsControllerName::FrontRight ||
                        controller.wheel_pair_name == WheelsControllerName::BackLeft ||
                        controller.wheel_pair_name == WheelsControllerName::BackRight) {
                        controller.state = WheelsControllerState::Global;
                        global_controllers_count_++;
                    }
                }
                break;

            case DriveMode::FrontDrive:
                for (auto& controller : controllers_) {
                    if (controller.wheel_pair_name == WheelsControllerName::FrontLeft ||
                        controller.wheel_pair_name == WheelsControllerName::FrontRight) {
                        controller.state = WheelsControllerState::Global;
                        global_controllers_count_++;
                    }
                }
                break;

            case DriveMode::RearDrive:
                for (auto& controller : controllers_) {
                    if (controller.wheel_pair_name == WheelsControllerName::BackLeft ||
                        controller.wheel_pair_name == WheelsControllerName::BackRight) {
                        controller.state = WheelsControllerState::Global;
                        global_controllers_count_++;
                    }
                }
                break;
        }
    }

    emit controllersChanged();
}

void RobotController::createROSInterfaces()
{
    pair_velocity_publishers_.clear();
    ray_position_publishers_.clear();

    for (int i = 0; i < 6; ++i) {
        auto controller_enum = static_cast<WheelsControllerName::Name>(i);
        std::string controller_name = WheelsControllerName::toString(controller_enum);

        auto publisher = node_->create_publisher<std_msgs::msg::Float64MultiArray>(
            "/" + controller_name + "/commands", 100);
        pair_velocity_publishers_[controller_enum] = publisher;
    }

    for (int i = 0; i < 6; ++i) {
        auto ray_enum = static_cast<RayName::Name>(i);
        std::string ray_controller_name = RayName::toControllerString(ray_enum);

        auto publisher = node_->create_publisher<std_msgs::msg::Float64MultiArray>(
            "/" + ray_controller_name + "/commands", 100);
        ray_position_publishers_[ray_enum] = publisher;
    }

    joint_state_subscriber_ = node_->create_subscription<sensor_msgs::msg::JointState>(
        "/joint_states", 100,
        std::bind(&RobotController::jointStateCallback, this, std::placeholders::_1)
    );
}

void RobotController::jointStateCallback(const sensor_msgs::msg::JointState::SharedPtr msg)
{
    if (!msg) return;
    
    bool speeds_changed = false;
    bool positions_changed = false;

    for (size_t i = 0; i < msg->name.size(); i++) {
        const std::string& joint_name = msg->name[i];
        
        double velocity = 0.0;
        if (!msg->velocity.empty() && i < msg->velocity.size()) {
            velocity = msg->velocity[i];
        }

        double position = 0.0;
        if (!msg->position.empty() && i < msg->position.size()) {
            position = msg->position[i];
        }

        auto wheel_joint_enum = WheelJointName::fromString(joint_name);
        if (wheel_joint_enum != WheelJointName::Unknown) {
            for (auto& controller : controllers_) {
                Joint* target_joint = nullptr;

                if (controller.outer_joint.name == wheel_joint_enum) {
                    target_joint = &controller.outer_joint;
                } else if (controller.inner_joint.name == wheel_joint_enum) {
                    target_joint = &controller.inner_joint;
                }

                if (target_joint && std::abs(target_joint->velocity - velocity) > velocity_step) {
                    target_joint->velocity = velocity;
                    speeds_changed = true;
                    break;
                }
            }
        }

        auto ray_enum = RayName::fromJointString(joint_name);
        if (ray_enum != RayName::Unknown) {
            for (auto& controller : controllers_) {
                if (controller.ray_name == ray_enum && 
                    position >= 0.0 && position <= 0.22 && 
                    std::abs(controller.ray_position - position) > ray_position_step) {
                    controller.ray_position = position;
                    positions_changed = true;
                    break;
                }
            }
        }
    }

    if (speeds_changed || positions_changed) {
        emit controllersChanged();
    }
}

QVariantList RobotController::controllers() const
{
    QVariantList result;
    for (const auto& controller : controllers_) {
        QVariantMap controllerMap;
        controllerMap["name"] = static_cast<int>(controller.wheel_pair_name);
        controllerMap["state"] = static_cast<int>(controller.state);
        controllerMap["outerJoint"] = QVariantMap{
            {"name", static_cast<int>(controller.outer_joint.name)},
            {"velocity", qRadiansToDegrees(controller.outer_joint.velocity)}
        };
        controllerMap["innerJoint"] = QVariantMap{
            {"name", static_cast<int>(controller.inner_joint.name)},
            {"velocity", qRadiansToDegrees(controller.inner_joint.velocity)}
        };
        controllerMap["rayName"] = static_cast<int>(controller.ray_name);
        controllerMap["rayPosition"] = controller.ray_position;
        result.append(controllerMap);
    }
    return result;
}

void RobotController::addLogMessage(const QString& message) {
    log_messages_.prepend(message);
    while (log_messages_.size() > MAX_LOG_MESSAGES) {
        log_messages_.removeLast();
    }
    emit logMessagesChanged();
}

void RobotController::publishSpeed(rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr publisher, std_msgs::msg::Float64MultiArray msg) {
    std::string topic_name = publisher->get_topic_name();

    if (publisher->get_subscription_count() > 0) {
        publisher->publish(msg);
        QString logMsg = QString("Publishing speed %1 rad/s to %2")
                        .arg(msg.data.at(0), 0, 'f', 2)
                        .arg(QString::fromStdString(topic_name));
        addLogMessage(logMsg);
    }
    else {
        QString logMsg = QString("Failed publishing speed %1 rad/s to %2: There are no subscribers for this topic.")
                        .arg(msg.data.at(0), 0, 'f', 2)
                        .arg(QString::fromStdString(topic_name));
        addLogMessage(logMsg);
    }
}

void RobotController::publishGlobalSpeed(double speed)
{
    if (global_controllers_count_ == 0) {
        addLogMessage(QString("Warning: Cannot publish global speed - no controllers in global mode."));
        return;
    }

    std_msgs::msg::Float64MultiArray msg;
    double speed_in_radians = qDegreesToRadians(speed);
    msg.data = {speed_in_radians, speed_in_radians};

    for (const auto& controller : controllers_) {
        if (controller.state == WheelsControllerState::Global) {
            if (pair_velocity_publishers_.find(controller.wheel_pair_name) != pair_velocity_publishers_.end()) {
                publishSpeed(pair_velocity_publishers_[controller.wheel_pair_name], msg);
            }
        }
    }
}

void RobotController::publishLocalSpeed(double speed, int controller_name)
{
    auto controller_enum = static_cast<WheelsControllerName::Name>(controller_name);
    std_msgs::msg::Float64MultiArray msg;
    double speed_in_radians = qDegreesToRadians(speed);
    msg.data = {speed_in_radians, speed_in_radians};

    for (auto& controller : controllers_) {
        if (controller.wheel_pair_name == controller_enum && controller.state == WheelsControllerState::Local) {
            if (pair_velocity_publishers_.find(controller.wheel_pair_name) != pair_velocity_publishers_.end()) {
                publishSpeed(pair_velocity_publishers_[controller.wheel_pair_name], msg);
            }
            break;
        }
    }
}

void RobotController::publishIndependentSpeed(double speed, int controller_name, bool is_outer_joint)
{
    auto controller_enum = static_cast<WheelsControllerName::Name>(controller_name);
    std_msgs::msg::Float64MultiArray msg;
    double speed_in_radians = qDegreesToRadians(speed);

    for (auto& controller : controllers_) {
        if (controller.wheel_pair_name == controller_enum && controller.state == WheelsControllerState::Independent) {
            double outer_speed = is_outer_joint ? speed_in_radians : controller.outer_joint.velocity;
            double inner_speed = is_outer_joint ? controller.inner_joint.velocity : speed_in_radians;

            msg.data = {outer_speed, inner_speed};

            if (pair_velocity_publishers_.find(controller.wheel_pair_name) != pair_velocity_publishers_.end()) {
                publishSpeed(pair_velocity_publishers_[controller.wheel_pair_name], msg);
            }
            break;
        }
    }
}

// void RobotController::publishRayPosition(double position, int ray_name)
// {
//     auto ray_enum = static_cast<RayName::Name>(ray_name);
//     std_msgs::msg::Float64MultiArray msg;
//     msg.data = {position};

//     if (ray_position_publishers_.find(ray_enum) != ray_position_publishers_.end()) {
//         auto publisher = ray_position_publishers_[ray_enum];
//         std::string topic_name = publisher->get_topic_name();

//         if (publisher->get_subscription_count() > 0) {
//             publisher->publish(msg);
//             QString logMsg = QString("Publishing ray position %1 m to %2")
//                             .arg(position, 0, 'f', 3)
//                             .arg(QString::fromStdString(topic_name));
//             addLogMessage(logMsg);
//         }
//         else {
//             QString logMsg = QString("Failed publishing ray position %1 m to %2: There are no subscribers for this topic.")
//                             .arg(position, 0, 'f', 3)
//                             .arg(QString::fromStdString(topic_name));
//             addLogMessage(logMsg);
//         }
//     }
// }

void RobotController::updateGlobalControllersCount()
{
    global_controllers_count_ = 0;
    for (const auto& controller : controllers_) {
        if (controller.state == WheelsControllerState::Global) {
            global_controllers_count_++;
        }
    }
}

void RobotController::clearLogMessages()
{
    log_messages_.clear();
    emit logMessagesChanged();
}
