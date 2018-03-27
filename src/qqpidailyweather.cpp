#include "qqpidailyweather.h"
#include <QPainter>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>


QQPIDailyWeather::QQPIDailyWeather():
    m_foregroundColor("#BBFFFFFF")
{
    setAntialiasing(true);
}

void QQPIDailyWeather::setDailyForecast(const QString &json)
{
    m_list.clear();

    QJsonDocument jsonDoc = QJsonDocument::fromJson(json.toUtf8());
    if (jsonDoc.isArray()) {
        QJsonArray jsonArray = jsonDoc.array();
        //qDebug() << jsonArray;
        for (int i = 0; i<jsonArray.count(); i++)
        {
            QJsonObject dailyForecastObj = jsonArray.at(i).toObject();
            if (!dailyForecastObj.isEmpty())
            {
                //qDebug() << dailyForecastObj;
                DailyWeatherData dailyData;
                dailyData.date = QDate::fromString(dailyForecastObj.value(QStringLiteral("date")).toString(), Qt::ISODate);
                dailyData.pop = dailyForecastObj.value(QStringLiteral("pop")).toString().toInt();

                dailyData.code = dailyForecastObj.value(QStringLiteral("cond_code_d")).toString().toInt();
                dailyData.descr = dailyForecastObj.value(QStringLiteral("cond_txt_d")).toString();

                dailyData.maxtmp = dailyForecastObj.value(QStringLiteral("tmp_max")).toString().toInt();
                dailyData.mintmp = dailyForecastObj.value(QStringLiteral("tmp_min")).toString().toInt();

                dailyData.windscale = dailyForecastObj.value(QStringLiteral("wind_sc")).toString();

                m_list.append(dailyData);
            }
        }
    }
    update();
}

void QQPIDailyWeather::paint(QPainter *painter)
{
    if (m_list.count() == 0)
        return;

    int width = contentsBoundingRect().width();
    int height = contentsBoundingRect().height();

    int count = m_list.count();
    double itemWidth = (double)width / count;
    double itemHeight = (double)height / 13;

    painter->setPen(m_foregroundColor);
    int y = 0;
    drawBezier(painter, 0, y, width, itemHeight*6, itemWidth);
    y += itemHeight*6;
    drawDate(painter, 0, y, width, itemHeight, itemWidth);
    y += itemHeight;
    drawIcon(painter, 0, y, width, itemHeight, itemWidth);
    y += itemHeight;
    drawText(painter, 0, y, width, itemHeight, itemWidth);
    y += itemHeight;
    drawPop(painter, 0, y, width, itemHeight*2, itemWidth);
    y += itemHeight*2;
    drawWind(painter, 0, y, width, itemHeight*2, itemWidth);
    //drawCondition(painter);

    //int width = contentsBoundingRect().width();
    //int height = contentsBoundingRect().height();

    //painter->setRenderHint(QPainter::Antialiasing);
    //painter->fillRect(contentsBoundingRect(), Qt::color0);
}

