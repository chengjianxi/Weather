#ifndef APPMODEL_H
#define APPMODEL_H
#include <QObject>
#include <QtSql/QtSql>

class AppModel : public QObject
{
    Q_OBJECT

public:
    explicit AppModel(QObject *parent = 0);
    ~AppModel();

    Q_INVOKABLE QVariantList searchCitys(const QString& keywords);
    Q_INVOKABLE void initDatabases();

public:
    static bool copyDatabaseFromAssetsPath();

public:
    static QString databaseName();
    static QString assetsDatabaseName();
};

#endif // APPMODEL_H
