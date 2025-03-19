file(GLOB_RECURSE COMPONENTS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "./*qml")
qt_add_library(components STATIC)
qt_add_qml_module(components
        URI "Components"
        VERSION 1.0
        QML_FILES ${COMPONENTS}
        OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/qml/Components"
)
