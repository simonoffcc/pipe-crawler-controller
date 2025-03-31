#ifndef CONTROLLER_NAMES_H
#define CONTROLLER_NAMES_H

#include <QObject>

class ControllerNames : public QObject {
    Q_OBJECT // Q_GADDGET
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

#endif // CONTROLLER_NAMES_H 
