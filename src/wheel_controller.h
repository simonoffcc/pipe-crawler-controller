#ifndef WHEEL_CONTROLLER_H
#define WHEEL_CONTROLLER_H

#include <QObject>
#include <QQmlEngine>

#include <vector>

#include <rclcpp/rclcpp.hpp>
#include <sensor_msgs/msg/joint_state.hpp>
#include <std_msgs/msg/float64_multi_array.hpp>

#include "enums/pairs_grouping_mode.h"
#include "enums/drive_mode.h"
#include "enums/joint_name.h"
#include "enums/controller_name.h"

/// \class Класс для управления скорстями групп колёсных пар робота из QML.
class WheelController : public QObject 
{
    Q_OBJECT
    
    // Режим управления, который необходим для отображения в комбо-боксах в GUI
    Q_PROPERTY(int currentDriveMode READ currentDriveMode WRITE setDriveMode NOTIFY driveModeChanged)

    // Режим группировки пар, который необходим для отображения в комбо-боксах в GUI
    Q_PROPERTY(int currentPairsGroupingMode READ currentPairsGroupingMode WRITE setPairsGroupingMode NOTIFY pairsGroupingModeChanged)
    
    // Массив, который содержит енамы всех активных пар
    Q_PROPERTY(std::vector<int> activeControllers READ activeControllers NOTIFY activeControllersChanged)

public:
    WheelController(const WheelController &) = delete;
    WheelController &operator=(const WheelController &) = delete;
    WheelController(WheelController &&) = delete;
    WheelController &operator=(WheelController &&) = delete;
    ~WheelController() = default;

    static WheelController &instance(
        std::shared_ptr<rclcpp::Node> parent_ros_node = nullptr) {
        static std::shared_ptr<rclcpp::Node> static_node;
        if (parent_ros_node) {
            static_node = parent_ros_node;
        }
        static WheelController _instance(static_node);
        return _instance;
    }

    //******************************************************************************//
    
    const std::vector<int>& activeControllers() const { return active_controllers_; }
    int currentDriveMode() const { return current_drive_mode_; }
    int currentPairsGroupingMode() const { return current_pairs_grouping_mode_; }

    //******************************************************************************//

    // void publishLocalSpeed(double speed, const ControllerNames::Name& controller_name);
    // void publishIndependentSpeed(double speed, const ControllerNames::Name& controller_name);
    // void publishGlobalSpeed(double speed);
    
    //******************************************************************************//  

public slots:
    void setDriveMode(int mode);
    void setPairsGroupingMode(int mode);

signals:
    void activeControllersChanged();
    void driveModeChanged();
    void pairsGroupingModeChanged();

private:
    explicit WheelController(std::shared_ptr<rclcpp::Node> parent_node, QObject* parent = nullptr);
    std::shared_ptr<rclcpp::Node> node_;

    void createROSInterfaces();

    //******************************************************************************//
    struct JointData {  // нужен, чтобы хранить скорость отдельного шарнира, чтобы задавать скорость только на него, а не на всю пару
        const JointName name;
        double velocity;
    };
    std::vector<JointData> joints_data_;
    //******************************************************************************//

    int current_pairs_grouping_mode_;
    int current_drive_mode_;
    std::vector<int> active_controllers_;           ///< Множество контроллеров, получающих единую целевую скорость
    // std::vector<int> local_controllers_;         ///< Множество контроллеров, управляемых локально ?
    // std::vector<int> indepedent_controllers_;    ///< Множество контроллеров, шарниры которых управляются раздельно ?



    void updateActiveControllers();
};

#endif // WHEEL_CONTROLLER_H
