#ifndef WHEELS_CONTROLLER_STATE_H
#define WHEELS_CONTROLLER_STATE_H

#include <QObject>

class WheelsControllerState {
    Q_GADGET
public:
    enum State {
        Global = 0,
        Local = 1,
        Independent = 2
    };
    Q_ENUM(State)
};

#endif // WHEELS_CONTROLLER_STATE_H
