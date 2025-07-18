#ifndef RAY_NAME_H
#define RAY_NAME_H

#include <QObject>
#include <string>

class RayName : public QObject {
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

    static std::string toControllerString(Name name) {
        switch (name) {
        case Name::FrontLeft: return "front_left_ray_pos_controller";
        case Name::FrontUp: return "front_up_ray_pos_controller";
        case Name::FrontRight: return "front_right_ray_pos_controller";
        case Name::BackLeft: return "back_left_ray_pos_controller";
        case Name::BackUp: return "back_up_ray_pos_controller";
        case Name::BackRight: return "back_right_ray_pos_controller";
        default: return "unknown";
        }
    }

    static Name fromJointString(const std::string& name) {
        if (name == "front_left_ray_joint") return Name::FrontLeft;
        if (name == "front_up_ray_joint") return Name::FrontUp;
        if (name == "front_right_ray_joint") return Name::FrontRight;
        if (name == "back_left_ray_joint") return Name::BackLeft;
        if (name == "back_up_ray_joint") return Name::BackUp;
        if (name == "back_right_ray_joint") return Name::BackRight;
        return Name::Unknown;
    }

    static Name fromControllerString(const std::string& name) {
        if (name == "front_left_ray_pos_controller") return Name::FrontLeft;
        if (name == "front_up_ray_pos_controller") return Name::FrontUp;
        if (name == "front_right_ray_pos_controller") return Name::FrontRight;
        if (name == "back_left_ray_pos_controller") return Name::BackLeft;
        if (name == "back_up_ray_pos_controller") return Name::BackUp;
        if (name == "back_right_ray_pos_controller") return Name::BackRight;
        return Name::Unknown;
    }

    static std::string toJointString(Name name) {
        switch (name) {
        case Name::FrontLeft: return "front_left_ray_joint";
        case Name::FrontUp: return "front_up_ray_joint";
        case Name::FrontRight: return "front_right_ray_joint";
        case Name::BackLeft: return "back_left_ray_joint";
        case Name::BackUp: return "back_up_ray_joint";
        case Name::BackRight: return "back_right_ray_joint";
        default: return "unknown";
        }
    }
};

#endif // RAY_NAME_H
