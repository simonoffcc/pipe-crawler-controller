#ifndef WHEEL_CONTROLLER_H
#define WHEEL_CONTROLLER_H

#include <QObject>
#include <QSet>

#include <rclcpp/rclcpp.hpp>
#include <sensor_msgs/msg/joint_state.hpp>
#include <std_msgs/msg/float64_multi_array.hpp>

#include "enums/drive_mode.h"
#include "enums/pairs_grouping_mode.h"
#include "enums/controller_names.h"
#include "enums/joint_names.h"


/// \class Класс для управления скорстями групп колёсных пар робота из QML.
class WheelController : public QObject 
{
    Q_OBJECT
    
    // Режим управления, который необходим для отображения в комбо-боксах в GUI
    Q_PROPERTY(DriveMode::Mode currentDriveMode READ currentDriveMode WRITE setDriveMode NOTIFY driveModeChanged)

    // Режим группировки пар, который необходим для отображения в комбо-боксах в GUI
    Q_PROPERTY(PairsGroupingMode::Mode currentPairsGroupingMode READ currentPairsGroupingMode WRITE setPairsGroupingMode NOTIFY pairsGroupingModeChanged)
    
    Q_PROPERTY(QSet<ControllerNames::Name> activeControllers READ activeControllers NOTIFY activeControllersChanged)

public:
    WheelController(const WheelController &) = delete;
    WheelController &operator=(const WheelController &) = delete;
    WheelController(WheelController &&) = delete;
    WheelController &operator=(WheelController &&) = delete;
    ~WheelController() = default;

    explicit WheelController(std::shared_ptr<rclcpp::Node> node, QObject* parent = nullptr);

    //******************************************************************************//
    
    QSet<ControllerNames::Name> activeControllers() const;
    DriveMode::Mode currentDriveMode() const { return current_drive_mode_; }
    PairsGroupingMode::Mode currentPairsGroupingMode() const { return current_pairs_grouping_mode_; }

    //******************************************************************************//

    // void publishLocalSpeed(double speed, const ControllerNames::Name& controller_name);
    // void publishIndependentSpeed(double speed, const ControllerNames::Name& controller_name);
    // void publishGlobalSpeed(double speed);
    
    //******************************************************************************//

    Q_INVOKABLE void setDriveMode(DriveMode::Mode mode);
    Q_INVOKABLE void setPairsGroupingMode(PairsGroupingMode::Mode mode);

// public slots:

signals:
    // Note: сигналы нужно emit'ить в методах, чтобы QML подтягивал изменение свойства в GUI
    void activeControllersChanged();
    void driveModeChanged();
    void pairsGroupingModeChanged();

private:
    std::shared_ptr<rclcpp::Node> node_;

    QSet<ControllerNames::Name> active_controllers_;   ///< Множество контроллеров, получающих единую целевую скорость
    DriveMode::Mode current_drive_mode_{DriveMode::Mode::ALL_WHEEL_DRIVE};
    PairsGroupingMode::Mode current_pairs_grouping_mode_{PairsGroupingMode::Mode::ALL_PAIRS};

    void updateActiveControllers();
};

#endif // WHEEL_CONTROLLER_H
