#ifndef WHEELS_CONTROLLER_NAME_H
#define WHEELS_CONTROLLER_NAME_H

#include <QObject>
#include <string>

class WheelsControllerName : public QObject {
    Q_GADGET
public:
    enum Name {
        FrontLeft = 0,
        FrontUp = 1,
        FrontRight = 2,
        BackLeft = 3,
        BackUp = 4,
        BackRight = 5,
        Unknown = -1
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
        default: return "unknown";
        }
    }

    static Name fromString(const std::string& name) {
        if (name == "front_left_wheels_controller") return Name::FrontLeft;
        if (name == "front_up_wheels_controller") return Name::FrontUp;
        if (name == "front_right_wheels_controller") return Name::FrontRight;
        if (name == "back_left_wheels_controller") return Name::BackLeft;
        if (name == "back_up_wheels_controller") return Name::BackUp;
        if (name == "back_right_wheels_controller") return Name::BackRight;
        return Name::Unknown;
    }
};

#endif // WHEELS_CONTROLLER_NAME_H
