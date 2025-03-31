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

    if (current_pairs_grouping_mode_ == PairsGroupingMode::Mode::AllPairs) {
        switch (current_drive_mode_) {
            case DriveMode::Mode::AllWheelDrive:
                active_controllers_.push_back(ControllerNames::Name::FrontLeft);
                active_controllers_.push_back(ControllerNames::Name::FrontUp);
                active_controllers_.push_back(ControllerNames::Name::FrontRight);
                active_controllers_.push_back(ControllerNames::Name::BackLeft);
                active_controllers_.push_back(ControllerNames::Name::BackUp);
                active_controllers_.push_back(ControllerNames::Name::BackRight);
                break;

            case DriveMode::Mode::FrontDrive:
                active_controllers_.push_back(ControllerNames::Name::FrontLeft);
                active_controllers_.push_back(ControllerNames::Name::FrontUp);
                active_controllers_.push_back(ControllerNames::Name::FrontRight);
                break;

            case DriveMode::Mode::RearDrive:
                active_controllers_.push_back(ControllerNames::Name::BackLeft);
                active_controllers_.push_back(ControllerNames::Name::BackUp);
                active_controllers_.push_back(ControllerNames::Name::BackRight);
                break;

            default:
                break;
        }
    }
    else if (current_pairs_grouping_mode_ == PairsGroupingMode::Mode::LeftRight) {
        switch (current_drive_mode_) {
            case DriveMode::Mode::AllWheelDrive:
                active_controllers_.push_back(ControllerNames::Name::FrontLeft);
                active_controllers_.push_back(ControllerNames::Name::FrontRight);
                active_controllers_.push_back(ControllerNames::Name::BackLeft);
                active_controllers_.push_back(ControllerNames::Name::BackRight);
                break;

            case DriveMode::Mode::FrontDrive:
                active_controllers_.push_back(ControllerNames::Name::FrontLeft);
                active_controllers_.push_back(ControllerNames::Name::FrontRight);
                break;

            case DriveMode::Mode::RearDrive:
                active_controllers_.push_back(ControllerNames::Name::BackLeft);
                active_controllers_.push_back(ControllerNames::Name::BackRight);
                break;

            default:
                break;
        }
    }

    emit activeControllersChanged();
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
