#ifndef DRIVE_MODE_H
#define DRIVE_MODE_H

#include <QObject>
#include <QString>
#include <QMap>

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

    static QString toString(Mode mode) {
        static const QMap<Mode, QString> modeMap = {
            {Mode::CUSTOM, "Custom"},
            {Mode::FRONT_DRIVE, "Front-drive"},
            {Mode::REAR_DRIVE, "Rear-drive"},
            {Mode::ALL_WHEEL_DRIVE, "Full-drive"}
        };
        return modeMap.value(mode, "Unknown");
    }

    static Mode fromString(const QString& str) {
        static const QMap<QString, Mode> reverseMap = {
            {"Custom", Mode::CUSTOM},
            {"Front-drive", Mode::FRONT_DRIVE},
            {"Rear-drive", Mode::REAR_DRIVE},
            {"Full-drive", Mode::ALL_WHEEL_DRIVE}
        };
        return reverseMap.value(str, Mode::CUSTOM);
    }
};

#endif // DRIVE_MODE_H
