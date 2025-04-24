#ifndef WHEEL_PAIR_STATE_H
#define WHEEL_PAIR_STATE_H

#include <QObject>

class WheelPairState {
    Q_GADGET
public:
    enum State {
        Global = 0,
        Local = 1,
        Independent = 2
    };
    Q_ENUM(State)
};

#endif // WHEEL_PAIR_STATE_H
