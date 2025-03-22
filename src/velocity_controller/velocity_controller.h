#ifndef VELOCITY_CONTROLLER_H
#define VELOCITY_CONTROLLER_H

#include <QObject>
#include <QVector>
#include <QMutex>
#include <QString>
#include <QQmlEngine>

#include <rclcpp/rclcpp.hpp>
#include <std_msgs/msg/float32.hpp>
#include <geometry_msgs/msg/twist.hpp>

class VelocityController : public QObject {
    Q_OBJECT

public:
    explicit VelocityController(QObject *parent = nullptr);

    VelocityController(const VelocityController &) = delete;
    VelocityController &operator=(const VelocityController &) = delete;
    VelocityController(VelocityController &&) = delete;
    VelocityController &operator=(VelocityController &&) = delete;
    ~VelocityController() {}

    // Управление скоростью
    Q_INVOKABLE void setGlobalSpeed(double speed);
    Q_INVOKABLE void setLocalSpeed(int pairIndex, double speed);
    Q_INVOKABLE void setIndependentSpeed(int pairIndex, int wheelIndex, double speed);

    // Публикация скоростей
    Q_INVOKABLE void publishGlobalSpeed();
    Q_INVOKABLE void publishLocalSpeed(int pairIndex);
    Q_INVOKABLE void publishIndependentSpeed(int pairIndex);

    // Получение текущих скоростей
    Q_INVOKABLE double getGlobalSpeed() const;
    Q_INVOKABLE double getLocalSpeed(int pairIndex) const;
    Q_INVOKABLE double getIndependentSpeed(int pairIndex, int wheelIndex) const;

    // Управление состоянием мнемосхемы
    Q_INVOKABLE void setGlobalControl();
    Q_INVOKABLE void setLocalControl(int pairIndex);
    Q_INVOKABLE void setIndependentControl(int pairIndex);

signals:
    void speedUpdated(int pairIndex, int wheelIndex, double speed); // Сигнал для обновления скорости
    void controlModeChanged(int pairIndex, QString mode); // Сигнал для изменения режима управления

private:
    struct WheelPair {
        double globalSpeed = 0.0;
        double localSpeed = 0.0;
        double leftWheelSpeed = 0.0;
        double rightWheelSpeed = 0.0;
        QString controlMode = "global"; // "global", "local", "independent"
    };

    QVector<WheelPair> wheelPairs;
    mutable QMutex mutex;

    // ROS2
    rclcpp::Node::SharedPtr rosNode;
    rclcpp::Publisher<std_msgs::msg::Float32>::SharedPtr globalSpeedPublisher;
    QVector<rclcpp::Publisher<std_msgs::msg::Float32>::SharedPtr> localSpeedPublishers;
    QVector<rclcpp::Publisher<std_msgs::msg::Float32>::SharedPtr> independentSpeedPublishers;

    // Подписки на топики телеметрии
    rclcpp::Subscription<geometry_msgs::msg::Twist>::SharedPtr telemetrySubscription;
    QVector<rclcpp::Subscription<std_msgs::msg::Float32>::SharedPtr> wheelSpeedSubscriptions;

    void initializeROS();
    void publishSpeed(const rclcpp::Publisher<std_msgs::msg::Float32>::SharedPtr &publisher, double speed);

    // Обработчики для подписок
    void telemetryCallback(const geometry_msgs::msg::Twist::SharedPtr msg);
    void wheelSpeedCallback(const std_msgs::msg::Float32::SharedPtr msg, int pairIndex, int wheelIndex);
};

#endif // VELOCITY_CONTROLLER_H