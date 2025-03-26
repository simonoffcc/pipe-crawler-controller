#ifndef WHEEL_CONTROLLER_H
#define WHEEL_CONTROLLER_H

#include <QObject>
#include <unordered_map>
#include <vector>
#include <string>
#include <set>

#include <rclcpp/rclcpp.hpp>
#include <std_msgs/msg/float64_multi_array.hpp>
#include <sensor_msgs/msg/joint_state.hpp>

#include "enums/drive_mode.h"
#include "enums/pairs_grouping_mode.h"
#include "enums/controller_names.h"
#include "enums/joint_names.h"

using DriveMode = DriveMode::Mode;
using PairsGroupingMode = PairsGroupingMode::Mode;
using ControllerName = ControllerNames::Name;
using JointName = JointNames::Name;

class WheelController : public QObject {
    Q_OBJECT
    
    // Режим управления
    Q_PROPERTY(DriveMode driveMode READ driveMode WRITE setDriveMode NOTIFY driveModeChanged)
    // Режим группировки пар
    Q_PROPERTY(PairsGroupingMode pairsGroupingMode READ pairsGroupingMode WRITE setPairsGroupingMode NOTIFY pairsGroupingModeChanged)
    // Скорости колес для отображения в GUI
    Q_PROPERTY(QVariantMap wheelSpeeds READ wheelSpeeds NOTIFY wheelSpeedsChanged)

public:
    WheelController(const WheelController &) = delete;
    WheelController &operator=(const WheelController &) = delete;
    WheelController(WheelController &&) = delete;
    WheelController &operator=(WheelController &&) = delete;
    ~WheelController() = default;
    
    explicit WheelController(std::shared_ptr<rclcpp::Node> node, QObject* parent = nullptr);

    DriveMode driveMode() const { return current_drive_mode_; }
    void setDriveMode(DriveMode mode);

    PairsGroupingMode pairsGroupingMode() const { return current_pairs_grouping_mode_; }
    void setPairsGroupingMode(PairsGroupingMode mode);

    // Методы для управления состоянием колёсных пар
    Q_INVOKABLE void setWheelPairActive(const QString& pair_id, bool active);
    Q_INVOKABLE bool isWheelPairActive(const QString& pair_id) const;
    Q_INVOKABLE void setPresetMode(int preset_id);

public slots:
    void setLeftRightWheelsSpeeds(double left_speed, double right_speed);
    void setAllWheelsSpeeds(double speed);

signals:
    void driveModeChanged();
    void pairsGroupingModeChanged();
    void wheelSpeedsChanged();
    void wheelPairStateChanged(const QString& pair_id, bool active);

private:
    

    
}; 

#endif // WHEEL_CONTROLLER_H
