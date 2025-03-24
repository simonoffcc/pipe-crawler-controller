#ifndef PAIRS_GROUPING_MODE_H
#define PAIRS_GROUPING_MODE_H

#include <QObject>

/// \class Класс группировки колесных пар робота для публикации единой целевой скорости
class PairsGroupingMode : public QObject {
    Q_OBJECT
public:
    enum Mode {
        CUSTOM = 0,     ///< Кастомный пресет (все другие способы группировки колёсных пар) 
        SIDES = 1,      ///< Левые и правые пары (4 пары)
        ALL_PAIRS = 2   ///< Все пары (6 пар)
    };
    Q_ENUM(Mode)
};

#endif // PAIRS_GROUPING_MODE_H 