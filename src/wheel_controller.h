#ifndef WHEEL_CONTROLLER_H
#define WHEEL_CONTROLLER_H

#include <QObject>
#include <unordered_map>
#include <vector>
#include <string>
#include <set>

#include <rclcpp/rclcpp.hpp>
#include <sensor_msgs/msg/joint_state.hpp>
#include <std_msgs/msg/float64_multi_array.hpp>

#include "enums/drive_mode.h"
#include "enums/pairs_grouping_mode.h"
#include "enums/controller_names.h"
#include "enums/joint_names.h"

using DriveMode = DriveMode::Mode;
using PairsGroupingMode = PairsGroupingMode::Mode;
using JointName = JointNames::Name;
using ControllerName = ControllerNames::Name;

/// \class Класс для управления скорстями групп колёсных пар робота из QML.
class WheelController : public QObject 
{
    Q_OBJECT
    
    // Режим управления, который необходим для отображения в комбо-боксах в GUI
    Q_PROPERTY(DriveMode driveMode READ driveMode WRITE setDriveMode NOTIFY driveModeChanged)

    // Режим группировки пар, который необходим для отображения в комбо-боксах в GUI
    Q_PROPERTY(PairsGroupingMode pairsGroupingMode READ pairsGroupingMode WRITE setPairsGroupingMode NOTIFY pairsGroupingModeChanged)

public:
    WheelController(const WheelController &) = delete;
    WheelController &operator=(const WheelController &) = delete;
    WheelController(WheelController &&) = delete;
    WheelController &operator=(WheelController &&) = delete;
    ~WheelController() = default;

    explicit WheelController(std::shared_ptr<rclcpp::Node> node, QObject* parent = nullptr);
    
    void createROSInterfaces()

    //******************************************************************************//

    DriveMode driveMode() const { return current_drive_mode_; }
    PairsGroupingMode pairsGroupingMode() const { return current_pairs_grouping_mode_; }
    
    void setDriveMode(DriveMode mode);
    void setPairsGroupingMode(PairsGroupingMode mode);

    //******************************************************************************//

    // void publishLocalSpeed(double speed, const ControllerName& controller_name);
    // void publishIndependentSpeed(double speed, const ControllerName& controller_name);
    // void publishGlobalSpeed(double speed);
    
    //******************************************************************************//

// public slots:
    
signals:
    // Note: сигналы нужно emit'ить, чтобы QML подтягивал изменение свойства в GUI
    void driveModeChanged();
    void pairsGroupingModeChanged();

private:
    // WheelController(std::shared_ptr<rclcpp::Node> parent_node);
    std::shared_ptr<rclcpp::Node> node_;
    DriveMode current_drive_mode_{DriveMode::ALL_WHEEL_DRIVE};
    PairsGroupingMode current_pairs_grouping_mode_{PairsGroupingMode::ALL_PAIRS};
 
    std::set<ControllerName> active_controllers_;   ///< Множество контроллеров, получающих единую целевую скорость
};

#endif // WHEEL_CONTROLLER_H