void QQPIDailyWeather::drawBezier(QPainter *painter, int x, int y, int width, int height, int itemWidth)
{
    painter->save();
    int padding = 40;
    int count = m_list.count();
    // 边框
    //painter->drawRect(x, y, width, height);

    int maxValue = m_list[0].maxtmp;
    int minValue = m_list[0].mintmp;
    for (int i=0; i<count; ++i)
    {
        maxValue = qMax(m_list[i].mintmp, maxValue);
        maxValue = qMax(m_list[i].maxtmp, maxValue);

        minValue = qMin(m_list[i].mintmp, minValue);
        minValue = qMin(m_list[i].maxtmp, minValue);
    }

    int difValue = maxValue - minValue;
    int h = height - padding*2;
    double unit = (double)h / difValue;
    //painter->drawRect(0, padding, width, h);

    QPainterPath hPath;
    QPainterPath lPath;
    QPolygon hPoints;
    QPolygon lPoints;
    for (int i=0; i<count-1; ++i)
    {
        {
            int hx1 = itemWidth/2 + itemWidth*i;
            int hy1 = padding + unit*(maxValue-m_list[i].maxtmp);

            int hx2 = itemWidth/2 + itemWidth*(i+1);
            int hy2 = padding + unit*(maxValue-m_list[i+1].maxtmp);

            QPainterPath path(QPoint(hx1, hy1));
            path.cubicTo((hx1+ hx2) / 2, hy1, (hx1+ hx2) / 2, hy2, hx2, hy2);
            hPath.addPath(path);

            hPoints.push_back(QPoint(hx1, hy1));
            if (i == (count-2))
                hPoints.push_back(QPoint(hx2, hy2));

            // 温度
            painter->setPen(QPen(m_foregroundColor, 1, Qt::SolidLine));
            painter->drawText(itemWidth*i, hy1 - 20, itemWidth, 20,
                              Qt::AlignHCenter | Qt::AlignVCenter, QStringLiteral("%1°").arg(m_list[i].maxtmp));
            if (i == (count-2))
            {
                painter->drawText(itemWidth*(i+1), hy2 - 20, itemWidth, 20,
                                  Qt::AlignHCenter | Qt::AlignVCenter, QStringLiteral("%1°").arg(m_list[i+1].maxtmp));
            }
        }

        {
            int lx1 = itemWidth/2 + itemWidth*i;
            int ly1 = padding + unit*(maxValue-m_list[i].mintmp);

            int lx2 = itemWidth/2 + itemWidth*(i+1);
            int ly2 = padding + unit*(maxValue-m_list[i+1].mintmp);

            QPainterPath path(QPoint(lx1, ly1));
            path.cubicTo((lx1+ lx2) / 2, ly1, (lx1+ lx2) / 2, ly2, lx2, ly2);
            lPath.addPath(path);

            lPoints.push_back(QPoint(lx1, ly1));
            if (i == (count-2))
                lPoints.push_back(QPoint(lx2, ly2));

            // 温度
            painter->setPen(QPen(m_foregroundColor, 1, Qt::SolidLine));
            painter->drawText(itemWidth*i, ly1, itemWidth, 20,
                              Qt::AlignHCenter | Qt::AlignVCenter, QStringLiteral("%1°").arg(m_list[i].mintmp));
            if (i == (count-2))
            {
                painter->drawText(itemWidth*(i+1), ly2, itemWidth, 20,
                                  Qt::AlignHCenter | Qt::AlignVCenter, QStringLiteral("%1°").arg(m_list[i+1].mintmp));
            }
        }
    }

    painter->setPen(QPen(m_foregroundColor, 1, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin));
    painter->drawPath(hPath);
    painter->drawPath(lPath);

    painter->restore();
}

void QQPIDailyWeather::drawDate(QPainter *painter, int x, int y, int width, int height, int itemWidth)
{
    int count = m_list.count();
    for (int i=0; i<count; ++i)
    {
        int dayOfWeek = m_list[i].date.dayOfWeek();
        //QString date = m_list[i].date.toString("MM/dd");
        QString week;
        switch (dayOfWeek)
        {
        case 1:
            week = tr(u8"周一");
            break;
        case 2:
            week = tr(u8"周二");
            break;
        case 3:
            week = tr(u8"周三");
            break;
        case 4:
            week = tr(u8"周四");
            break;
        case 5:
            week = tr(u8"周五");
            break;
        case 6:
            week = tr(u8"周六");
            break;
        default:
            week = tr(u8"周日");
            break;
        }
        if (QDate::currentDate() == m_list[i].date)
            week = tr(u8"今天");
        //else if (QDate::currentDate().addDays(1) == m_list[i].date)
        //    week = tr(u8"明天");
        //else if (QDate::currentDate().addDays(-1) == m_list[i].date)
        //    week = tr(u8"昨天");

        painter->drawText(x + itemWidth*i, y, itemWidth, height, Qt::AlignVCenter | Qt::AlignCenter, week);
    }
}

