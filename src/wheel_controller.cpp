#include "wheel_controller.h"

#include "enums/pairs_grouping_mode.h"
#include "enums/drive_mode.h"
#include "enums/joint_names.h"
#include "enums/controller_names.h"

WheelController::WheelController(std::shared_ptr<rclcpp::Node> node, QObject* parent)
    : QObject(parent)
    , node_(node)
{
    qmlRegisterType<PairsGroupingMode>("PairsGroupingMode", 1, 0, "PairsGroupingMode");
    qmlRegisterType<DriveMode>("DriveMode", 1, 0, "DriveMode");
    qmlRegisterType<JointName>("JointName", 1, 0, "JointName");
    qmlRegisterType<ControllerName>("ControllerName", 1, 0, "ControllerName");
    qmlRegisterSingletonInstance<WheelController>("WheelController", 1, 0, "WheelController", this);
}

void WheelController::createROSInterfaces()
{
    // Создание публикаторов для каждой пары колес
    for (const auto& controller : ControllerNames::getAllNames()) {
        wheel_publishers_[ControllerNames::fromString(controller)] = 
            node_->create_publisher<std_msgs::msg::Float64MultiArray>(
                "/" + controller + "/commands", 10); // 10 - размер очереди сообщений (QoS history depth)
    }

    // Подписка на состояния шарниров
    joint_state_sub_ = node_->create_subscription<sensor_msgs::msg::JointState>(
        "/joint_states", 10,
        [this](const sensor_msgs::msg::JointState::SharedPtr msg) {
            // Обновление скоростей из сообщения
            for (size_t i = 0; i < msg->name.size(); ++i) {
                auto joint_name = JointNames::fromString(msg->name[i]);
                if (joint_name != JointName::UNKNOWN) {
                    wheel_speeds_[joint_name] = msg->velocity[i];
                }
            }
            emit wheelSpeedsChanged();
        });
}

void WheelController::setDriveMode(DriveMode::Mode mode)
{
    if (current_drive_mode_ != mode) {
        current_drive_mode_ = mode;
        updateActiveControllers();
    }
}

void WheelController::setPairsGroupingMode(PairsGroupingMode::Mode mode)
{
    if (current_pairs_grouping_mode_ != mode) {
        current_pairs_grouping_mode_ = mode;
        updateActiveControllers();
    }
}

void WheelController::updateActiveControllers()
{
    active_controllers_.clear();

    if (current_pairs_grouping_mode_ == PairsGroupingMode::Mode::ALL_PAIRS) {
        switch (current_drive_mode_) {
            case DriveMode::Mode::ALL_WHEEL_DRIVE:
                active_controllers_.insert(ControllerName::FRONT_LEFT);
                active_controllers_.insert(ControllerName::FRONT_UP);
                active_controllers_.insert(ControllerName::FRONT_RIGHT);
                active_controllers_.insert(ControllerName::BACK_LEFT);
                active_controllers_.insert(ControllerName::BACK_UP);
                active_controllers_.insert(ControllerName::BACK_RIGHT);
                break;

            case DriveMode::Mode::FRONT_DRIVE:
                active_controllers_.insert(ControllerName::FRONT_LEFT);
                active_controllers_.insert(ControllerName::FRONT_UP);
                active_controllers_.insert(ControllerName::FRONT_RIGHT);
                break;

            case DriveMode::Mode::REAR_DRIVE:
                active_controllers_.insert(ControllerName::BACK_LEFT);
                active_controllers_.insert(ControllerName::BACK_UP);
                active_controllers_.insert(ControllerName::BACK_RIGHT);
                break;

            default:
                break;
        }
    }
    else if (current_pairs_grouping_mode_ == PairsGroupingMode::Mode::LEFT_RIGHT) {
        switch (current_drive_mode_) {
            case DriveMode::Mode::ALL_WHEEL_DRIVE:
                active_controllers_.insert(ControllerName::FRONT_LEFT);
                active_controllers_.insert(ControllerName::FRONT_RIGHT);
                active_controllers_.insert(ControllerName::BACK_LEFT);
                active_controllers_.insert(ControllerName::BACK_RIGHT);
                break;

            case DriveMode::Mode::FRONT_DRIVE:
                active_controllers_.insert(ControllerName::FRONT_LEFT);
                active_controllers_.insert(ControllerName::FRONT_RIGHT);
                break;

            case DriveMode::Mode::REAR_DRIVE:
                active_controllers_.insert(ControllerName::BACK_LEFT);
                active_controllers_.insert(ControllerName::BACK_RIGHT);
                break;

            default:
                break;
        }
    }

    emit activeControllersChanged();
}



// void publishLocalSpeed(double speed, const ControllerName& controller_name) 
// {
//     // взаимодействие с ros топиками
// }

// void publishIndependentSpeed(double speed, const ControllerName& controller_name) 
// {
//     // взаимодействие с ros топиками
// }

// void publishGlobalSpeed(double speed) 
// {
//     // взаимодействие с ros топиками
// }
