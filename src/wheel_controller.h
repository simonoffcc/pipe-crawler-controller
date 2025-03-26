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
    
    // Режим управления
    Q_PROPERTY(DriveMode driveMode READ driveMode WRITE setDriveMode NOTIFY driveModeChanged)
    // Режим группировки пар
    Q_PROPERTY(PairsGroupingMode pairsGroupingMode READ pairsGroupingMode WRITE setPairsGroupingMode NOTIFY pairsGroupingModeChanged)
    // Скорости колес для отображения в GUI
    Q_PROPERTY(QVariantMap wheelSpeeds READ wheelSpeeds NOTIFY wheelSpeedsChanged)

public:
    explicit WheelController(std::shared_ptr<rclcpp::Node> node, QObject* parent = nullptr);

    WheelController(const WheelController &) = delete;
    WheelController &operator=(const WheelController &) = delete;
    WheelController(WheelController &&) = delete;
    WheelController &operator=(WheelController &&) = delete;
    ~WheelController() = default;

    /// @brief Note/question: как я понял, механизм реализации подключения к родительскому узлу, должно пригодиться в будущем
    // static WheelController &instance(std::shared_ptr<rclcpp::Node> parent_ros_node = nullptr) 
    // {
    //     static std::shared_ptr<rclcpp::Node> static_node;
    //     if (parent_ros_node) {
    //         static_node = parent_ros_node;
    //     }
    //     static WheelController _instance(static_node);
    //     return _instance;
    // }
    
    void createROSInterfaces();

    DriveMode driveMode() const { return current_drive_mode_; }
    PairsGroupingMode pairsGroupingMode() const { return current_pairs_grouping_mode_; }
    
    void setDriveMode(DriveMode mode);
    void setPairsGroupingMode(PairsGroupingMode mode);

public slots:
    
signals:
    void driveModeChanged();
    void pairsGroupingModeChanged();
    void wheelPairStateChanged(const QString& pair_id, bool active);

private:
    ManipulatorController(std::shared_ptr<rclcpp::Node> parent_node);
    
}; 

#endif // WHEEL_CONTROLLER_H
