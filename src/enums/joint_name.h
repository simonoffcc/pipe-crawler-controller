#ifndef JOINT_NAME_H
#define JOINT_NAME_H

#include <QObject>

class JointName {
    Q_GADGET
public:
    enum Name {
        FrontLeftOuter,
        FrontLeftInner,
        FrontUpOuter,
        FrontUpInner,
        FrontRightOuter,
        FrontRightInner,
        BackLeftOuter,
        BackLeftInner,
        BackUpOuter,
        BackUpInner,
        BackRightOuter,
        BackRightInner,
        Unknown
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
        default: return "";
        }
    }
};

#endif // JOINT_NAME_H
