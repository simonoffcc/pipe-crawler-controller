#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "wheel_controller.h"


class Guard {
    public:
        explicit Guard(std::function<void()> fn) : fn_(std::move(fn)) {}
        ~Guard() { fn_(); }
   
    private:
        std::function<void()> fn_;
};

int main(int argc, char *argv[]) 
{
    rclcpp::init(argc, argv);
    auto node = std::make_shared<rclcpp::Node>("pipe_crawler_controller");
    
    QScopedPointer<WheelController> wheel_controller(new WheelController(node));
    
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    // engine.addImportPath("qrc:/");
    // engine.addImportPath(":/qml");
    
    qmlRegisterType<PairsGroupingMode>("PairsGroupingMode", 1, 0, "PairsGroupingMode");
    qmlRegisterType<DriveMode>("DriveMode", 1, 0, "DriveMode");
    qmlRegisterType<JointNames>("JointNames", 1, 0, "JointNames");
    qmlRegisterType<ControllerNames>("ControllerNames", 1, 0, "ControllerNames");
    qmlRegisterSingletonInstance<WheelController>("WheelController", 1, 0, "WheelController", wheel_controller.get());
    
    // Установка обработчика сигнала для SIGINT
    std::signal(SIGINT, [](int /*unused*/) {
        RCLCPP_INFO(rclcpp::get_logger("rclcpp"), "Завершение работы пультового ПО: сигнал SIGINT");
        rclcpp::shutdown();
        QCoreApplication::quit();
    });
    
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("MainModule", "Main");

    rclcpp::executors::SingleThreadedExecutor executor;
    executor.add_node(node);
    auto spin_executor = [&executor]() { executor.spin(); };
    std::thread execution_thread(spin_executor);

    Guard g{[&]() {
        executor.cancel();
        if (execution_thread.joinable()) {
            execution_thread.join();
        }
    }};

    return app.exec();
}
