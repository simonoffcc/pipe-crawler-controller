#ifndef WHEEL_CONTROLLER_H
#define WHEEL_CONTROLLER_H

#include <rclcpp/rclcpp.hpp>
#include <std_msgs/msg/float64_multi_array.hpp>
#include <sensor_msgs/msg/joint_state.hpp>
#include <QObject>
#include <QVariant>
#include <unordered_map>

class WheelController : public QObject {
    Q_OBJECT
    
    // Режим управления по продольной оси
    Q_PROPERTY(DriveMode driveMode READ driveMode WRITE setDriveMode NOTIFY driveModeChanged)
    
    // Скорости колес для отображения в GUI
    Q_PROPERTY(QVariantMap wheelSpeeds READ wheelSpeeds NOTIFY wheelSpeedsChanged)

public:
    enum class DriveMode {
        FRONT_DRIVE = 0,
        REAR_DRIVE = 1,
        ALL_WHEEL_DRIVE = 2
    };
    Q_ENUM(DriveMode)

    explicit WheelController(std::shared_ptr<rclcpp::Node> node, QObject* parent = nullptr);
    
    DriveMode driveMode() const { return drive_mode_; }
    void setDriveMode(DriveMode mode);
    
    QVariantMap wheelSpeeds() const { return wheel_speeds_; }

public slots:
    // Слоты для установки скоростей из GUI
    void setLeftRightWheelsSpeeds(double left_speed, double right_speed);
    void setAllWheelsSpeeds(double speed);

signals:
    void driveModeChanged();
    void wheelSpeedsChanged();

private:
    void jointStateCallback(const sensor_msgs::msg::JointState::SharedPtr msg);
    void publishWheelCommands(const std::string& controller_name, double outer_speed, double inner_speed);

    std::shared_ptr<rclcpp::Node> node_;
    DriveMode drive_mode_{DriveMode::ALL_WHEEL_DRIVE};
    QVariantMap wheel_speeds_;

    // Publishers для каждого контроллера колесной пары
    std::unordered_map<std::string, rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr> wheel_publishers_;
    rclcpp::Subscription<sensor_msgs::msg::JointState>::SharedPtr joint_state_sub_;
}; 

#endif // WHEEL_CONTROLLER_H