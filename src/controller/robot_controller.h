#ifndef ROBOT_CONTROLLER_H
#define ROBOT_CONTROLLER_H

#include <QObject>
#include <QQmlEngine>

#include <QVariantMap>
#include <array>
#include <map>

#include <rclcpp/rclcpp.hpp>
#include <sensor_msgs/msg/joint_state.hpp>
#include <std_msgs/msg/float64_multi_array.hpp>

#include "helpers/drive_mode.h"
#include "helpers/pairs_grouping_mode.h"
#include "helpers/ray_joint_name.h"
#include "helpers/wheel_joint_name.h"
#include "helpers/wheels_controller_name.h"
#include "helpers/wheels_controller_state.h"

/// \class RobotController
/// \brief Класс для погруппового управления скоростью колёсных пар робота
class RobotController : public QObject {
  Q_OBJECT

  Q_PROPERTY(DriveMode::Mode currentDriveMode READ currentDriveMode WRITE setDriveMode NOTIFY driveModeChanged)

  Q_PROPERTY(PairsGroupingMode::Mode currentPairsGroupingMode READ currentPairsGroupingMode WRITE setPairsGroupingMode
                 NOTIFY pairsGroupingModeChanged)

  Q_PROPERTY(QVariantList controllers READ controllers NOTIFY controllersChanged)

  Q_PROPERTY(QStringList logMessages READ logMessages NOTIFY logMessagesChanged)

 public:
  RobotController(const RobotController&) = delete;
  RobotController& operator=(const RobotController&) = delete;
  RobotController(RobotController&&) = delete;
  RobotController& operator=(RobotController&&) = delete;
  ~RobotController() = default;

  static RobotController& instance(std::shared_ptr<rclcpp::Node> parent_ros_node = nullptr) {
    static std::shared_ptr<rclcpp::Node> static_node;
    if (parent_ros_node) {
      static_node = parent_ros_node;
    }
    static RobotController _instance(static_node);
    return _instance;
  }

 public:
  QVariantList controllers() const;
  DriveMode::Mode currentDriveMode() const { return current_drive_mode_; }
  PairsGroupingMode::Mode currentPairsGroupingMode() const { return current_pairs_grouping_mode_; }
  QStringList logMessages() const { return log_messages_; }

  Q_INVOKABLE void addLogMessage(const QString& message);
  Q_INVOKABLE void clearLogMessages();

 public slots:
  void publishGlobalSpeed(double speed);
  void publishLocalSpeed(double speed, WheelsControllerName::Name controller_name);
  void publishIndependentSpeed(double speed, WheelsControllerName::Name controller_name, bool is_outer_joint);
  void publishRayPosition(double position, RayJointName::Name ray_name);

 public slots:
  void setDriveMode(DriveMode::Mode mode);
  void setPairsGroupingMode(PairsGroupingMode::Mode mode);
  void setWheelsControllerState(WheelsControllerName::Name controller_name, WheelsControllerState::State state);

 private:
  explicit RobotController(std::shared_ptr<rclcpp::Node> parent_node, QObject* parent = nullptr);
  std::shared_ptr<rclcpp::Node> node_;

 private:
  std::map<WheelsControllerName::Name, rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr>
      pair_velocity_publishers_;
  std::map<RayJointName::Name, rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr> ray_position_publishers_;
  rclcpp::Subscription<sensor_msgs::msg::JointState>::SharedPtr joint_state_subscriber_;

  void createROSInterfaces();
  void jointStatesCallback(const sensor_msgs::msg::JointState::SharedPtr msg);
  void publishSpeed(rclcpp::Publisher<std_msgs::msg::Float64MultiArray>::SharedPtr,
                    std_msgs::msg::Float64MultiArray msg);

 private:
  DriveMode::Mode current_drive_mode_;                   ///< Текущий привод
  PairsGroupingMode::Mode current_pairs_grouping_mode_;  ///< Текущий режим группировки пар

  struct Joint {
    int name;
    double position = 0.0;
    double velocity = 0.0;
    double effort = 0.0;
  };

  struct Controller {
    WheelsControllerName::Name wheels_controller_name;
    WheelsControllerState::State wheels_controller_state;
    Joint outer_joint;
    Joint inner_joint;
    Joint ray_joint;
  };

  std::array<Controller, 6> controllers_;

  void updateActiveControllers();

  const double velocity_step = 0.001;      ///< Шаг обновления скорости шарнира в радианах
  const double effort_step = 0.1;          ///< Шаг обновления усилий шарниров в ньютонах
  const double ray_position_step = 0.001;  ///< Шаг обновления скорости луча в метрах

  QStringList log_messages_;
  static const int MAX_LOG_MESSAGES = 100;

 signals:
  void driveModeChanged();
  void pairsGroupingModeChanged();
  void controllersChanged();
  void logMessagesChanged();
};

#endif  // ROBOT_CONTROLLER_H
