#ifndef VELOCITY_CONTROLLER_H
#define VELOCITY_CONTROLLER_H

#include <QObject>
#include <QVector>
#include <QMutex>
#include <QString>
#include <QQmlEngine>
#include <QMap>

#include <rclcpp/rclcpp.hpp>
#include <std_msgs/msg/float64_multi_array.hpp>
#include <sensor_msgs/msg/joint_state.hpp>

class VelocityController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString driveMode READ getDriveMode WRITE setDriveMode NOTIFY driveModeChanged)
    Q_PROPERTY(QString controlMode READ getControlMode WRITE setControlMode NOTIFY controlModeChanged)

public:
    explicit VelocityController(QObject *parent = nullptr);

    VelocityController(const VelocityController &) = delete;
    VelocityController &operator=(const VelocityController &) = delete;
    VelocityController(VelocityController &&) = delete;
    VelocityController &operator=(VelocityController &&) = delete;
    ~VelocityController() {}

    // Режимы привода
    Q_INVOKABLE void setDriveMode(const QString &mode); // "all", "front", "back"
    Q_INVOKABLE QString getDriveMode() const { return driveMode; }

    // Режимы управления
    Q_INVOKABLE void setControlMode(const QString &mode); // "sides", "transverse"
    Q_INVOKABLE QString getControlMode() const { return controlMode; }

    // Управление скоростью для режима sides (левые и правые пары)
    Q_INVOKABLE void setSideSpeed(const QString &side, double speed); // side: "left", "right"
    Q_INVOKABLE double getSideSpeed(const QString &side) const;

    // Управление скоростью для режима transverse (поперечные пары)
    Q_INVOKABLE void setTransverseSpeed(const QString &position, double speed); // position: "up", "left", "right"
    Q_INVOKABLE double getTransverseSpeed(const QString &position) const;

    // Получение текущей скорости конкретного колеса
    Q_INVOKABLE double getWheelSpeed(const QString &longitudinal, 
                                    const QString &transverse,
                                    const QString &wheel) const;

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
    void driveModeChanged(QString mode);
    void controlModeChanged(QString mode);
    void wheelSpeedUpdated(QString jointName, double speed);
    void speedUpdated(int pairIndex, int wheelIndex, double speed); // Сигнал для обновления скорости

private:
    struct WheelPair {
        QString controllerName;
        QString outerWheelJoint;
        QString innerWheelJoint;
        double targetSpeed{0.0};
        double outerWheelSpeed{0.0};
        double innerWheelSpeed{0.0};
    };

    QString driveMode{"all"}; // "all", "front", "back"
    QString controlMode{"sides"}; // "sides", "transverse"
    
    QMap<QString, WheelPair> wheelPairs; // Ключ: "front_left", "back_right" и т.д.
    mutable QMutex mutex;

    // ROS2
    rclcpp::Node::SharedPtr rosNode;
    QMap<QString, rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr> controllers;
    rclcpp::Subscription<sensor_msgs::msg::JointState>::SharedPtr jointStatesSub;

    void initializeROS();
    void initializeWheelPairs();
    void publishWheelPairSpeed(const QString &pairKey);
    void jointStatesCallback(const sensor_msgs::msg::JointState::SharedPtr msg);
    
    // Вспомогательные методы
    QStringList getActivePairs() const; // Возвращает список активных пар в зависимости от режима
    void updateWheelPairSpeeds(const QString &side, double speed);
    void updateTransversePairSpeeds(const QString &position, double speed);
};

#endif // VELOCITY_CONTROLLER_H