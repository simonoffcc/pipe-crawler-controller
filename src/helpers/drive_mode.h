#ifndef DRIVE_MODE_H
#define DRIVE_MODE_H

#include <QObject>

/// \class Класс для простого доступа к режимам управления скоростями робота.
class DriveMode : public QObject {
    Q_OBJECT
public:
    enum Mode {
      FRONT_DRIVE = 0,
      REAR_DRIVE = 1,
      ALL_WHEEL_DRIVE = 2
  };
  Q_ENUM(Mode)
};

#endif // DRIVE_MODE_H
