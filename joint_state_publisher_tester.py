#!/usr/bin/env python3

import rclpy
from rclpy.node import Node
from sensor_msgs.msg import JointState
import random
import time

def main():
    rclpy.init()
    node = Node('ray_position_publisher')
    publisher = node.create_publisher(JointState, '/joint_states', 10)

    msg = JointState()
    ray_joints = [
        'front_left_ray_joint',
        'front_up_ray_joint',
        'front_right_ray_joint',
        'back_left_ray_joint',
        'back_up_ray_joint',
        'back_right_ray_joint'
    ]
    
    wheel_joints = [
        'front_left_outer_wheel_joint',
        'front_left_inner_wheel_joint',
        'front_up_outer_wheel_joint',
        'front_up_inner_wheel_joint',
        'front_right_outer_wheel_joint',
        'front_right_inner_wheel_joint',
        'back_left_outer_wheel_joint',
        'back_left_inner_wheel_joint',
        'back_up_outer_wheel_joint',
        'back_up_inner_wheel_joint',
        'back_right_outer_wheel_joint',
        'back_right_inner_wheel_joint'
    ]

    msg.name = ray_joints + wheel_joints

    try:
        while True:
            msg.header.stamp = node.get_clock().now().to_msg()
            
            ray_positions = [random.uniform(0.0, 0.22) for _ in range(6)]
            
            wheel_velocities = [random.uniform(-2.0, 2.0) for _ in range(12)]
            
            msg.position = ray_positions + [0.0] * 12
            msg.velocity = [0.0] * 6 + wheel_velocities
            msg.effort = []
            
            publisher.publish(msg)
            
            node.get_logger().info("Ray positions (m):")
            for name, pos in zip(ray_joints, ray_positions):
                node.get_logger().info(f'{name}: {pos:.3f}')
            
            node.get_logger().info("\nWheel velocities (rad/s):")
            for name, vel in zip(wheel_joints, wheel_velocities):
                node.get_logger().info(f'{name}: {vel:.3f}')
            node.get_logger().info('---')
            
            time.sleep(1.0)
    except KeyboardInterrupt:
        pass

    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main() 