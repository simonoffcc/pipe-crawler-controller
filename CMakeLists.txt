cmake_minimum_required(VERSION 3.16)

project(pipe-crawler-controller VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(QML
    Main.qml
    qml/Components/SchemeBody.qml
    qml/Components/SchemeLines.qml
    qml/Components/PairConnection.qml
    qml/Components/JointControl.qml
    qml/Components/WheelPair.qml
    qml/Components/RobotDiagram.qml
)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(pipe-crawler-controller
    main.cpp
)

qt_add_qml_module(pipe-crawler-controller
    URI pipe-crawler-controller
    VERSION 1.0
    QML_FILES ${QML}
)


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(pipe-crawler-controller PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.pipe-crawler-controller
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(pipe-crawler-controller
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS pipe-crawler-controller
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
