#ifndef DRIVE_MODE_H
#define DRIVE_MODE_H

#include <QObject>

/// \class Класс для простого доступа к режимам привода робота
class DriveMode : public QObject {
    Q_OBJECT
public:
    enum Mode {
        CUSTOM = 0,          ///< Кастомный пресет (все другие способы привода)
        FRONT_DRIVE = 1,     ///< Передний привод
        REAR_DRIVE = 2,      ///< Задний привод
        ALL_WHEEL_DRIVE = 3  ///< Полный привод
    };
    Q_ENUM(Mode)
};

#endif // DRIVE_MODE_H
