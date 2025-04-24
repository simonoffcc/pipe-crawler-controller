#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "robot_controller.h"

class Guard {
    public:
        explicit Guard(std::function<void()> fn) : fn_(std::move(fn)) {}
        ~Guard() { fn_(); }
   
    private:
        std::function<void()> fn_;
};

int main(int argc, char *argv[]) 
{       
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    rclcpp::init(argc, argv);
    auto pipe_crawler = std::make_shared<rclcpp::Node>("pipe_crawler_controller");
    RobotController::instance(pipe_crawler);

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
    executor.add_node(pipe_crawler);
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
