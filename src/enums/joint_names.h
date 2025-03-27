#ifndef JOINT_NAMES_H
#define JOINT_NAMES_H

#include <QObject>
#include <QString>
#include <QMap>
#include <QVector>

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
        BACK_RIGHT_INNER,
        UNKNOWN
    };

    static QString toString(Name name) {
        static const QMap<Name, QString> nameMap = {
            {Name::FRONT_LEFT_OUTER, "front_left_outer_wheel_joint"},
            {Name::FRONT_LEFT_INNER, "front_left_inner_wheel_joint"},
            {Name::FRONT_UP_OUTER, "front_up_outer_wheel_joint"},
            {Name::FRONT_UP_INNER, "front_up_inner_wheel_joint"},
            {Name::FRONT_RIGHT_OUTER, "front_right_outer_wheel_joint"},
            {Name::FRONT_RIGHT_INNER, "front_right_inner_wheel_joint"},
            {Name::BACK_LEFT_OUTER, "back_left_outer_wheel_joint"},
            {Name::BACK_LEFT_INNER, "back_left_inner_wheel_joint"},
            {Name::BACK_UP_OUTER, "back_up_outer_wheel_joint"},
            {Name::BACK_UP_INNER, "back_up_inner_wheel_joint"},
            {Name::BACK_RIGHT_OUTER, "back_right_outer_wheel_joint"},
            {Name::BACK_RIGHT_INNER, "back_right_inner_wheel_joint"}
        };
        return nameMap.value(name, QString());
    }

    static Name fromString(const QString& str) {
        static const QMap<QString, Name> reverseMap = {
            {"front_left_outer_wheel_joint", Name::FRONT_LEFT_OUTER},
            {"front_left_inner_wheel_joint", Name::FRONT_LEFT_INNER},
            {"front_up_outer_wheel_joint", Name::FRONT_UP_OUTER},
            {"front_up_inner_wheel_joint", Name::FRONT_UP_INNER},
            {"front_right_outer_wheel_joint", Name::FRONT_RIGHT_OUTER},
            {"front_right_inner_wheel_joint", Name::FRONT_RIGHT_INNER},
            {"back_left_outer_wheel_joint", Name::BACK_LEFT_OUTER},
            {"back_left_inner_wheel_joint", Name::BACK_LEFT_INNER},
            {"back_up_outer_wheel_joint", Name::BACK_UP_OUTER},
            {"back_up_inner_wheel_joint", Name::BACK_UP_INNER},
            {"back_right_outer_wheel_joint", Name::BACK_RIGHT_OUTER},
            {"back_right_inner_wheel_joint", Name::BACK_RIGHT_INNER}
        };
        return reverseMap.value(str, Name::UNKNOWN);
    }

    static const QVector<QString>& getAllNames() {
        static const QVector<QString> names = {
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