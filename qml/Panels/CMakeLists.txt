file(GLOB_RECURSE PANELS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "./*qml")
qt_add_library(panels STATIC)
qt_add_qml_module(panels
        URI "Panels"
        VERSION 1.0
        QML_FILES ${PANELS}
        OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/qml/Panels"
)