void QQPIDailyWeather::drawIcon(QPainter *painter, int x, int y, int width, int height, int itemWidth)
{
    int padding = 5;
    int count = m_list.count();
    for (int i=0; i<count; ++i)
    {

        QString iconFileName;
        if (m_list[i].code >= 200 && m_list[i].code <= 299)
            iconFileName = QStringLiteral(":/weather/resource/weather/%1.png").arg("2xx");
        else if (m_list[i].code >= 500 && m_list[i].code <= 599)
            iconFileName = QStringLiteral(":/weather/resource/weather/%1.png").arg("5xx");
        else
            iconFileName = QStringLiteral(":/weather/resource/weather/%1.png").arg(m_list[i].code);

        QImage image;
        if (QFile::exists(iconFileName))
            image = QImage(iconFileName);
        else
            image = QImage(":/weather/resource/weather/999.png");

        QImage nImg = image.scaled(itemWidth-padding*2, height-padding*2, Qt::KeepAspectRatio);
        QRect rect(nImg.rect());
        QRect devRect(x + itemWidth*i + padding, y + padding, itemWidth - padding * 2, height - padding*2);
        rect.moveCenter(devRect.center());
        //painter->drawImage(rect, nImg);

        // 遮罩层，参考：http://doc.qt.io/qt-5/qtwidgets-painting-imagecomposition-example.html
        //QSize resultSize = QSize(itemWidth-padding*2, height-padding*2);
        QImage resultImage = QImage(rect.size(), QImage::Format_ARGB32_Premultiplied);
        QPainter p(&resultImage);
        p.setCompositionMode(QPainter::CompositionMode_Source);
        p.fillRect(resultImage.rect(), Qt::transparent);
        p.drawImage(0, 0, nImg);
        p.setCompositionMode(QPainter::CompositionMode_SourceIn);
        p.fillRect(resultImage.rect(), Qt::white);
        p.end();
        painter->drawImage(rect, resultImage);
    }
}

void QQPIDailyWeather::drawText(QPainter *painter, int x, int y, int width, int height, int itemWidth)
{
    int count = m_list.count();
    for (int i=0; i<count; ++i)
    {
        painter->drawText(x + itemWidth*i, y, itemWidth, height, Qt::AlignVCenter | Qt::AlignCenter, m_list[i].descr);
    }
}

void QQPIDailyWeather::drawPop(QPainter *painter, int x, int y, int width, int height, int itemWidth)
{
    painter->drawLine(x, y, width, y);
    int half = height / 2;

    painter->drawText(x , y, width, half, Qt::AlignVCenter | Qt::AlignCenter, tr(u8"降水概率"));

    int count = m_list.count();
    for (int i=0; i<count; ++i)
    {
        QString pop = QStringLiteral("%1%").arg(m_list[i].pop);
        painter->drawText(x + itemWidth*i, y + half, itemWidth, half, Qt::AlignVCenter | Qt::AlignCenter, pop);
    }
}

void QQPIDailyWeather::drawWind(QPainter *painter, int x, int y, int width, int height, int itemWidth)
{
    painter->drawLine(x, y, width, y);
    int half = height / 2;

    painter->drawText(x , y, width, half, Qt::AlignVCenter | Qt::AlignCenter, tr(u8"风速预报"));

    int count = m_list.count();
    for (int i=0; i<count; ++i)
    {
        painter->drawText(x + itemWidth*i, y + half, itemWidth, half, Qt::AlignVCenter | Qt::AlignCenter, m_list[i].windscale);
    }
}

void QQPIDailyWeather::drawCondition(QPainter *painter)
{

    int width = contentsBoundingRect().width();
    int height = contentsBoundingRect().height();
    // 边框
    painter->setRenderHint(QPainter::Antialiasing);
    painter->drawRect(0, 0, width-1, height-1);

    int count = m_list.count();
    double itemWidth = (double)width / count;

    for (int i=0; i<count; ++i)
    {
        painter->setPen(QPen(Qt::black, 1, Qt::SolidLine));
        //painter->drawText(itemWidth*i, 0, itemWidth, height,
        //                  Qt::AlignHCenter | Qt::AlignVCenter, m_list[i].description());
        //QString date = QString("%1").arg(m_list[i].date().dayOfWeek());
        //painter->drawText(itemWidth*i, 0, itemWidth, height,
        //                    Qt::AlignHCenter | Qt::AlignVCenter, date);
        QImage image(":/100.png");
        QImage nImg = image.scaled(itemWidth, height, Qt::KeepAspectRatio);
        QRect rect(nImg.rect());
        QRect devRect(itemWidth*i, 0, itemWidth, height);
        rect.moveCenter(devRect.center());
        painter->drawImage(rect, nImg);

        painter->drawText(itemWidth*i, 0, itemWidth, height, Qt::AlignVCenter | Qt::AlignCenter, m_list[i].descr);
    }
}
