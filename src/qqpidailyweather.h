#ifndef QQPIDAILYWEATHER_H
#define QQPIDAILYWEATHER_H
#include <QQuickPaintedItem>
#include <QDate>

class DailyWeatherData1 : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int code
               READ code WRITE setCode)
    Q_PROPERTY(QString description
               READ description WRITE setDescription)
    Q_PROPERTY(QDate date
               READ date WRITE setDate)
    Q_PROPERTY(int maxtmp
               READ maxtmp WRITE setMaxTemp)
    Q_PROPERTY(int mintmp
               READ mintmp WRITE setMinTemp)
    Q_PROPERTY(int pop
               READ pop WRITE setPop)
    Q_PROPERTY(QString windscale
               READ windscale WRITE setWindsSale)

public:
    explicit DailyWeatherData1(){}
    DailyWeatherData1(const DailyWeatherData1 &d) {
        m_code = d.code();
        m_descr = d.description();
        m_date = d.date();
        m_maxtmp = d.maxtmp();
        m_mintmp = d.mintmp();
        m_pop = d.pop();
        m_windscale = d.windscale();
    }

    int code() const { return m_code; }
    QString description() const { return m_descr; }
    QDate date() const { return m_date; }
    int maxtmp() const { return m_maxtmp; }
    int mintmp() const { return m_mintmp; }
    int pop() const { return m_pop; }
    QString windscale() const { return m_windscale; }

    void setCode(int code) { m_code = code; }
    void setDescription(const QString & descr) { m_descr = descr; }
    void setDate(const QDate& date) { m_date = date; }
    void setMaxTemp(int value) { m_maxtmp = value; }
    void setMinTemp(int value) { m_mintmp = value; }
    void setPop(int value) { m_pop = value; }
    void setWindsSale(const QString & value) { m_windscale = value; }

private:
    // Daily Weather Info
    int     m_code;          // 天气状况代码
    QString m_descr;         // 天气状况描述
    QDate   m_date;          // 日期
    int     m_maxtmp;        // 最高温度
    int     m_mintmp;        // 最低温度
    int     m_pop;           // 降水概率
    QString m_windscale;     // 风力等级
};

struct DailyWeatherData {
    int     code;          // 天气状况代码
    QString descr;         // 天气状况描述
    QDate   date;          // 日期
    int     maxtmp;        // 最高温度
    int     mintmp;        // 最低温度
    int     pop;           // 降水概率
    QString windscale;     // 风力等级
};

class QQPIDailyWeather : public QQuickPaintedItem
{
    Q_OBJECT
public:
    QQPIDailyWeather();

    Q_INVOKABLE void setDailyForecast(const QString& json);

    void paint(QPainter* painter);
    void drawBezier(QPainter* painter, int x, int y, int width, int height, int itemWidth);
    void drawDate(QPainter* painter, int x, int y, int width, int height, int itemWidth);
    void drawIcon(QPainter* painter, int x, int y, int width, int height, int itemWidth);
    void drawText(QPainter* painter, int x, int y, int width, int height, int itemWidth);
    void drawPop(QPainter* painter, int x, int y, int width, int height, int itemWidth);
    void drawWind(QPainter* painter, int x, int y, int width, int height, int itemWidth);
    void drawCondition(QPainter* painter);

private:
     QList<DailyWeatherData> m_list;
     QColor m_foregroundColor;
};

#endif // QQPIWEATHERDAILY_H
