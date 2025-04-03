#ifndef DRIVE_MODE_H
#define DRIVE_MODE_H

#include <QObject>

/// \class Класс для простого доступа к режимам привода робота
class DriveMode {
    Q_GADGET
public:
    enum Mode {
        Custom,          ///< Кастомный пресет (все другие способы привода)
        FrontDrive,     ///< Передний привод
        RearDrive,      ///< Задний привод
        AllWheelDrive  ///< Полный привод
    };
    Q_ENUM(Mode)
};

#endif // DRIVE_MODE_H
