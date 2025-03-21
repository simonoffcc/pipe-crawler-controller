#include "velocity_controller.h"

VelocityController::VelocityController(QObject *parent)
    : QObject(parent)
{
    initializeWheelPairs();
    initializeROS();
}

void VelocityController::initializeWheelPairs()
{
    // Инициализация структуры колесных пар
    const QStringList longitudinal = {"front", "back"};
    const QStringList transverse = {"left", "right", "up"};

    for (const auto &long_pos : longitudinal) {
        for (const auto &trans_pos : transverse) {
            QString pairKey = long_pos + "_" + trans_pos;
            WheelPair pair;
            
            // Формируем имена в соответствии с требованиями
            pair.controllerName = pairKey + "_wheels_controller";
            pair.outerWheelJoint = pairKey + "_outer_wheel_joint";
            pair.innerWheelJoint = pairKey + "_inner_wheel_joint";
            
            wheelPairs[pairKey] = pair;
        }
    }
}

void VelocityController::initializeROS()
{
    rosNode = std::make_shared<rclcpp::Node>("velocity_controller");

    // Создаем издателей для каждого контроллера
    for (auto it = wheelPairs.begin(); it != wheelPairs.end(); ++it) {
        const auto &pair = it.value();
        auto publisher = rosNode->create_publisher<std_msgs::msg::Float64MultiArray>(
            "/" + pair.controllerName + "/commands", 10);
        controllers[it.key()] = publisher;
    }

    // Подписываемся на топик состояния шарниров
    jointStatesSub = rosNode->create_subscription<sensor_msgs::msg::JointState>(
        "/joint_states", 10,
        std::bind(&VelocityController::jointStatesCallback, this, std::placeholders::_1));
}

void VelocityController::setDriveMode(const QString &mode)
{
    if (mode != "all" && mode != "front" && mode != "back") return;
    
    QMutexLocker locker(&mutex);
    if (driveMode != mode) {
        driveMode = mode;
        emit driveModeChanged(mode);
    }
}

void VelocityController::setControlMode(const QString &mode)
{
    if (mode != "sides" && mode != "transverse") return;
    
    QMutexLocker locker(&mutex);
    if (controlMode != mode) {
        controlMode = mode;
        emit controlModeChanged(mode);
    }
}

QStringList VelocityController::getActivePairs() const
{
    QStringList pairs;
    QStringList prefixes;
    
    // Определяем активные продольные позиции
    if (driveMode == "all") {
        prefixes << "front" << "back";
    } else {
        prefixes << driveMode;
    }

    // Формируем список активных пар
    for (const auto &prefix : prefixes) {
        if (controlMode == "sides") {
            pairs << prefix + "_left" << prefix + "_right";
        } else { // transverse
            pairs << prefix + "_left" << prefix + "_right" << prefix + "_up";
        }
    }
    
    return pairs;
}

void VelocityController::setSideSpeed(const QString &side, double speed)
{
    if (side != "left" && side != "right") return;
    
    QMutexLocker locker(&mutex);
    updateWheelPairSpeeds(side, speed);
}

void VelocityController::updateWheelPairSpeeds(const QString &side, double speed)
{
    QStringList activePairs = getActivePairs();
    
    for (const auto &pairKey : activePairs) {
        if (pairKey.contains(side)) {
            wheelPairs[pairKey].targetSpeed = speed;
            publishWheelPairSpeed(pairKey);
        }
    }
}

void VelocityController::setTransverseSpeed(const QString &position, double speed)
{
    if (position != "up" && position != "left" && position != "right") return;
    
    QMutexLocker locker(&mutex);
    updateTransversePairSpeeds(position, speed);
}

void VelocityController::updateTransversePairSpeeds(const QString &position, double speed)
{
    QStringList activePairs = getActivePairs();
    
    for (const auto &pairKey : activePairs) {
        if (pairKey.contains(position)) {
            wheelPairs[pairKey].targetSpeed = speed;
            publishWheelPairSpeed(pairKey);
        }
    }
}

void VelocityController::publishWheelPairSpeed(const QString &pairKey)
{
    if (!wheelPairs.contains(pairKey) || !controllers.contains(pairKey)) return;

    const auto &pair = wheelPairs[pairKey];
    std_msgs::msg::Float64MultiArray msg;
    msg.data = {pair.targetSpeed, pair.targetSpeed}; // Одинаковая скорость для обоих колес
    controllers[pairKey]->publish(msg);
}

double VelocityController::getSideSpeed(const QString &side) const
{
    if (side != "left" && side != "right") return 0.0;
    
    QMutexLocker locker(&mutex);
    // Возвращаем скорость первой найденной активной пары
    QStringList activePairs = getActivePairs();
    for (const auto &pairKey : activePairs) {
        if (pairKey.contains(side)) {
            return wheelPairs[pairKey].targetSpeed;
        }
    }
    return 0.0;
}

double VelocityController::getTransverseSpeed(const QString &position) const
{
    if (position != "up" && position != "left" && position != "right") return 0.0;
    
    QMutexLocker locker(&mutex);
    QStringList activePairs = getActivePairs();
    for (const auto &pairKey : activePairs) {
        if (pairKey.contains(position)) {
            return wheelPairs[pairKey].targetSpeed;
        }
    }
    return 0.0;
}

double VelocityController::getWheelSpeed(const QString &longitudinal,
                                       const QString &transverse,
                                       const QString &wheel) const
{
    QMutexLocker locker(&mutex);
    QString pairKey = longitudinal + "_" + transverse;
    if (!wheelPairs.contains(pairKey)) return 0.0;
    
    const auto &pair = wheelPairs[pairKey];
    return wheel == "outer" ? pair.outerWheelSpeed : pair.innerWheelSpeed;
}

void VelocityController::jointStatesCallback(const sensor_msgs::msg::JointState::SharedPtr msg)
{
    QMutexLocker locker(&mutex);
    
    // Обновляем скорости только для тех шарниров, которые есть в сообщении
    for (size_t i = 0; i < msg->name.size(); ++i) {
        QString jointName = QString::fromStdString(msg->name[i]);
        double velocity = msg->velocity[i];

        // Проходим по всем парам и ищем соответствующий шарнир
        for (auto it = wheelPairs.begin(); it != wheelPairs.end(); ++it) {
            auto &pair = it.value();
            if (jointName == pair.outerWheelJoint) {
                pair.outerWheelSpeed = velocity;
                emit wheelSpeedUpdated(jointName, velocity);
            } else if (jointName == pair.innerWheelJoint) {
                pair.innerWheelSpeed = velocity;
                emit wheelSpeedUpdated(jointName, velocity);
            }
        }
    }
}
