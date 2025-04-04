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
}

void WheelController::setDriveMode(int mode) {
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

void WheelController::createROSInterfaces() {
    /*
    // Создаем издателей для каждого контроллера
    for (auto it = wheelPairs.begin(); it != wheelPairs.end(); ++it) {
        const auto &pair = it.value();
        auto publisher = rosNode->create_publisher<std_msgs::msg::Float64MultiArray>(
            "/" + pair.controllerName + "/commands", 10);
        controllers[it.key()] = publisher;
    }

    // Подписываемся на топик состояния шарниров
    jointStatesSub = rosNode->create_subscription<sensor_msgs::msg::JointState>(
        "/joint_states", 10,
        std::bind(&VelocityController::jointStatesCallback, this, std::placeholders::_1));
    */

    // Publishers
    pair_velocity_publisher_ = node_->create_publisher<std_msgs::msg::Float64MultiArray>(
        "/forward_velocity_controller/commands", 10);

    // Subscribers
    joint_state_subscriber_ = node_->create_subscription<sensor_msgs::msg::JointState>(
        "/joint_states", 100, std::bind(&WheelController::jointStateCallback, this, std::placeholders::_1));
}

void WheelController::jointStateCallback(const sensor_msgs::msg::JointState::SharedPtr msg) {
    current_joint_states_.at(0) = msg->velocity.at(static_cast<int>(JointPositionsInSequence::SHOULDER_PAN));
    current_joint_states_.at(1) = msg->velocity.at(static_cast<int>(JointPositionsInSequence::SHOULDER_LIFT));
    current_joint_states_.at(2) = msg->velocity.at(static_cast<int>(JointPositionsInSequence::ELBOW));
    current_joint_states_.at(3) = msg->velocity.at(static_cast<int>(JointPositionsInSequence::WRIST_1));
    current_joint_states_.at(4) = msg->velocity.at(static_cast<int>(JointPositionsInSequence::WRIST_2));
    current_joint_states_.at(5) = msg->velocity.at(static_cast<int>(JointPositionsInSequence::WRIST_3));
}

// void publishGlobalSpeed(double speed)
// {
//     // взаимодействие с ros топиками
// }

// void publishLocalSpeed(double speed, const int& controller_name)
// {
//     // взаимодействие с ros топиками
// }

// void publishIndependentSpeed(double speed, const int& controller_name)
// {
//     // взаимодействие с ros топиками
// }


