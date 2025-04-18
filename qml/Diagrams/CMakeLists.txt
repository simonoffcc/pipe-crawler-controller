file(GLOB_RECURSE DIAGRAMS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "./*qml")
qt_add_library(diagrams STATIC)
qt_add_qml_module(diagrams
        URI "Diagrams"
        VERSION 1.0
        QML_FILES ${DIAGRAMS}
        OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/qml/Diagrams"
)
