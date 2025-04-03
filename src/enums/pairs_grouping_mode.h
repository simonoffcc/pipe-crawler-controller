#ifndef PAIRS_GROUPING_MODE_H
#define PAIRS_GROUPING_MODE_H

#include <QObject>

/// \class Класс группировки колесных пар робота для публикации единой целевой скорости
class PairsGroupingMode {
    Q_GADGET
public:
    enum Mode {
        Custom,       ///< Кастомный пресет (все другие способы группировки колёсных пар) 
        LeftRight,   ///< Левые и правые пары (4 пары)
        AllPairs     ///< Все пары (6 пар)
    };
    Q_ENUM(Mode)
};

#endif // PAIRS_GROUPING_MODE_H 
