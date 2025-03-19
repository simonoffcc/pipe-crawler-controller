add_subdirectory(Components)
add_subdirectory(Controls)
qt_add_qml_module(velocity_controller
        URI VelocityController
        VERSION 1.0
        STATIC
        QML_FILES Main.qml
        OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/qml/VelocityController"
)
target_link_libraries(velocity_controller PUBLIC
    componentsplugin
    controlsplugin
)
