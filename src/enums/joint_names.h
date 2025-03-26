#ifndef JOINT_NAMES_H
#define JOINT_NAMES_H

#include <QObject>
#include <string>
#include <vector>

class JointNames : public QObject {
    Q_OBJECT
public:
    enum class Name {
        FRONT_LEFT_OUTER,
        FRONT_LEFT_INNER,
        FRONT_UP_OUTER,
        FRONT_UP_INNER,
        FRONT_RIGHT_OUTER,
        FRONT_RIGHT_INNER,
        BACK_LEFT_OUTER,
        BACK_LEFT_INNER,
        BACK_UP_OUTER,
        BACK_UP_INNER,
        BACK_RIGHT_OUTER,
        BACK_RIGHT_INNER
    };

    static std::string toString(Name name) {
        switch (name) {
            case Name::FRONT_LEFT_OUTER: return "front_left_outer_wheel_joint";
            case Name::FRONT_LEFT_INNER: return "front_left_inner_wheel_joint";
            case Name::FRONT_UP_OUTER: return "front_up_outer_wheel_joint";
            case Name::FRONT_UP_INNER: return "front_up_inner_wheel_joint";
            case Name::FRONT_RIGHT_OUTER: return "front_right_outer_wheel_joint";
            case Name::FRONT_RIGHT_INNER: return "front_right_inner_wheel_joint";
            case Name::BACK_LEFT_OUTER: return "back_left_outer_wheel_joint";
            case Name::BACK_LEFT_INNER: return "back_left_inner_wheel_joint";
            case Name::BACK_UP_OUTER: return "back_up_outer_wheel_joint";
            case Name::BACK_UP_INNER: return "back_up_inner_wheel_joint";
            case Name::BACK_RIGHT_OUTER: return "back_right_outer_wheel_joint";
            case Name::BACK_RIGHT_INNER: return "back_right_inner_wheel_joint";
            default: return "";
        }
    }

    static const std::vector<std::string>& getAllNames() {
        static const std::vector<std::string> names = {
            toString(Name::FRONT_LEFT_OUTER),
            toString(Name::FRONT_LEFT_INNER),
            toString(Name::FRONT_UP_OUTER),
            toString(Name::FRONT_UP_INNER),
            toString(Name::FRONT_RIGHT_OUTER),
            toString(Name::FRONT_RIGHT_INNER),
            toString(Name::BACK_LEFT_OUTER),
            toString(Name::BACK_LEFT_INNER),
            toString(Name::BACK_UP_OUTER),
            toString(Name::BACK_UP_INNER),
            toString(Name::BACK_RIGHT_OUTER),
            toString(Name::BACK_RIGHT_INNER)
        };
        return names;
    }
    Q_ENUM(Name)
};

#endif // JOINT_NAMES_H 