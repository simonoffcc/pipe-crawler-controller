cmake_minimum_required(VERSION 3.20)
project(pipe_crawler_controller)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# ros2 dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)
find_package(sensor_msgs REQUIRED)

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

add_subdirectory(qml)
include_directories(${rclcpp_INCLUDE_DIRS})

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

qt_add_executable(${PROJECT_NAME}_node 
  src/main.cpp
  src/wheel_controller.cpp
)

target_link_libraries(${PROJECT_NAME}_node
  PRIVATE 
  Qt6::Core
  Qt6::Gui
  Qt6::Qml
  Qt6::Quick
  velocity_controllerplugin
)

ament_target_dependencies(${PROJECT_NAME}_node 
  PUBLIC 
  rclcpp
  std_msgs
  sensor_msgs
)

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}_node DESTINATION lib/${PROJECT_NAME})

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
