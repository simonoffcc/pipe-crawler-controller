#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <rclcpp/rclcpp.hpp>
#include "velocity_controller/velocity_controller.h"

int main(int argc, char *argv[])
{
    // Инициализация ROS2
    rclcpp::init(argc, argv);
    
    // Создаем исполнитель для обработки колбэков ROS2
    rclcpp::executors::MultiThreadedExecutor executor;
    
    // Инициализация Qt
    QGuiApplication app(argc, argv);
    
    // Регистрируем QML типы
    qmlRegisterType<VelocityController>("RobotControl", 1, 0, "VelocityController");
    
    // Создаем движок QML
    QQmlApplicationEngine engine;
    
    // Загружаем главное окно
    engine.load(QUrl(QStringLiteral("qrc:/Main.qml")));
    
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }
    
    // Запускаем обработку событий ROS2 в отдельном потоке
    std::thread ros_thread([&executor]() {
        executor.spin();
    });
    
    // Запускаем главный цикл Qt
    int result = app.exec();
    
    // Завершаем работу ROS2
    rclcpp::shutdown();
    if (ros_thread.joinable()) {
        ros_thread.join();
    }
    
    return result;
}
