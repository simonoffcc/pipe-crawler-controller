#ifndef WHEEL_CONTROLLER_H
#define WHEEL_CONTROLLER_H

#include <QObject>
#include <QQmlEngine>
#include <QVariantMap>

#include <vector>
#include <map>

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

    // Массив текущих скоростей колес
    Q_PROPERTY(QVariantMap jointSpeeds READ jointSpeeds NOTIFY jointSpeedsChanged)

public:
    WheelController(const WheelController &) = delete;
    WheelController &operator=(const WheelController &) = delete;
    WheelController(WheelController &&) = delete;
    WheelController &operator=(WheelController &&) = delete;
    ~WheelController() = default;

    static WheelController &instance(std::shared_ptr<rclcpp::Node> parent_ros_node = nullptr)
    {
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
    QVariantMap jointSpeeds() const;

public slots:
    void setDriveMode(int mode);
    void setPairsGroupingMode(int mode);
    void publishGlobalSpeed(double speed);
    // void publishLocalSpeed(double speed, const ControllerNames::Name& controller_name);
    // void publishIndependentSpeed(double speed, const ControllerNames::Name& controller_name);

signals:
    void activeControllersChanged();
    void driveModeChanged();
    void pairsGroupingModeChanged();
    void jointSpeedsChanged();

private:
    explicit WheelController(std::shared_ptr<rclcpp::Node> parent_node, QObject* parent = nullptr);
    std::shared_ptr<rclcpp::Node> node_;

    std::map<ControllerName::Name, rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr> pair_velocity_publishers_;
    rclcpp::Subscription<sensor_msgs::msg::JointState>::SharedPtr joint_state_subscriber_;

    void createROSInterfaces();
    void jointStateCallback(const sensor_msgs::msg::JointState::SharedPtr msg);

    int current_pairs_grouping_mode_;                ///< Текущий режим группировки пар
    int current_drive_mode_;                         ///< Текущий привод
    std::vector<int> active_controllers_;            ///< Множество контроллеров, получающих единую целевую скорость
    std::map<JointName::Name, double> joint_speeds_; ///< Текущие скорости колес

    double precision = 1.0;  ///< точность сравнения скорости шарниров в радианах

    void updateActiveControllers();
};

#endif // WHEEL_CONTROLLER_H
