#ifndef JOINT_NAMES_H
#define JOINT_NAMES_H

#include <QObject>

class JointNames : public QObject {
    Q_OBJECT
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
};

#endif // JOINT_NAMES_H
