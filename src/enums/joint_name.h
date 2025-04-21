#ifndef JOINT_NAME_H
#define JOINT_NAME_H

#include <QObject>
#include <string>

class JointName {
    Q_GADGET
public:
    enum Name {
        FrontLeftOuter = 0,
        FrontLeftInner = 1,
        FrontUpOuter = 2,
        FrontUpInner = 3,
        FrontRightOuter = 4,
        FrontRightInner = 5,
        BackLeftOuter = 6,
        BackLeftInner = 7,
        BackUpOuter = 8,
        BackUpInner = 9,
        BackRightOuter = 10,
        BackRightInner = 11,
        Unknown = 12
    };
    Q_ENUM(Name)

    static std::string toString(Name name) {
        switch (name) {
        case Name::FrontLeftOuter: return "front_left_outer_wheel_joint";
        case Name::FrontLeftInner: return "front_left_inner_wheel_joint";
        case Name::FrontUpOuter: return "front_up_outer_wheel_joint";
        case Name::FrontUpInner: return "front_up_inner_wheel_joint";
        case Name::FrontRightOuter: return "front_right_outer_wheel_joint";
        case Name::FrontRightInner: return "front_right_inner_wheel_joint";
        case Name::BackLeftOuter: return "back_left_outer_wheel_joint";
        case Name::BackLeftInner: return "back_left_inner_wheel_joint";
        case Name::BackUpOuter: return "back_up_outer_wheel_joint";
        case Name::BackUpInner: return "back_up_inner_wheel_joint";
        case Name::BackRightOuter: return "back_right_outer_wheel_joint";
        case Name::BackRightInner: return "back_right_inner_wheel_joint";
        default: return "unknown";
        }
    }

    static Name fromString(const std::string& name) {
        if (name == "front_left_outer_wheel_joint") return Name::FrontLeftOuter;
        if (name == "front_left_inner_wheel_joint") return Name::FrontLeftInner;
        if (name == "front_up_outer_wheel_joint") return Name::FrontUpOuter;
        if (name == "front_up_inner_wheel_joint") return Name::FrontUpInner;
        if (name == "front_right_outer_wheel_joint") return Name::FrontRightOuter;
        if (name == "front_right_inner_wheel_joint") return Name::FrontRightInner;
        if (name == "back_left_outer_wheel_joint") return Name::BackLeftOuter;
        if (name == "back_left_inner_wheel_joint") return Name::BackLeftInner;
        if (name == "back_up_outer_wheel_joint") return Name::BackUpOuter;
        if (name == "back_up_inner_wheel_joint") return Name::BackUpInner;
        if (name == "back_right_outer_wheel_joint") return Name::BackRightOuter;
        if (name == "back_right_inner_wheel_joint") return Name::BackRightInner;
        return Name::Unknown;
    }
};

#endif // JOINT_NAME_H
