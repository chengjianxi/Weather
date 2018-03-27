#ifndef ANIMATIONWEATHER_H
#define ANIMATIONWEATHER_H
#include <QQuickPaintedItem>
#include <QSequentialAnimationGroup>

class AnimationWeather : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(double value
               READ value WRITE setValue)
    Q_PROPERTY(Type type READ type WRITE setType NOTIFY typeChanged)

public:
    AnimationWeather(QQuickItem *parent = Q_NULLPTR);

    Q_INVOKABLE void setHeWeatherCode(int code);

    void setValue(int value);
    int value() const;

    enum Type {
        DEFAULT = 0,
        CLEAR_D,
        CLEAR_N,
        CLOUDY_D,
        CLOUDY_N,
        OVERCAST_D,
        OVERCAST_N,
        FOG_D,
        FOG_N,
        RAIN_D,
        RAIN_N,
        SNOW_D,
        SNOW_N,
        RAIN_SNOW_D,
        RAIN_SNOW_N,
        HAZE_D,
        HAZE_N
        //SAND_D,SAND_N,
        //WIND_D,WIND_N, UNKNOWN_D, UNKNOWN_N
    };
    Q_ENUMS(Type)
    void setType(Type t);
    Type type() const;

private:
    void paint(QPainter* painter);
    void drawClear(QPainter* painter);
    void drawCloudy(QPainter* painter);
    void drawFog(QPainter* painter);

signals:
    void typeChanged();

private:
    QBrush backgroundBrush();

private:
    Type m_type;
    static const char* m_backgroundColor[][2];
    int m_value;            // 在0-20之间震荡
    QSequentialAnimationGroup *m_sequentialAnimationGroup;
};

#endif // ANIMATIONWEATHER_H
