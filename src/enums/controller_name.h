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

    static std::string toString(Name name) {
        switch (name) {
        case Name::FrontLeft: return "front_left_wheels_controller";
        case Name::FrontUp: return "front_up_wheels_controller";
        case Name::FrontRight: return "front_right_wheels_controller";
        case Name::BackLeft: return "back_left_wheels_controller";
        case Name::BackUp: return "back_up_wheels_controller";
        case Name::BackRight: return "back_right_wheels_controller";
        default: return "";
        }
    }
};

#endif // CONTROLLER_NAME_H
