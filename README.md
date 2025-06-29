# pipe-crawler-controller

Этот проект содержит пакет ROS2 с пультом для управления роботом инспекции труб.

## Требования

- ROS2 Jazzy
- Qt   

## Работа с пакетом

1.  **Клонирование**

    ```bash
    cd ~/ros2_ws/src && git clone https://gitlab.rtc.ru/i.simonenko/pipe-crawler-controller.git
    ```

2.  **Сборка**

    ```bash
    source /opt/ros/jazzy/setup.bash && cd ~/ros2_ws && colcon build
    ```

3. **Запуск**

    ```bash
    cd ~/ros2_ws && source install/setup.bash && ros2 run pipe_crawler_controller pipe_crawler_controller_node
    ```
