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
};

#endif // JOINT_NAME_H
