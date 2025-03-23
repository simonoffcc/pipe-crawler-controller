#ifndef CONTROLLER_MODE_H
#define CONTROLLER_MODE_H
#include <QObject>

/// \class Класс для простого доступа к режимам управления скоростями робота.
class ControllerMode : public QObject {
  Q_OBJECT
public:
  enum Mode {
    FRONT_DRIVE = 0,
    REAR_DRIVE = 1,
    ALL_WHEEL_DRIVE = 2
  };
  Q_ENUM(Mode)
};
#endif // CONTROLLER_MODE_H
