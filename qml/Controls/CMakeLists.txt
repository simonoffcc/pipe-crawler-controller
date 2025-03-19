file(GLOB_RECURSE CONTROLS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "./*qml")
qt_add_library(controls STATIC)
qt_add_qml_module(controls
        URI "Controls"
        VERSION 1.0
        QML_FILES ${CONTROLS}
        OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/qml/Controls"
)
