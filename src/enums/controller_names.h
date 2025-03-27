#ifndef CONTROLLER_NAMES_H
#define CONTROLLER_NAMES_H

#include <QObject>
#include <QSet>
#include <string>

class ControllerNames : public QObject {
    Q_OBJECT
public:
    enum class Name {
        FRONT_LEFT,
        FRONT_UP,
        FRONT_RIGHT,
        BACK_LEFT,
        BACK_UP,
        BACK_RIGHT
    };

    static std::string toString(Name name) {
        switch (name) {
            case Name::FRONT_LEFT: return "front_left_wheels_controller";
            case Name::FRONT_UP: return "front_up_wheels_controller";
            case Name::FRONT_RIGHT: return "front_right_wheels_controller";
            case Name::BACK_LEFT: return "back_left_wheels_controller";
            case Name::BACK_UP: return "back_up_wheels_controller";
            case Name::BACK_RIGHT: return "back_right_wheels_controller";
            default: return "";
        }
    }

    Q_ENUM(Name)
};

#endif // CONTROLLER_NAMES_H 