import QtQuick 2.7
import QtQml.Models 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QuickPaintedItemEx 1.1
import QtQuick.LocalStorage 2.0
import "Database.js" as DBJS

ListViewEx {
    id: weatherUnit
    property string cityid
    property string cityname
    property var condTextLabel: condTextLabel
    property var tempImg: tempImg
    property var otherLabel: otherLabel
    property var upateTimeLabel: upateTimeLabel
    property var dailyWeatherControl: dailyWeatherControl
    property int condCode: 999

    model: ObjectModel {
        Item {
            // 第一屏
            width: weatherUnit.width
            height: weatherUnit.height + 145

            ColumnLayout {
                anchors.fill: parent

                Item {
                    Layout.fillWidth: true
                    height: Units.dp(20)
                }

                Item {
                    Layout.fillWidth: true
                    height: 40

                    Label {
                        id: condTextLabel
                        anchors.centerIn: parent
                        text: ""
                        color: settings.foregroundColor
                        font.pixelSize: 25
                    }

                    Label {
                        id: upateTimeLabel
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 20
                        color: settings.foregroundColor
                        font.pixelSize: 15
                    }
                }
                Item {
                    Layout.fillWidth: true
                    height: Units.dp(60)

                    Image {
                        id: tempImg
                        //fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                    }
                }
                Item {
                    Layout.fillWidth: true
                    height: 50
                    //color: "green"  // 当前 空气质量 / 风力 / 湿度等

                    Label {
                        id: otherLabel
                        anchors.centerIn: parent
                        //text: "优 42"
                        color: settings.foregroundColor
                        font.pixelSize: 15
                    }
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                Item {
                    Layout.fillWidth: true
                    height: 450
                    //color: "green"  // 一周天气预报（温度曲线，星期，天气图标，天气）

                    DailyWeather {
                        id: dailyWeatherControl
                        anchors.fill: parent
                        anchors.margins: 5
                    }
                }
            }
        }

        /*Rectangle {
            width: weatherUnit.width
            height: 20
            color: "red"
        }
        Rectangle {
            width: weatherUnit.width
            height: 40
            color: "blue"
        }
        Rectangle {
            width: weatherUnit.width
            height: 60
            color: "yellow"
        }
        Rectangle {
            width: weatherUnit.width
            height: 50
            color: "green"
        }

        Rectangle {
            width: weatherUnit.width
            height: 50
            color: "green"
        }*/
    }

    Component.onCompleted: {
        var jsonString = DBJS.loadForecastFromLocalStorage(cityid);
        parseJSON(jsonString)
    }


    onLoad: {
        var xhr = new XMLHttpRequest;
        var url = "https://free-api.heweather.com/s6/weather?key=%1&location=%2";
        url = url.arg(Global.heweatherAppkey);
        url = url.arg(cityid);
        //print(url)
        xhr.open("GET", url);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    if (parseJSON(xhr.responseText)) {
                        updateSucceed()
                        DBJS.cacheToLocalStorage(cityid, xhr.responseText)
                    }
                    else {
                        log4Qml.qDebug_Info(0, "解析Json失败，" + xhr.responseText);
                        updateFail()
                    }
                }
                else {
                    log4Qml.qDebug_Info(0, "调用接口失败，" + xhr.status);
                    updateFail()
                }
            }
        }
        xhr.send();
    }

    function parseJSON(jsonString) {
        if (jsonString === null || jsonString.length === 0) return;
        try {
            var JsonObject= JSON.parse(jsonString);
            var HeWeather6Array = JsonObject.HeWeather6;
            if (Array.isArray(HeWeather6Array) && HeWeather6Array[0].status === "ok") {
                // 城市信息
                var city_name = HeWeather6Array[0].basic.location;
                //var city_id = HeWeather6Array[0].basic.cid;
                var utc_time = convertGMTStringToDate(HeWeather6Array[0].update.utc);

                // 实况天气
                var cond_code = HeWeather6Array[0].now.cond_code;
                var cond_txt = HeWeather6Array[0].now.cond_txt;
                var tmp = HeWeather6Array[0].now.tmp;
                var wind_dir = HeWeather6Array[0].now.wind_dir;
                var wind_sc = HeWeather6Array[0].now.wind_sc;

                // s6版本常规天气集合中没有 aqi
                //var aqi = HeWeather6Array[0].aqi.city.aqi;
                //var aqi_qlty = HeWeather6Array[0].aqi.city.qlty;

                condCode = cond_code;
                weatherUnit.condTextLabel.text = cond_txt;
                var cur_utc_time = new Date()
                if (utc_time.toDateString() !== cur_utc_time.toDateString())
                    upateTimeLabel.text = utc_time.getMonth()+1 + "/" + utc_time.getDate() + qsTr(" 发布")
                else
                    upateTimeLabel.text = utc_time.getHours() + ":" + utc_time.getMinutes() + qsTr(" 发布")
                //weatherUnit.cityid = city_id;
                weatherUnit.cityname = city_name
                weatherUnit.tempImg.source = tempImage(tmp)
                //weatherUnit.otherLabel.text = aqi_qlty + " " + aqi
                weatherUnit.otherLabel.text = wind_dir + " " + wind_sc + "级"

                var daily_forecast = HeWeather6Array[0].daily_forecast;
                dailyWeatherControl.setDailyForecast(JSON.stringify(daily_forecast))

                swipeView.currentItemChanged();
                return true;
            }
        } catch(e) {
            console.log(e.message); // error in the above string (in this case, yes)!
            return false;
        }
    }

    function convertGMTStringToDate(gmt) {
        gmt += "Z"
        var utc = new Date(gmt);
        return utc
    }

    function tempImage(temp) {
        var prefix = null;
        if (temp < 0 && temp >= -50)
            prefix = "temp_n" + Math.abs(temp) + ".png";
        else if (temp >= 0 && temp < 100)
            prefix = "temp_" + Math.abs(temp) + ".png";
        else
            prefix = "temp_unkonwn.png"
        return Qt.resolvedUrl("qrc:/temperature/resource/temperature/" + prefix);
    }
}
