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
#include "enums/wheel_pair_name.h"
#include "enums/ray_name.h"

/// \class Класс для управления скорстями групп колёсных пар робота из QML
class WheelController : public QObject
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
    QStringList logMessages() const { return log_messages_; }

    Q_INVOKABLE void addLogMessage(const QString& message);
    Q_INVOKABLE void clearLogMessages();

public slots:
    void setDriveMode(int mode);
    void setPairsGroupingMode(int mode);
    void publishGlobalSpeed(double speed);
    void publishLocalSpeed(double speed, int controller_name);
    void publishIndependentSpeed(double speed, int controller_name, bool is_outer_joint);
    void setWheelPairState(int controller_name, int state);

signals:
    void controllersChanged();
    void driveModeChanged();
    void pairsGroupingModeChanged();
    void logMessagesChanged();

private:
    explicit WheelController(std::shared_ptr<rclcpp::Node> parent_node, QObject* parent = nullptr);
    std::shared_ptr<rclcpp::Node> node_;

    std::map<WheelPairName::Name, rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr> pair_velocity_publishers_;
    rclcpp::Subscription<sensor_msgs::msg::JointState>::SharedPtr joint_state_subscriber_;

    void createROSInterfaces();
    void jointStateCallback(const sensor_msgs::msg::JointState::SharedPtr msg);
    void updateActiveControllers();
    void updateGlobalControllersCount();
    void publishSpeed(rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr, std_msgs::msg::Float64MultiArray msg);

    int current_pairs_grouping_mode_;   ///< Текущий режим группировки пар
    int current_drive_mode_;            ///< Текущий привод
    int global_controllers_count_ = 0;  ///< Количество контроллеров в глобальном режиме

    enum class WheelPairState {
        Global = 0,
        Local = 1,
        Independent = 2
    };

    struct Joint {
        JointName::Name name;
        double velocity;
    };

    struct Controller {  ///< Структура для хранения информации колёсной пары и луча
        WheelPairName::Name wheel_pair_name;
        RayName::Name ray_name;
        WheelPairState state;
        Joint outer_joint;
        Joint inner_joint;
        double ray_position;  ///< Позиция луча в метрах
    };

    std::vector<Controller> controllers_;   ///< Массив контроллеров колесных пар
    double velocity_step = 0.001;  ///< шаг для сравнения текущей и предыдущей скорости шарниров в радианах

    QStringList log_messages_;
    static const int MAX_LOG_MESSAGES = 100;
};

#endif // WHEEL_CONTROLLER_H
