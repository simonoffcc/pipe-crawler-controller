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

/// \class Класс для управления скорстями групп колёсных пар робота из QML
class WheelController : public QObject
{
    Q_OBJECT

    // Режим управления, который необходим для отображения в комбо-боксах в GUI
    Q_PROPERTY(int currentDriveMode READ currentDriveMode WRITE setDriveMode NOTIFY driveModeChanged)

    // Режим группировки пар, который необходим для отображения в комбо-боксах в GUI
    Q_PROPERTY(int currentPairsGroupingMode READ currentPairsGroupingMode WRITE setPairsGroupingMode NOTIFY pairsGroupingModeChanged)

    // Массив контроллеров колесных пар
    Q_PROPERTY(QVariantList controllers READ controllers NOTIFY controllersChanged)

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

    QVariantList controllers() const;
    int currentDriveMode() const { return current_drive_mode_; }
    int currentPairsGroupingMode() const { return current_pairs_grouping_mode_; }
    Q_INVOKABLE double getVelocityStep() const { return velocity_step; }

public slots:
    void setDriveMode(int mode);
    void setPairsGroupingMode(int mode);
    void publishGlobalSpeed(double speed);
    void publishLocalSpeed(double speed, int controller_name);
    void publishIndependentSpeed(double speed, int controller_name, bool is_outer_joint);
    void setControllerState(int controller_name, int state);

signals:
    void controllersChanged();
    void driveModeChanged();
    void pairsGroupingModeChanged();

private:
    explicit WheelController(std::shared_ptr<rclcpp::Node> parent_node, QObject* parent = nullptr);
    std::shared_ptr<rclcpp::Node> node_;

    std::map<ControllerName::Name, rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr> pair_velocity_publishers_;
    rclcpp::Subscription<sensor_msgs::msg::JointState>::SharedPtr joint_state_subscriber_;

    void createROSInterfaces();
    void publishSpeed(rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr, std_msgs::msg::Float64MultiArray msg);
    void jointStateCallback(const sensor_msgs::msg::JointState::SharedPtr msg);
    void updateActiveControllers();



    int current_pairs_grouping_mode_;   ///< Текущий режим группировки пар
    int current_drive_mode_;            ///< Текущий привод

    enum class ControlState {
        GLOBAL = 0,
        LOCAL = 1,
        INDEPENDENT = 2
    };

    struct Joint {
        JointName::Name name;
        double velocity;
    };

    struct Controller {
        ControllerName::Name name;
        ControlState state;
        Joint outer_joint;
        Joint inner_joint;
    };

    std::vector<Controller> controllers_;   ///< Массив контроллеров колесных пар
    double velocity_step = 0.001;  ///< шаг для сравнения текущей и предыдущей скорости шарниров в радианах
};

#endif // WHEEL_CONTROLLER_H
