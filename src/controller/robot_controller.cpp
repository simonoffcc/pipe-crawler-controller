#include "robot_controller.h"

RobotController::RobotController(std::shared_ptr<rclcpp::Node> node, QObject* parent)
    : QObject(parent)
    , node_(node)
{
    qmlRegisterUncreatableType<PairsGroupingMode>("PairsGroupingMode", 1, 0, "PairsGroupingMode", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<DriveMode>("DriveMode", 1, 0, "DriveMode", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<WheelJointName>("WheelJointName", 1, 0, "WheelJointName", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<WheelsControllerName>("WheelsControllerName", 1, 0, "WheelsControllerName", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<WheelsControllerState>("WheelsControllerState", 1, 0, "WheelsControllerState", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<RayName>("RayName", 1, 0, "RayName", "Not creatable as it is an enum type.");
    qmlRegisterSingletonInstance<RobotController>("RobotController", 1, 0, "RobotController", this);

    createROSInterfaces();

    controllers_ = {
        {
         WheelsControllerName::FrontLeft, WheelsControllerState::Global,
         {WheelJointName::FrontLeftOuter, 0.0, 0.0, 0.0},
         {WheelJointName::FrontLeftInner, 0.0, 0.0, 0.0},
         {RayName::FrontLeft, 0.0, 0.0, 0.0}
        },
        {
         WheelsControllerName::FrontUp, WheelsControllerState::Global,
         {WheelJointName::FrontUpOuter, 0.0, 0.0, 0.0},
         {WheelJointName::FrontUpInner, 0.0, 0.0, 0.0},
         {RayName::FrontUp, 0.0, 0.0, 0.0}
        },
        {
         WheelsControllerName::FrontRight, WheelsControllerState::Global,
         {WheelJointName::FrontRightOuter, 0.0, 0.0, 0.0},
         {WheelJointName::FrontRightInner, 0.0, 0.0, 0.0},
         {RayName::FrontRight, 0.0, 0.0, 0.0}
        },
        {
         WheelsControllerName::BackLeft, WheelsControllerState::Global,
         {WheelJointName::BackLeftOuter, 0.0, 0.0, 0.0},
         {WheelJointName::BackLeftInner, 0.0, 0.0, 0.0},
         {RayName::BackLeft, 0.0, 0.0, 0.0}
        },
        {
         WheelsControllerName::BackUp, WheelsControllerState::Global,
         {WheelJointName::BackUpOuter, 0.0, 0.0, 0.0},
         {WheelJointName::BackUpInner, 0.0, 0.0, 0.0},
         {RayName::BackUp, 0.0, 0.0, 0.0}
        },
        {
         WheelsControllerName::BackRight, WheelsControllerState::Global,
         {WheelJointName::BackRightOuter, 0.0, 0.0, 0.0},
         {WheelJointName::BackRightInner, 0.0, 0.0, 0.0},
         {RayName::BackRight, 0.0, 0.0, 0.0}
        },
    };

    setPairsGroupingMode(PairsGroupingMode::AllPairs);
    setDriveMode(DriveMode::FullDrive);
}

void RobotController::setDriveMode(DriveMode::Mode mode)
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
    auto controller_enum = static_cast<int>(controller_name);
    auto state_enum = static_cast<int>(state);

    for (auto& controller : controllers_) {
        if (controller.wheels_controller_name == controller_enum) {
            controller.wheels_controller_state = state_enum;
            emit controllersChanged();
            break;
        }
    }
}

void RobotController::updateActiveControllers()
{
    for (auto& controller : controllers_) {
        controller.wheels_controller_state = WheelsControllerState::Local;
    }

    if (current_pairs_grouping_mode_ == PairsGroupingMode::AllPairs) {
        switch (current_drive_mode_) {
            case DriveMode::FullDrive:
                for (auto& controller : controllers_) {
                    controller.wheels_controller_state = WheelsControllerState::Global;
                }
                break;

            case DriveMode::FrontDrive:
                for (auto& controller : controllers_) {
                    if (controller.wheels_controller_name == WheelsControllerName::FrontLeft ||
                        controller.wheels_controller_name == WheelsControllerName::FrontUp ||
                        controller.wheels_controller_name == WheelsControllerName::FrontRight) {
                        controller.wheels_controller_state = WheelsControllerState::Global;
                    }
                }
                break;

            case DriveMode::RearDrive:
                for (auto& controller : controllers_) {
                    if (controller.wheels_controller_name == WheelsControllerName::BackLeft ||
                        controller.wheels_controller_name == WheelsControllerName::BackUp ||
                        controller.wheels_controller_name == WheelsControllerName::BackRight) {
                        controller.wheels_controller_state = WheelsControllerState::Global;
                    }
                }
                break;
        }
    }
    else if (current_pairs_grouping_mode_ == PairsGroupingMode::LeftRightPairs) {
        switch (current_drive_mode_) {
            case DriveMode::FullDrive:
                for (auto& controller : controllers_) {
                    if (controller.wheels_controller_name == WheelsControllerName::FrontLeft ||
                        controller.wheels_controller_name == WheelsControllerName::FrontRight ||
                        controller.wheels_controller_name == WheelsControllerName::BackLeft ||
                        controller.wheels_controller_name == WheelsControllerName::BackRight) {
                        controller.wheels_controller_state = WheelsControllerState::Global;
                    }
                }
                break;

            case DriveMode::FrontDrive:
                for (auto& controller : controllers_) {
                    if (controller.wheels_controller_name == WheelsControllerName::FrontLeft ||
                        controller.wheels_controller_name == WheelsControllerName::FrontRight) {
                        controller.wheels_controller_state = WheelsControllerState::Global;
                    }
                }
                break;

            case DriveMode::RearDrive:
                for (auto& controller : controllers_) {
                    if (controller.wheels_controller_name == WheelsControllerName::BackLeft ||
                        controller.wheels_controller_name == WheelsControllerName::BackRight) {
                        controller.wheels_controller_state = WheelsControllerState::Global;
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
        std::bind(&RobotController::jointStatesCallback, this, std::placeholders::_1)
    );
}

void RobotController::jointStatesCallback(const sensor_msgs::msg::JointState::SharedPtr msg)
{
    if (!msg) return;

    bool velocities_changed = false;
    bool efforts_changed = false;
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

        double effort = 0.0;
        if (!msg->effort.empty() && i < msg->effort.size()) {
            effort = msg->effort[i];
        }

        auto wheel_joint_enum = WheelJointName::fromString(joint_name);
        if (wheel_joint_enum != WheelJointName::Unknown) {
            for (auto& controller : controllers_) {
                Joint* target_wheel_joint = nullptr;

                if (controller.outer_joint.name == wheel_joint_enum) {
                    target_wheel_joint = &controller.outer_joint;
                } else if (controller.inner_joint.name == wheel_joint_enum) {
                    target_wheel_joint = &controller.inner_joint;
                }

                if (target_wheel_joint && std::abs(target_wheel_joint->velocity - velocity) > velocity_step) {
                    target_wheel_joint->velocity = velocity;
                    velocities_changed = true;
                }

                if (target_wheel_joint && std::abs(target_wheel_joint->effort - effort) > effort_step) {
                    target_wheel_joint->effort = effort;
                    efforts_changed = true;
                }

                if (target_wheel_joint) {
                    break;
                }
            }
        }

        auto ray_enum = RayName::fromJointString(joint_name);
        if (ray_enum != RayName::Unknown) {
            for (auto& controller : controllers_) {
                if (controller.ray_joint.name == ray_enum) {
                    if (std::abs(controller.ray_joint.position - position) > ray_position_step) {
                        controller.ray_joint.position = position;
                        positions_changed = true;
                    }

                    if (std::abs(controller.ray_joint.velocity - velocity) > velocity_step) {
                        controller.ray_joint.velocity = velocity;
                        velocities_changed = true;
                    }
                    break;
                }
            }
        }
    }

    if (velocities_changed || positions_changed || efforts_changed) {
        emit controllersChanged();
    }
}

QVariantList RobotController::controllers() const
{
    QVariantList result;
    for (const auto& controller : controllers_) {
        QVariantMap controllerMap;
        controllerMap["name"] = static_cast<int>(controller.wheels_controller_name);
        controllerMap["state"] = static_cast<int>(controller.wheels_controller_state);
        controllerMap["outerJoint"] = QVariantMap{
            {"name", static_cast<int>(controller.outer_joint.name)},
            {"velocity", qRadiansToDegrees(controller.outer_joint.velocity)},
            {"position", controller.outer_joint.position},
            {"effort", controller.outer_joint.effort}
        };
        controllerMap["innerJoint"] = QVariantMap{
            {"name", static_cast<int>(controller.inner_joint.name)},
            {"velocity", qRadiansToDegrees(controller.inner_joint.velocity)},
            {"position", controller.inner_joint.position},
            {"effort", controller.inner_joint.effort}
        };
        controllerMap["rayJoint"] = QVariantMap{
            {"name", static_cast<int>(controller.ray_joint.name)},
            {"position", controller.ray_joint.position},
            {"velocity", controller.ray_joint.velocity},
            {"effort", controller.ray_joint.effort}
        };
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
        QString logMsg = QString("Published speed %1 rad/s to %2")
                        .arg(msg.data.at(0), 0, 'f', 2)
                        .arg(QString::fromStdString(topic_name));
        addLogMessage(logMsg);
    }
    else {
        QString logMsg = QString("Failed to publish speed %1 rad/s to %2: There are no subscribers for this topic.")
                        .arg(msg.data.at(0), 0, 'f', 2)
                        .arg(QString::fromStdString(topic_name));
        addLogMessage(logMsg);
    }
}

void RobotController::publishGlobalSpeed(double speed)
{
    std_msgs::msg::Float64MultiArray msg;
    double speed_in_radians = qDegreesToRadians(speed);
    msg.data = {speed_in_radians, speed_in_radians};

    for (const auto& controller : controllers_) {
        if (controller.wheels_controller_state == WheelsControllerState::Global) {
            if (pair_velocity_publishers_.find(static_cast<WheelsControllerName::Name>(controller.wheels_controller_name)) != pair_velocity_publishers_.end()) {
                publishSpeed(pair_velocity_publishers_[static_cast<WheelsControllerName::Name>(controller.wheels_controller_name)], msg);
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
        if (controller.wheels_controller_name == controller_name && controller.wheels_controller_state == WheelsControllerState::Local) {
            if (pair_velocity_publishers_.find(controller_enum) != pair_velocity_publishers_.end()) {
                publishSpeed(pair_velocity_publishers_[controller_enum], msg);
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
        if (controller.wheels_controller_name == controller_name && controller.wheels_controller_state == WheelsControllerState::Independent) {
            double outer_speed = is_outer_joint ? speed_in_radians : controller.outer_joint.velocity;
            double inner_speed = is_outer_joint ? controller.inner_joint.velocity : speed_in_radians;

            msg.data = {outer_speed, inner_speed};

            if (pair_velocity_publishers_.find(controller_enum) != pair_velocity_publishers_.end()) {
                publishSpeed(pair_velocity_publishers_[controller_enum], msg);
            }
            break;
        }
    }
}

void RobotController::publishRayPosition(double position, int ray_name)
{
    auto ray_enum = static_cast<RayName::Name>(ray_name);
    std_msgs::msg::Float64MultiArray msg;
    msg.data = {position};

    if (ray_position_publishers_.find(ray_enum) != ray_position_publishers_.end()) {
        auto publisher = ray_position_publishers_[ray_enum];
        std::string topic_name = publisher->get_topic_name();

        if (publisher->get_subscription_count() > 0) {
            publisher->publish(msg);
            QString logMsg = QString("Published ray position %1 m to %2")
                            .arg(position, 0, 'f', 3)
                            .arg(QString::fromStdString(topic_name));
            addLogMessage(logMsg);
        }
        else {
            QString logMsg = QString("Failed to publish ray position %1 m to %2: There are no subscribers for this topic.")
                            .arg(position, 0, 'f', 3)
                            .arg(QString::fromStdString(topic_name));
            addLogMessage(logMsg);
        }
    }
}

void RobotController::clearLogMessages()
{
    log_messages_.clear();
    emit logMessagesChanged();
}
