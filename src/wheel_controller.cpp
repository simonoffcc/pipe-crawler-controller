#include "wheel_controller.h"

WheelController::WheelController(std::shared_ptr<rclcpp::Node> node, QObject* parent)
    : QObject(parent)
    , node_(node)
{}

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
                active_controllers_.insert(ControllerNames::Name::FRONT_LEFT);
                active_controllers_.insert(ControllerNames::Name::FRONT_UP);
                active_controllers_.insert(ControllerNames::Name::FRONT_RIGHT);
                active_controllers_.insert(ControllerNames::Name::BACK_LEFT);
                active_controllers_.insert(ControllerNames::Name::BACK_UP);
                active_controllers_.insert(ControllerNames::Name::BACK_RIGHT);
                break;

            case DriveMode::Mode::FRONT_DRIVE:
                active_controllers_.insert(ControllerNames::Name::FRONT_LEFT);
                active_controllers_.insert(ControllerNames::Name::FRONT_UP);
                active_controllers_.insert(ControllerNames::Name::FRONT_RIGHT);
                break;

            case DriveMode::Mode::REAR_DRIVE:
                active_controllers_.insert(ControllerNames::Name::BACK_LEFT);
                active_controllers_.insert(ControllerNames::Name::BACK_UP);
                active_controllers_.insert(ControllerNames::Name::BACK_RIGHT);
                break;

            default:
                break;
        }
    }
    else if (current_pairs_grouping_mode_ == PairsGroupingMode::Mode::LEFT_RIGHT) {
        switch (current_drive_mode_) {
            case DriveMode::Mode::ALL_WHEEL_DRIVE:
                active_controllers_.insert(ControllerNames::Name::FRONT_LEFT);
                active_controllers_.insert(ControllerNames::Name::FRONT_RIGHT);
                active_controllers_.insert(ControllerNames::Name::BACK_LEFT);
                active_controllers_.insert(ControllerNames::Name::BACK_RIGHT);
                break;

            case DriveMode::Mode::FRONT_DRIVE:
                active_controllers_.insert(ControllerNames::Name::FRONT_LEFT);
                active_controllers_.insert(ControllerNames::Name::FRONT_RIGHT);
                break;

            case DriveMode::Mode::REAR_DRIVE:
                active_controllers_.insert(ControllerNames::Name::BACK_LEFT);
                active_controllers_.insert(ControllerNames::Name::BACK_RIGHT);
                break;

            default:
                break;
        }
    }

    emit activeControllersChanged();
}

QSet<ControllerNames::Name> WheelController::activeControllers() const {
    return active_controllers_;
}

// void publishLocalSpeed(double speed, const ControllerNames::Name& controller_name) 
// {
//     // взаимодействие с ros топиками
// }

// void publishIndependentSpeed(double speed, const ControllerNames::Name& controller_name) 
// {
//     // взаимодействие с ros топиками
// }

// void publishGlobalSpeed(double speed) 
// {
//     // взаимодействие с ros топиками
// }
