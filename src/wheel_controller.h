#ifndef WHEEL_CONTROLLER_H
#define WHEEL_CONTROLLER_H

#include <QObject>
#include <unordered_map>

#include <rclcpp/rclcpp.hpp>
#include <std_msgs/msg/float64_multi_array.hpp>
#include <sensor_msgs/msg/joint_state.hpp>

#include "helpers/drive_mode.h"
#include "helpers/pairs_grouping_mode.h"

namespace {
    const std::vector<std::string> CONTROLLER_NAMES = {
        "front_left_wheels_controller",
        "front_up_wheels_controller",
        "front_right_wheels_controller",
        "back_left_wheels_controller",
        "back_up_wheels_controller"
        "back_right_wheels_controller",
    };
        
    const std::vector<std::string> JOINT_NAMES = {
        "front_left_outer_wheel_joint",
        "front_left_inner_wheel_joint",
        "front_up_outer_wheel_joint",
        "front_up_inner_wheel_joint",
        "front_right_outer_wheel_joint",
        "front_right_inner_wheel_joint",
        "back_left_outer_wheel_joint",
        "back_left_inner_wheel_joint",
        "back_up_outer_wheel_joint"
        "back_up_inner_wheel_joint",
        "back_right_outer_wheel_joint",
        "back_right_inner_wheel_joint",
    };
}

class WheelController : public QObject {
    Q_OBJECT
    
    // Режим управления по продольной оси
    Q_PROPERTY(DriveMode driveMode READ driveMode WRITE setDriveMode NOTIFY driveModeChanged)

    // Скорости колес для отображения в GUI
    Q_PROPERTY(QVariantMap wheelSpeeds READ wheelSpeeds NOTIFY wheelSpeedsChanged)

public:
    WheelController(const WheelController &) = delete;
    WheelController &operator=(const WheelController &) = delete;
    WheelController(WheelController &&) = delete;
    WheelController &operator=(WheelController &&) = delete;
    ~WheelController() { /*delete something_ if needed;*/ }
    
    explicit WheelController(std::shared_ptr<rclcpp::Node> node, QObject* parent = nullptr);

    using DriveMode = DriveMode::Mode;
    using PairsGroupingMode = PairsGroupingMode::Mode;

    DriveMode getDriveMode() const { return drive_mode_; }
    void setDriveMode(DriveMode mode);

public slots:
    void setLeftRightWheelsSpeeds(double left_speed, double right_speed);
    void setAllWheelsSpeeds(double speed);

signals:
    void driveModeChanged();
    void wheelSpeedsChanged();

private:
    double precision = 1;  ///< точность сравнения скорости шарниров перед отображением в радианах

    std::shared_ptr<rclcpp::Node> node_;
    DriveMode current_drive_mode_{DriveMode::ALL_WHEEL_DRIVE}; ///< Текущий пресет управления 
    PairsGroupingMode current_pairs_grouping_mode_{PairsGroupingMode::ALL_PAIRS} ///< Текущий режим привода робота

    void jointStateCallback(const sensor_msgs::msg::JointState::SharedPtr msg);
    void publishWheelCommands(const std::string& controller_name, double outer_speed, double inner_speed);

    std::unordered_map<std::string, rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr> wheel_publishers_;
    rclcpp::Subscription<sensor_msgs::msg::JointState>::SharedPtr joint_state_sub_;
}; 

#endif // WHEEL_CONTROLLER_H