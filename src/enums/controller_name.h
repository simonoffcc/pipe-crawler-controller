#ifndef CONTROLLER_NAME_H
#define CONTROLLER_NAME_H

#include <QObject>

class ControllerName {
    Q_GADGET
public:
    enum Name {
        FrontLeft,
        FrontUp,
        FrontRight,
        BackLeft,
        BackUp,
        BackRight
    };
    Q_ENUM(Name)
};

#endif // CONTROLLER_NAME_H
