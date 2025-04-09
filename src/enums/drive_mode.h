#ifndef DRIVE_MODE_H
#define DRIVE_MODE_H

#include <QObject>

/// \class Класс для простого доступа к режимам привода робота
class DriveMode {
    Q_GADGET
public:
    enum Mode {
        Custom = 0,         ///< Кастомный пресет (все другие способы привода)
        FrontDrive = 1,     ///< Передний привод
        RearDrive = 2,      ///< Задний привод
        AllWheelDrive = 3   ///< Полный привод
    };
    Q_ENUM(Mode)
};

#endif // DRIVE_MODE_H
