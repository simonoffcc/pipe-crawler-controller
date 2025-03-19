#ifndef WHEEL_PAIR_MODE_H
#define WHEEL_PAIR_MODE_H

#include <QObject>

/// \class Класс c режимами управления колёсной парой
class WheelPairMode : public QObject {
  Q_OBJECT
public:
  enum Mode { 
    globalSpeedControl = 0, ///< Указывает, что скорость пары определяется через тело робота
    localSpeedControl = 1, ///< Указывает, что скорость пары определяется через локальное поле
    independentSpeedControl = 2, ///< Указывает, что скорость каждого шарнира определяется через локальное поле
  };
  Q_ENUM(Mode)
};
#endif // WHEEL_PAIR_MODE_H