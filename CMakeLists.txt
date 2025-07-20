cmake_minimum_required(VERSION 3.20)

project(pipe_crawler_controller VERSION 0.1)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# Qt6 dependencies
find_package(
  Qt6 REQUIRED
  COMPONENTS 
    Core
    Gui
    Qml
    Quick
    QuickControls2
)
qt_standard_project_setup(REQUIRES 6.5)

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

# Link libraries
target_link_libraries(${PROJECT_NAME}_node
  PRIVATE 
  Qt6::Core
  Qt6::Gui
  Qt6::Qml
  Qt6::Quick
  Qt6::QuickControls2
  main_moduleplugin
)

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
