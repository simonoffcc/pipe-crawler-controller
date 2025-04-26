file(GLOB_RECURSE CONTROLLERS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "./*qml")
qt_add_library(controllers STATIC)
qt_add_qml_module(controllers
        URI "Controllers"
        VERSION 1.0
        QML_FILES ${CONTROLLERS}
        OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/qml/Controllers"
)
