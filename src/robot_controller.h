#ifndef ROBOT_CONTROLLER_H
#define ROBOT_CONTROLLER_H

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
#include "enums/wheel_joint_name.h"
#include "enums/wheels_controller_name.h"
#include "enums/wheels_controller_state.h"
#include "enums/ray_name.h"

/// \class Класс для управления скорстями групп колёсных пар робота из QML
class RobotController : public QObject
{
    Q_OBJECT

    // Режим управления, который необходим для отображения в комбо-боксах в GUI
    Q_PROPERTY(int currentDriveMode READ currentDriveMode WRITE setDriveMode NOTIFY driveModeChanged)

    // Режим группировки пар, который необходим для отображения в комбо-боксах в GUI
    Q_PROPERTY(int currentPairsGroupingMode READ currentPairsGroupingMode WRITE setPairsGroupingMode NOTIFY pairsGroupingModeChanged)

    // Массив контроллеров колесных пар для хранения телеметрии шарниров, лучей и усилий
    Q_PROPERTY(QVariantList controllers READ controllers NOTIFY controllersChanged)

    // Property for log messages
    Q_PROPERTY(QStringList logMessages READ logMessages NOTIFY logMessagesChanged)

public:
    RobotController(const RobotController &) = delete;
    RobotController &operator=(const RobotController &) = delete;
    RobotController(RobotController &&) = delete;
    RobotController &operator=(RobotController &&) = delete;
    ~RobotController() = default;

    static RobotController &instance(std::shared_ptr<rclcpp::Node> parent_ros_node = nullptr)
    {
        static std::shared_ptr<rclcpp::Node> static_node;
        if (parent_ros_node) {
            static_node = parent_ros_node;
        }
        static RobotController _instance(static_node);
        return _instance;
    }

    QVariantList controllers() const;
    int currentDriveMode() const { return current_drive_mode_; }
    int currentPairsGroupingMode() const { return current_pairs_grouping_mode_; }
    QStringList logMessages() const { return log_messages_; }

    Q_INVOKABLE void addLogMessage(const QString& message);
    Q_INVOKABLE void clearLogMessages();

public slots:
    void setDriveMode(int mode);
    void setPairsGroupingMode(int mode);
    void publishGlobalSpeed(double speed);
    void publishLocalSpeed(double speed, int controller_name);
    void publishIndependentSpeed(double speed, int controller_name, bool is_outer_joint);
    void publishRayPosition(double position, int ray_name);
    void setWheelsControllerState(int controller_name, int state);

signals:
    void controllersChanged();
    void driveModeChanged();
    void pairsGroupingModeChanged();
    void logMessagesChanged();

private:
    explicit RobotController(std::shared_ptr<rclcpp::Node> parent_node, QObject* parent = nullptr);
    std::shared_ptr<rclcpp::Node> node_;

    std::map<WheelsControllerName::Name, rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr> pair_velocity_publishers_;
    std::map<RayName::Name, rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr> ray_position_publishers_;
    rclcpp::Subscription<sensor_msgs::msg::JointState>::SharedPtr joint_state_subscriber_;

    void createROSInterfaces();
    void jointStatesCallback(const sensor_msgs::msg::JointState::SharedPtr msg);
    void updateActiveControllers();
    void updateGlobalControllersCount();
    void publishSpeed(rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr, std_msgs::msg::Float64MultiArray msg);

    int current_pairs_grouping_mode_;   ///< Текущий режим группировки пар
    int current_drive_mode_;            ///< Текущий привод
    int global_controllers_count_ = 0;  ///< Количество контроллеров в глобальном режиме

    struct Joint {
        int name;
        double position;
        double velocity;
        double effort;
    };

    struct Controller {
        int wheels_controller_name;
        int wheels_controller_state;
        Joint outer_joint;
        Joint inner_joint;
        Joint ray_joint;
    };

    std::vector<Controller> controllers_;   ///< Массив контроллеров колесных пар
    double velocity_step = 0.001;           ///< Шаг для сравнения текущей и предыдущей скорости шарниров в радианах
    double effort_step = 0.1;
    double ray_position_step = 0.001;       ///< Шаг для сравнения текущей и предыдущей скорости шарниров в метрах

    QStringList log_messages_;
    static const int MAX_LOG_MESSAGES = 100;
};

#endif // ROBOT_CONTROLLER_H
