cmake_minimum_required(VERSION 3.16)

project(pipe-crawler-controller VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(apppipe-crawler-controller
    main.cpp
)

qt_add_qml_module(apppipe-crawler-controller
    URI pipe-crawler-controller
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES SchemeLines.qml
        QML_FILES SchemeBody.qml
        QML_FILES JointControl.qml
        QML_FILES PairConnection.qml
        QML_FILES WheelPair.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(apppipe-crawler-controller PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.apppipe-crawler-controller
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(apppipe-crawler-controller
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS apppipe-crawler-controller
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
