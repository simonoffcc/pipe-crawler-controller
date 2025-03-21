qt_add_library(velocity_controllerplugin STATIC
    velocity_controller.cpp
    velocity_controller.h
)

target_link_libraries(velocity_controllerplugin
    PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
)

target_include_directories(velocity_controllerplugin
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

ament_target_dependencies(velocity_controllerplugin
    PUBLIC
    rclcpp
    std_msgs
    sensor_msgs
)

# Регистрация QML модуля
qt_add_qml_module(velocity_controllerplugin
    URI RobotControl
    VERSION 1.0
    QML_FILES
    RESOURCE_PREFIX /
    DEPENDENCIES
        QtCore
        QtQuick
) 