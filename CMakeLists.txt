cmake_minimum_required(VERSION 3.20)

project(pipe_crawler_controller VERSION 0.1)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# --- QmlMaterial (installed prefix by default; optional in-tree bundle) ---
option(PCC_BUNDLE_QML_MATERIAL
  "Build QmlMaterial via add_subdirectory (CI/one-off; not default)"
  OFF)

if(DEFINED ENV{QML_MATERIAL_PREFIX} AND NOT "$ENV{QML_MATERIAL_PREFIX}" STREQUAL "")
  list(PREPEND CMAKE_PREFIX_PATH "$ENV{QML_MATERIAL_PREFIX}")
elseif(DEFINED ENV{HOME} AND EXISTS "$ENV{HOME}/opt/qml_material")
  list(PREPEND CMAKE_PREFIX_PATH "$ENV{HOME}/opt/qml_material")
endif()

# Qt6 dependencies (QmlMaterial requires 6.8+)
find_package(
  Qt6 6.8 REQUIRED
  COMPONENTS
    Core
    Gui
    Qml
    Quick
    QuickControls2
)
qt_standard_project_setup(REQUIRES 6.8)

set(QML_MATERIAL_QML_DIR "")
set(QML_MATERIAL_LIB_DIR "")

if(PCC_BUNDLE_QML_MATERIAL)
  set(QM_BUILD_EXAMPLE OFF CACHE BOOL "" FORCE)
  set(QM_BUILD_TESTS OFF CACHE BOOL "" FORCE)
  add_subdirectory(3rdparty/qml_material EXCLUDE_FROM_ALL)
  set(QML_MATERIAL_TARGETS qml_material qml_material_layouts)
  if(DEFINED QT_QML_OUTPUT_DIRECTORY)
    set(QML_MATERIAL_QML_DIR "${QT_QML_OUTPUT_DIRECTORY}")
  endif()
else()
  find_package(qml_material REQUIRED)
  set(QML_MATERIAL_TARGETS qml_material::qml_material qml_material::qml_material_layouts)

  get_filename_component(_qml_material_prefix "${qml_material_DIR}/../../.." ABSOLUTE)
  if(EXISTS "${_qml_material_prefix}/lib/qt6/qml/Qcm/Material")
    set(QML_MATERIAL_QML_DIR "${_qml_material_prefix}/lib/qt6/qml")
    set(QML_MATERIAL_LIB_DIR "${_qml_material_prefix}/lib")
  elseif(DEFINED CMAKE_LIBRARY_ARCHITECTURE
         AND EXISTS "${_qml_material_prefix}/lib/${CMAKE_LIBRARY_ARCHITECTURE}/qt6/qml/Qcm/Material")
    set(QML_MATERIAL_QML_DIR "${_qml_material_prefix}/lib/${CMAKE_LIBRARY_ARCHITECTURE}/qt6/qml")
    set(QML_MATERIAL_LIB_DIR "${_qml_material_prefix}/lib/${CMAKE_LIBRARY_ARCHITECTURE}")
  else()
    message(FATAL_ERROR
      "qml_material found at ${qml_material_DIR}, but Qcm/Material QML module was not found.\n"
      "Run ./scripts/install_qml_material.sh (or set QML_MATERIAL_PREFIX).")
  endif()
endif()

if(QML_MATERIAL_QML_DIR STREQUAL "")
  message(FATAL_ERROR "QML_MATERIAL_QML_DIR is empty; cannot configure QML import path for QmlMaterial.")
endif()

message(STATUS "QmlMaterial QML dir: ${QML_MATERIAL_QML_DIR}")

# ros2 dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)
find_package(sensor_msgs REQUIRED)

# Add QML subdirectory
add_subdirectory(qml)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

set(PROJECT_HEADERS
  src/controller/helpers/pairs_grouping_mode.h
  src/controller/helpers/drive_mode.h
  src/controller/helpers/ray_joint_name.h
  src/controller/helpers/wheel_joint_name.h
  src/controller/helpers/wheels_controller_name.h
  src/controller/helpers/wheels_controller_state.h
  src/controller/robot_controller.h
)

set(PROJECT_SOURCES
  src/controller/robot_controller.cpp
  src/main.cpp
)

# Create main executable
qt_add_executable(
  ${PROJECT_NAME}_node
  ${PROJECT_HEADERS}
  ${PROJECT_SOURCES}
)

target_compile_definitions(${PROJECT_NAME}_node
  PRIVATE
    "QML_MATERIAL_QML_DIR=\"${QML_MATERIAL_QML_DIR}\""
)

# Link libraries
target_link_libraries(${PROJECT_NAME}_node
  PRIVATE
  Qt6::Core
  Qt6::Gui
  Qt6::Qml
  Qt6::Quick
  Qt6::QuickControls2
  main_moduleplugin
  ${QML_MATERIAL_TARGETS}
)

if(QML_MATERIAL_LIB_DIR)
  set_property(TARGET ${PROJECT_NAME}_node APPEND PROPERTY BUILD_RPATH "${QML_MATERIAL_LIB_DIR}")
  set_property(TARGET ${PROJECT_NAME}_node APPEND PROPERTY INSTALL_RPATH "${QML_MATERIAL_LIB_DIR}")
  # Ensure sourced install space can resolve QmlMaterial shared libs (plugin RPATH fallback).
  ament_environment_hooks("${CMAKE_CURRENT_SOURCE_DIR}/env-hooks/qml_material.sh.in")
endif()

# Add ROS2 dependencies
ament_target_dependencies(${PROJECT_NAME}_node
  PUBLIC
  rclcpp
  std_msgs
  sensor_msgs
)

# Install targets
include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}_node DESTINATION lib/${PROJECT_NAME})

# Testing
if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  # the following line skips the linter which checks for copyrights
  # comment the line when a copyright and license is added to all source files
  set(ament_cmake_copyright_FOUND TRUE)
  # the following line skips cpplint (only works in a git repo)
  # comment the line when this package is in a git repo and when
  # a copyright and license is added to all source files
  set(ament_cmake_cpplint_FOUND TRUE)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
