#ifndef WHEEL_CONTROLLER_H
#define WHEEL_CONTROLLER_H

#include <QObject>
#include <QMap>
#include <QSet>
#include <QVariantMap>
#include <memory>
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
    Q_PROPERTY(DriveMode::Mode currentDriveMode READ currentDriveMode WRITE setDriveMode NOTIFY driveModeChanged)

    // Режим группировки пар, который необходим для отображения в комбо-боксах в GUI
    Q_PROPERTY(PairsGroupingMode::Mode currentPairsGroupingMode READ currentPairsGroupingMode WRITE setPairsGroupingMode NOTIFY pairsGroupingModeChanged)

    // QML properties
    Q_PROPERTY(QVariantMap wheelSpeeds READ wheelSpeeds NOTIFY wheelSpeedsChanged)
    Q_PROPERTY(QSet<QString> activeControllers READ activeControllers NOTIFY activeControllersChanged)

public:
    WheelController(const WheelController &) = delete;
    WheelController &operator=(const WheelController &) = delete;
    WheelController(WheelController &&) = delete;
    WheelController &operator=(WheelController &&) = delete;
    ~WheelController() = default;

    explicit WheelController(std::shared_ptr<rclcpp::Node> node, QObject* parent = nullptr);
    
    void createROSInterfaces()

    //******************************************************************************//

    QVariantMap wheelSpeeds() const;
    QSet<QString> activeControllers() const;
    DriveMode::Mode currentDriveMode() const { return current_drive_mode_; }
    PairsGroupingMode::Mode currentPairsGroupingMode() const { return current_pairs_grouping_mode_; }
    
    void setDriveMode(DriveMode::Mode mode);
    void setPairsGroupingMode(PairsGroupingMode::Mode mode);

    //******************************************************************************//

    // void publishLocalSpeed(double speed, const ControllerName& controller_name);
    // void publishIndependentSpeed(double speed, const ControllerName& controller_name);
    // void publishGlobalSpeed(double speed);
    
    //******************************************************************************//

// public slots:
    
signals:
    // Note: сигналы нужно emit'ить, чтобы QML подтягивал изменение свойства в GUI
    void wheelSpeedsChanged();
    void activeControllersChanged();
    void driveModeChanged();
    void pairsGroupingModeChanged();

private:
    // WheelController(std::shared_ptr<rclcpp::Node> parent_node);
    std::shared_ptr<rclcpp::Node> node_;
    QMap<ControllerName, rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr> wheel_publishers_;
    rclcpp::Subscription<sensor_msgs::msg::JointState>::SharedPtr joint_state_sub_;
    QMap<JointName, double> wheel_speeds_;
    QSet<ControllerName> active_controllers_;   ///< Множество контроллеров, получающих единую целевую скорость
    DriveMode::Mode current_drive_mode_{DriveMode::ALL_WHEEL_DRIVE};
    PairsGroupingMode::Mode current_pairs_grouping_mode_{PairsGroupingMode::ALL_PAIRS};

    void updateActiveControllers();
    void setWheelSpeed(JointName joint, double speed);
    QVector<double> getWheelPairSpeeds(JointName outer_joint) const;
    void setWheelPairSpeeds(JointName outer_joint, const QVector<double>& speeds);
};

#endif // WHEEL_CONTROLLER_H
