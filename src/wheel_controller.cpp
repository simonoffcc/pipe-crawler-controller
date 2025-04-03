#include "wheel_controller.h"

#include "enums/drive_mode.h"
#include "enums/pairs_grouping_mode.h"
#include "enums/joint_name.h"
#include "enums/controller_name.h"

WheelController::WheelController(std::shared_ptr<rclcpp::Node> node, QObject* parent)
    : QObject(parent)
    , node_(node)
    , current_pairs_grouping_mode_(PairsGroupingMode::AllPairs)
    , current_drive_mode_(DriveMode::AllWheelDrive)
{
    qmlRegisterUncreatableType<PairsGroupingMode>("pairsGroupingMode", 1, 0, "PairsGroupingMode", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<DriveMode>("driveMode", 1, 0, "DriveMode", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<JointName>("JointName", 1, 0, "JointName", "Not creatable as it is an enum type.");
    qmlRegisterUncreatableType<ControllerName>("controllerName", 1, 0, "ControllerName", "Not creatable as it is an enum type.");
    qmlRegisterSingletonInstance<WheelController>("WheelController", 1, 0, "WheelController", this);
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


