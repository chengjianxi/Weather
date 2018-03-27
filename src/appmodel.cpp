#include "appmodel.h"
#include <QtCore>
#include <QGuiApplication>
#include <QQuickItem>



AppModel::AppModel(QObject *parent) :
    QObject(parent)
{
    initDatabases();
    //QTimer::singleShot(5000, this, &AppModel::showMainWindow1);
}

AppModel::~AppModel()
{

}

QVariantList AppModel::searchCitys(const QString &keywords)
{
    QVariantList result;
    if (keywords.isEmpty())
        return result;

    QString sql = QStringLiteral("SELECT id, name_cn, city_cn, province_cn FROM \"citys\" WHERE name_en LIKE \"%%1%\" OR name_cn LIKE \"%%1%\" OR city_en LIKE \"%%1%\" OR city_cn LIKE \"%%1%\" OR province_en LIKE \"%%1%\" OR province_cn LIKE \"%%1%\" LIMIT 0, 10").arg(keywords);

    QString connectionName = QUuid::createUuid().toString();
    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", connectionName);
        db.setDatabaseName("./citys.db");
        if (db.open())
        {
            QSqlQuery query(db);
            if (query.exec(sql))
            {
                while (query.next())
                {
                    QString cityid = query.value("id").toString();
                    QString highlightKeywords = QStringLiteral("<font color=\"#DC64FF\">%1</font>").arg(keywords);
                    QString county = query.value("name_cn").toString();
                    //county.replace(keywords, highlightKeywords);
                    QString city = query.value("city_cn").toString();
                    //city.replace(keywords, highlightKeywords);
                    QString state = query.value("province_cn").toString();
                    //state.replace(keywords, highlightKeywords);
                    QString display = QStringLiteral("%1，%2，%3").arg(state).arg(city).arg(county);
                    display.replace(keywords, highlightKeywords);
                    //qDebug().noquote() << display;

                    QList <QVariant> item;
                    item.append(cityid);
                    item.append(county);
                    item.append(display);
                    result.append(item);
                }
                query.clear();
            }
            else
            {
                qDebug().noquote() << __FILE__ << __LINE__ << query.lastError().text();
            }

            db.close();
        }
        else
        {
            qDebug().noquote() << __FILE__ << __LINE__ << db.lastError().text();
        }
    }
    QSqlDatabase::removeDatabase(connectionName);

    return result;
}

void AppModel::initDatabases()
{
    // 复制安卓城市数据库
    copyDatabaseFromAssetsPath();
}

bool AppModel::copyDatabaseFromAssetsPath()
{
    bool result = true;

#ifdef Q_OS_ANDROID
    // 更新"citys.db"
    QString databaseName = QStringLiteral("./citys.db");
    QString assetsDatabaseName = QStringLiteral("assets:/citys.db");

    bool needCopy = true;
    if (QFileInfo::exists(databaseName))
    {
        // 判断数据库版本是否过期
        /*QString connectionName = QUuid::createUuid().toString();
        {
            QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", connectionName);
            db.setDatabaseName(databaseName);
            if (db.open())
            {
                QSqlQuery query(db);
                if (query.exec(QStringLiteral("SELECT version FROM version")))
                {
                    while (query.next())
                    {
                        float version = query.value("version").toFloat();
                        qDebug().noquote() << version << DB_CITYS_VERSION;
                        if (version > DB_CITYS_VERSION)
                        {
                            needCopy = false;
                        }
                    }
                    query.clear();
                }
                else
                {
                    qDebug().noquote() << query.lastError().text();
                }

                db.close();
            }
            else
            {
                qDebug().noquote() << db.lastError().text();
            }
        }
        QSqlDatabase::removeDatabase(connectionName);*/

        if (needCopy)
        {
            // 删除过期的数据库文件
            qDebug().noquote() << "正在删除过期的数据库文件" << databaseName;
            if (!QFile::remove(databaseName))
                qDebug().noquote() << "删除数据库文件失败";
        }
    }

    if (needCopy)
    {
        // 数据库不存在或数据库已经过期，需要拷贝
        //qDebug().noquote() << databaseName << "数据库不存在或数据库已经过期，需要拷贝";
        if (QFileInfo::exists(assetsDatabaseName))
        {
            if (QFile::copy(assetsDatabaseName, databaseName))
            {
                if (!QFile::setPermissions(databaseName, QFile::WriteOwner | QFile::ReadOwner))
                {
                    // 读写权限设置失败
                    result = false;
                    qDebug().noquote() << "读写权限设置失败";
                }
            }
            else
            {
                // 拷贝失败
                result = false;
                qDebug().noquote() << "拷贝失败";
            }
        }
        else
        {
            // assets 目录不存在
            result = false;
            qDebug().noquote() << "assets 目录不存在";
        }
    }
#endif

    return true;

    // 首先判断"weather.db"是否存在， AppModel::databasePath();
    /*bool result = true;
    QString databaseName = AppModel::databaseName();
    QString assetsDatabaseName = AppModel::assetsDatabaseName();
    if (QFileInfo::exists(databaseName))
    {
        // 判断数据库版本是否过期

    }
    else
    {
#ifdef Q_OS_ANDROID
        if (QFileInfo::exists(assetsDatabaseName))
        {
            if (QFile::copy(assetsDatabaseName, databaseName))
            {
                if (!QFile::setPermissions(databaseName, QFile::WriteOwner | QFile::ReadOwner))
                {
                    // 读写权限设置失败
                    result = false;
                }
            }
            else
            {
                // 拷贝失败
                result = false;
            }
        }
        else
        {
            // assets 目录不存在"assets:/weather.db"
            result = false;
        }
#endif
    }*/

    return result;
}

/*QString AppModel::assetsPath()
{
    QString assetsPath;

#ifdef Q_OS_WIN
    assetsPath = QDir::toNativeSeparators("assets:/../database");
#endif

#ifdef Q_OS_ANDROID
    assetsPath = QDir::toNativeSeparators("assets:/database");
#endif

#ifdef Q_OS_IOS
    assetsPath = QDir::toNativeSeparators("assets:/database");
#endif

#ifdef Q_OS_MAC
    assetsPath = QDir::toNativeSeparators("assets:/database");
#endif

    return assetsPath;
}*/

QString AppModel::databaseName()
{
#ifdef Q_OS_ANDROID
    //  "/data/data/org.qtproject.example/files/weather.db"
    return QStringLiteral("./weather.db");
#else
    return QStringLiteral("./weather.db");
#endif
}

QString AppModel::assetsDatabaseName()
{
#ifdef Q_OS_ANDROID
    //  "/data/data/org.qtproject.example/files/weather.db"
    return QStringLiteral("assets:/weather.db");
#else
    return QStringLiteral("./assets/weather.db");
#endif
}

