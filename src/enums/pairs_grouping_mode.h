#ifndef PAIRS_GROUPING_MODE_H
#define PAIRS_GROUPING_MODE_H

#include <QObject>

/// \class Класс группировки колесных пар робота для публикации единой целевой скорости
class PairsGroupingMode {
    Q_GADGET
public:
    enum Mode {
        Custom = 0,      ///< Кастомный пресет (все другие способы управления состояниями колёсных пар)
        LeftRight = 1,   ///< Левые и правые пары (4 пары)
        AllPairs = 2     ///< Все пары (6 пар)
    };
    Q_ENUM(Mode)
};

#endif // PAIRS_GROUPING_MODE_H 
