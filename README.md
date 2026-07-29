# pipe-crawler-controller

This project contains a ROS2 package with a control panel for a pipe inspection robot.

## Requirements

- ROS2 Jazzy
- Qt

## Working with the package

1.  **Clone**

    ```bash
    cd ~/ros2_ws/src && git clone https://gitlab.rtc.ru/i.simonenko/pipe-crawler-controller.git
    ```

2.  **Build**

    ```bash
    source /opt/ros/jazzy/setup.bash && cd ~/ros2_ws && colcon build
    ```

3. **Run**

    ```bash
    cd ~/ros2_ws && source install/setup.bash && ros2 run pipe_crawler_controller pipe_crawler_controller_node
    ```
