add_subdirectory(Components)
add_subdirectory(Controls)
qt_add_qml_module(main_module
        URI MainModule
        VERSION 1.0
        STATIC
        QML_FILES Main.qml
        OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/qml/MainModule"
)
target_link_libraries(main_module PUBLIC
    componentsplugin
    controlsplugin
)
