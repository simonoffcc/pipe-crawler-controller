#ifndef PAIRS_GROUPING_MODE_H
#define PAIRS_GROUPING_MODE_H

#include <QObject>
#include <QString>
#include <QMap>

/// \class Класс группировки колесных пар робота для публикации единой целевой скорости
class PairsGroupingMode : public QObject {
    Q_OBJECT
public:
    enum Mode {
        CUSTOM = 0,       ///< Кастомный пресет (все другие способы группировки колёсных пар) 
        LEFT_RIGHT = 1,   ///< Левые и правые пары (4 пары)
        ALL_PAIRS = 2     ///< Все пары (6 пар)
    };
    Q_ENUM(Mode)

    static QString toString(Mode mode) {
        static const QMap<Mode, QString> modeMap = {
            {Mode::CUSTOM, "Custom"},
            {Mode::LEFT_RIGHT, "Left-Right wheel pairs"},
            {Mode::ALL_PAIRS, "All cross pairs"}
        };
        return modeMap.value(mode, "Unknown");
    }

    static Mode fromString(const QString& str) {
        static const QMap<QString, Mode> reverseMap = {
            {"Custom", Mode::CUSTOM},
            {"Left-Right wheel pairs", Mode::LEFT_RIGHT},
            {"All cross pairs", Mode::ALL_PAIRS}
        };
        return reverseMap.value(str, Mode::CUSTOM);
    }
};

#endif // PAIRS_GROUPING_MODE_H 