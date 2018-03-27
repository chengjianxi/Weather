#include "animationweather.h"
#include <QLinearGradient>
#include <QPainter>
#include <QPropertyAnimation>
#include <QtMath>
#include <QDateTime>

AnimationWeather::AnimationWeather(QQuickItem *parent):
    QQuickPaintedItem(parent),
    m_type(DEFAULT),
    m_value(0)
{
    setAntialiasing(true);
    setRenderTarget(QQuickPaintedItem::FramebufferObject);

    QPropertyAnimation *anim1 = new QPropertyAnimation(this, "value");
    // Set up anim1
    anim1->setDuration(3000);
    anim1->setStartValue(0);
    anim1->setEndValue(20);

    QPropertyAnimation *anim2 = new QPropertyAnimation(this, "value");
    // Set up anim2
    anim2->setDuration(3000);
    anim2->setStartValue(20);
    anim2->setEndValue(0);

    m_sequentialAnimationGroup = new QSequentialAnimationGroup(this);
    m_sequentialAnimationGroup->setLoopCount(-1);
    m_sequentialAnimationGroup->addAnimation(anim1);
    m_sequentialAnimationGroup->addAnimation(anim2);
    //m_sequentialAnimationGroup->start();
}

void AnimationWeather::setHeWeatherCode(int code)
{
    Type type = DEFAULT;

    bool isNight = false;
    int hr = QDateTime::currentDateTime().time().hour();//get hours of the day in 24Hr format (0-23)
    if (hr < 6 || hr >= 18)
        isNight = true;

    if (code == 100)
        type = isNight ? CLEAR_N : CLEAR_D;
    else if (code >= 101 && code <= 103)
        type = isNight ? CLOUDY_N : CLOUDY_D;
    else if (code == 104)
        type = isNight ? OVERCAST_N : OVERCAST_D;
    else if (code >= 300 && code <= 399)
        type = isNight ? RAIN_N : RAIN_D;
    else if ((code >= 400 && code <= 403) || code == 407)
        type = isNight ? SNOW_D : SNOW_D;
    else if (code >= 405 && code <= 406)
        type = isNight ? RAIN_SNOW_N : RAIN_SNOW_D;
    else if (code >= 501 && code <= 502)
        type = isNight ? FOG_N : FOG_D;
    else if (code >= 503 && code <= 508)
        type = isNight ? HAZE_N : HAZE_D;

    setType(type);
}

void AnimationWeather::setValue(int value)
{
    if (m_value == value)
        return;

    m_value = value;
    update();
}

int AnimationWeather::value() const
{
    return m_value;
}

void AnimationWeather::setType(AnimationWeather::Type t)
{
    m_type = t;
    emit typeChanged();
    update();

    if (m_type == CLEAR_D || m_type == CLOUDY_D || m_type == CLOUDY_N ||
            m_type == OVERCAST_D || m_type == OVERCAST_N ||
            m_type == FOG_D || m_type == FOG_N)
        m_sequentialAnimationGroup->start();
    else
        m_sequentialAnimationGroup->stop();
}

AnimationWeather::Type AnimationWeather::type() const
{
    return m_type;
}

void AnimationWeather::paint(QPainter *painter)
{
    painter->setClipRect(0, 0, width(), height());
    painter->fillRect(0, 0, width(), height(), backgroundBrush());

    switch (m_type) {
    case CLEAR_D:
        drawClear(painter);
        break;

    case CLOUDY_D:
    case CLOUDY_N:
    case OVERCAST_D:
    case OVERCAST_N:
        drawCloudy(painter);
        break;

    case FOG_D:
    case FOG_N:
        drawFog(painter);
        break;

    default:
        break;
    }


    //ctx.arc(width+offset, height+offset, Math.sqrt(width*width+height*height)/2, 0, 360);

   // painter->drawArc(0, 0, 100, 100, 0, 360*16);

    //qDebug() << painter->clipBoundingRect();
}

void AnimationWeather::drawClear(QPainter *painter)
{
    painter->setPen(Qt::NoPen);
    qreal boundedValue = qMin(width(), height());
    qreal radiusStep = boundedValue / 5;
    qreal radius = radiusStep;
    for(int i=0; i<4; i++)
    {
        int alpha = 50 - i * 10 - m_value;
        painter->setBrush(QColor(255, 255, 255, alpha));
        painter->drawEllipse(-radius, -radius, radius*2, radius*2);
        radius += radiusStep;
    }
}

void AnimationWeather::drawCloudy(QPainter *painter)
{
    painter->setPen(Qt::NoPen);

    {
        painter->setBrush(QColor("#28ffffff"));
        int w = width();
        int h = w;
        int x = width()/2 - m_value;
        int y = -(w/4*3);
        painter->drawEllipse(x, y, w, h);
    }

    {
        painter->setBrush(QColor("#33ffffff"));
        int w = width();
        int h = w;
        int x = -width()/3 + m_value;
        int y = -(w/4*3);
        painter->drawEllipse(x, y, w, h);
    }

    {
        painter->setBrush(QColor("#15ffffff"));
        int w = width();
        int h = w;
        int x = m_value*2;
        int y = -(w/4*3);
        painter->drawEllipse(x, y, w, h);
    }
}

void AnimationWeather::drawFog(QPainter *painter)
{
    painter->setPen(Qt::NoPen);
    painter->setBrush(QColor("#4495a2ab"));
    int radius = qSqrt(width()*width() + height()*height()) / 2;
    painter->drawEllipse(-radius-m_value+10, -radius-m_value+10, radius*2, radius*2);
    painter->drawEllipse(width()-radius+m_value-10, height()-radius+m_value-10, radius*2, radius*2);
}

QBrush AnimationWeather::backgroundBrush()
{
    QLinearGradient gradient(0, 0, 0, height());
    gradient.setColorAt(0, m_backgroundColor[m_type][0]);
    gradient.setColorAt(1, m_backgroundColor[m_type][1]);

    return QBrush(gradient);
}

const char* AnimationWeather::m_backgroundColor[][2] = {
    { "#ff3d99c2", "#ff4f9ec5" },         // DEFAULT
    { "#ff3d99c2", "#ff4f9ec5" },         // CLEAR_D
    { "#ff0b0f25", "#ff252b42" },         // CLEAR_N
    { "#ff4f80a0", "#ff4d748e" },         // CLOUDY_D
    { "#ff071527", "#ff252b42" },         // CLOUDY_N
    { "#ff33425f", "#ff617688" },         // OVERCAST_D
    { "#ff262921", "#ff23293e" },         // OVERCAST_N
    { "#ff688597", "#ff44515b" },         // FOG_D
    { "#ff2f3c47", "#ff24313b" },         // FOG_N
    { "#ff4f80a0", "#ff4d748e" },         // RAIN_D
    { "#ff0d0d15", "#ff22242f" },         // RAIN_N
    { "#ff4f80a0", "#ff4d748e" },         // SNOW_D
    { "#ff1e2029", "#ff212630" },         // SNOW_N
    { "#ff4f80a0", "#ff4d748e" },         // RAIN_SNOW_D
    { "#ff1e2029", "#ff212630" },         // RAIN_SNOW_N
    { "#ff616e70", "#ff474644" },         // HAZE_D
    { "#ff373634", "#ff25221d" }          // HAZE_N
};
