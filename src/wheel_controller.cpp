#include "wheel_controller.h"

#include "enums/controller_names.h"
#include "enums/joint_names.h"
#include "enums/pairs_grouping_mode.h"
#include "enums/drive_mode.h"

WheelController::WheelController(std::shared_ptr<rclcpp::Node> node, QObject* parent)
: QObject(parent),
node_(node),

{
    qmlRegisterType<WheelController>("WheelController", 1, 0, "WheelController");
    
}

void WheelController::createROSInterfaces() {
    // for (const auto& controller : CONTROLLER_NAMES) {
    //     wheel_publishers_[controller] = node_->create_publisher<std_msgs::msg::Float64MultiArray>(
    //         "/" + controller + "/commands", 10);
    // }

    // joint_state_sub_ = node_->create_subscription<sensor_msgs::msg::JointState>(
    //     "/joint_states", 10,
    //     std::bind(&WheelController::jointStateCallback, this, std::placeholders::_1));

    // for (const auto& joint : JOINT_NAMES) {
    //     wheel_speeds_[QString::fromStdString(joint)] = 0.0;
    // }
}
