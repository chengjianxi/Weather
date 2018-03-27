

function dbGetHandle() {
    try {
        var db = LocalStorage.openDatabaseSync("citys", "", "", 1000000)
    } catch (err) {
        console.log("Error opening database: " + err)
    }
    return db
}

function initLocalStorage() {
    var db = dbGetHandle();
    try {
        if (db.version === "") {
            db.transaction(function (tx) {
                // Create the 'citys' table if it doesn't already exist
                tx.executeSql('CREATE TABLE IF NOT EXISTS "citys"("city_id"  TEXT, "city_name"  TEXT NOT NULL, "forecast"  TEXT, "update_time"  INTEGER NOT NULL DEFAULT 0, "sequence"  INTEGER NOT NULL, CONSTRAINT "city_id" UNIQUE ("city_id" ASC));');
            })
        }
    } catch (err) {
        console.log("Error creating table in database: " + err)
    };
}

function loadCitysFromLocalStorage() {
    var citys = new Array();
    try {
        var db = dbGetHandle();
        if (db.version === "") {
            db.transaction(function(tx) {
                var rs = tx.executeSql('SELECT city_id, city_name FROM "citys" order by sequence ASC');
                for (var i = 0; i < rs.rows.length; i++) {
                    citys.push(rs.rows.item(i).city_id)
					citys.push(rs.rows.item(i).city_name)
                }
            })
        }
    }
    catch (err) {
        console.log(err);
    }

    return citys;
}

function loadForecastFromLocalStorage(cityid) {
    var forecast = "";
    try {
        var db = dbGetHandle();
        if (db.version === "") {
            db.transaction(function(tx) {
                var rs = tx.executeSql('SELECT * FROM "citys" WHERE "city_id" = ?', [cityid]);
                if (rs.rows.length > 0) {
                    forecast = rs.rows.item(0).forecast;
                }
            })
        }
    }
    catch (err) {
        console.log(err);
    }

    return forecast;
}

function cacheToLocalStorage(cityid, forecast) {
    try {
        var db = dbGetHandle();
        if (db.version === "") {
            db.transaction(function(tx) {
                tx.executeSql('UPDATE "citys" SET "city_name" = ?, "forecast" = ?, "update_time" = ? WHERE city_id = ?',
                              [cityname, forecast, (new Date()).getTime(), cityid]);
            })
        }
    }
    catch (err) {
        console.log(err);
    }
}

function insertToLocalStorage(cityid, cityname, sequence) {
    var db = dbGetHandle()
    var rowid = 0;
    try {
        var db = dbGetHandle();
        if (db.version === "") {
            db.transaction(function(tx) {
                tx.executeSql('INSERT INTO "citys" (city_id, city_name, sequence) VALUES(?, ?, ?)', [cityid, cityname, sequence])
                var result = tx.executeSql('SELECT last_insert_rowid()')
                rowid = result.insertId
            })
        }
    }
    catch (err) {
        console.log(err);
    }
    return rowid;
}

function updateCitySequenceToLocalStorage(cityList) {
    try {
        var db = dbGetHandle();
        if (db.version === "") {
            db.transaction(function(tx) {
                for (var i=0; i<cityList.length; i++ ) {
                    tx.executeSql('UPDATE "citys" SET sequence = ? WHERE city_id = ?', [i, cityList[i]]);
                }
            })
        }
    }
    catch (err) {
        console.log(err);
    }
}

function removeCityFromLocalStorage(cityid) {
    try {
        var db = dbGetHandle();
        if (db.version === "") {
            db.transaction(function(tx) {
                tx.executeSql('DELETE FROM "citys" WHERE city_id = ?', [cityid]);
            })
        }
    }
    catch (err) {
        console.log(err);
    }
}


/*function dbInsert(Pdate, Pdesc, Pdistance) {
    var db = dbGetHandle()
    var rowid = 0;
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO trip_log VALUES(?, ?, ?)',
            [Pdate, Pdesc, Pdistance])
        var result = tx.executeSql('SELECT last_insert_rowid()')
        rowid = result.insertId
    })
    return rowid;
}

function dbReadAll() {
    var db = dbGetHandle()
    db.transaction(function (tx) {
        var results = tx.executeSql(
            'SELECT rowid,date,trip_desc,distance FROM trip_log order by rowid desc')
        for (var i = 0; i < results.rows.length; i++) {
            listModel.append({
                id: results.rows.item(i).rowid,
                checked: " ",
                date: results.rows.item(i).date,
                trip_desc: results.rows.item(i).trip_desc,
                distance: results.rows.item(i).distance
            })
        }
    })
}

function dbUpdate(Pdate, Pdesc, Pdistance, Prowid) {
    var db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql(
            'update trip_log set date=?, trip_desc=?, distance=? where rowid = ?', [Pdate, Pdesc, Pdistance, Prowid])
    })
}

function dbDeleteRow(Prowid) {
    var db = dbGetHandle()
    db.transaction(function (tx) {
        tx.executeSql('delete from trip_log where rowid = ?', [Prowid])
    })
}*/