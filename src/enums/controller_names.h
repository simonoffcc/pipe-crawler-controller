#ifndef CONTROLLER_NAMES_H
#define CONTROLLER_NAMES_H

#include <QObject>
#include <string>
#include <vector>

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

    static const std::vector<std::string>& getAllNames() {
        static const std::vector<std::string> names = {
            toString(Name::FRONT_LEFT),
            toString(Name::FRONT_UP),
            toString(Name::FRONT_RIGHT),
            toString(Name::BACK_LEFT),
            toString(Name::BACK_UP),
            toString(Name::BACK_RIGHT)
        };
        return names;
    }
    Q_ENUM(Name)
};

#endif // CONTROLLER_NAMES_H 