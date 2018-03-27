import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QuickWeatherEx 1.0
import QtQuick.LocalStorage 2.0
import "Database.js" as DBJS
import QtQuick.Window 2.2
import Qt.labs.settings 1.0
import WeatherAppModel 1.0

ApplicationWindow {
    id: mainWnd
    width: 405
    height: 720
    minimumWidth: 405
    minimumHeight: 720
    title: qsTr("Weather")
    property alias stackView: stackView
    property alias swipeView: swipeView
    property alias drawer: drawer
    property alias settings: settings
    property alias toast: toast
    property alias webFontName: webFont.name

    FontLoader { id: webFont; source: "qrc:///fonts/Roboto-Medium.ttf" }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: mainView
        focus: true

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 200
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 200
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 200
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 200
            }
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_Backspace && stackView.depth > 1) {
                stackView.pop()
                event.accepted = true;
            }
        }

        onCurrentItemChanged: {
            if (currentItem && stackView.depth > 1) {
                currentItem.focus = true
            }
        }
    }

    Page {
        id: mainView

        background: WeatherBackground { id: animationWeather }

        header: ToolBar {
            background: Item {
                //color: "red"
                implicitHeight: i.height
            }

            property var inline: ToolBar {
                id: i
                visible: false;
                position: ToolBar.Header
            }

            RowLayout {
                anchors.fill: parent

                ToolButton {
                    id: menuButton

                    property var inline: ToolButton {
                        id: b1
                        visible: false;
                    }

                    background: Rectangle {
                        implicitWidth:  b1.width
                        implicitHeight: b1.height
                        color: menuButton.pressed ? "#33333333" : "transparent"

                        Image {
                            anchors.fill: parent
                            anchors.margins: 4 //Units.dp(4)
                            fillMode: Image.Stretch
                            source: "qrc:/resource/menu.png"
                            //source: scalability.imageSource("res", "humberg.png")
                        }
                    }

                    onClicked: drawer.open()
                }

                Label {
                    text: swipeView.currentItem === null ? qsTr("请添加城市") : swipeView.currentItem.cityname
                    color: settings.foregroundColor
                    font.pixelSize: 20
                    font.weight: Font.Black
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }

                ToolButton {
                    id: moreButton

                    property var inline: ToolButton {
                        id: b2
                        visible: false;
                    }

                    background: Rectangle {
                        implicitWidth: b2.width
                        implicitHeight: b2.height
                        color: moreButton.pressed ? "#33333333" : "transparent"

                        Image {
                            anchors.fill: parent
                            anchors.margins: 4
                            fillMode: Image.Stretch
                            source: "qrc:/resource/dot_menu.png"
                        }
                    }

                    onClicked: menu.open()
                }

                Menu {
                    id: menu
                    x: mainWnd.width - menu.width - 10
                    y: 10

                    MenuItem {
                        text: qsTr("设置")
                    }
                    MenuItem {
                        text: qsTr("分享天气")
                        onTriggered: {
                        }
                    }
                    MenuItem {
                        text: qsTr("动态背景预览")
                        onTriggered: {
                            previewMenu.x = (mainWnd.width - previewMenu.width) / 2
                            previewMenu.y = (mainWnd.height - previewMenu.height) / 2
                            previewMenu.open()
                        }
                    }
                    MenuItem {
                        text: qsTr("退出")
                        onTriggered: close()
                    }
                }

                Menu {
                    id: previewMenu

                    MenuItem {
                        text: qsTr("晴")
                        onTriggered: animationWeather.type = isNight() ? AnimationWeather.CLEAR_N : AnimationWeather.CLEAR_D;
                    }
                    MenuItem {
                        text: qsTr("多云")
                        onTriggered: animationWeather.type = isNight() ? AnimationWeather.CLOUDY_N : AnimationWeather.CLOUDY_D;
                    }
                    MenuItem {
                        text: qsTr("阴")
                        onTriggered: animationWeather.type = isNight() ? AnimationWeather.OVERCAST_N : AnimationWeather.OVERCAST_D;
                    }
                    MenuItem {
                        text: qsTr("雾")
                        onTriggered: animationWeather.type = isNight() ? AnimationWeather.FOG_N : AnimationWeather.FOG_D;
                    }
                    MenuItem {
                        text: qsTr("雨")
                        onTriggered: animationWeather.type = isNight() ? AnimationWeather.RAIN_N : AnimationWeather.RAIN_D;
                    }
                    MenuItem {
                        text: qsTr("雪")
                        onTriggered: animationWeather.type = isNight() ? AnimationWeather.SNOW_N : AnimationWeather.SNOW_D;
                    }
                    MenuItem {
                        text: qsTr("雨夹雪")
                        onTriggered: animationWeather.type = isNight() ? AnimationWeather.RAIN_SNOW_N : AnimationWeather.RAIN_SNOW_D;
                    }
                    MenuItem {
                        text: qsTr("霾")
                        onTriggered: animationWeather.type = isNight() ? AnimationWeather.HAZE_N : AnimationWeather.HAZE_D;
                    }
                }
            }
        }

        Drawer {
            id: drawer
            width: 0.8 * parent.width
            height: parent.height
            interactive: stackView.depth == 1

            SlidingMenu {
                anchors.fill: parent
            }
        }

        SwipeView {
            id: swipeView
            anchors.fill: parent
            currentIndex: pageIndicator.currentIndex

            Component.onCompleted: {
                DBJS.initLocalStorage();
                loadCitys();
            }

            onCurrentItemChanged: {
                //console.log("swipeView onCurrentItemChanged")
                // 天气动画改变
                if (currentItem !== null)
                    animationWeather.setHeWeatherCode(currentItem.condCode);
                else
                    animationWeather.setHeWeatherCode(999);
            }

            function loadCitys() {
                var citys = DBJS.loadCitysFromLocalStorage()
                for (var i=0; i<citys.length; i+=2) {
                    var component = Qt.createComponent("WeatherUnit.qml");
                    if (component.status === Component.Ready) {
                        var object = component.createObject(swipeView, {"cityid":citys[i], "cityname":citys[i+1]});
                        //swipeView.addItem(object);
                        swipeView.currentItemChanged()
                    }
                }
            }
        }

        PageIndicator {
            id: pageIndicator
            interactive: true
            count: swipeView.count
            currentIndex: swipeView.currentIndex

            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Settings {
        id: settings
        property color primaryColor: "#FF47C66D"
        property color foregroundColor: "#BBFFFFFF"
    }

    AppModel { id: appModel }

    ThemeWindow { id: themeWnd }

    Toast {
        id: toast
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: toast.height
    }

    function isNight() {
        var hr = (new Date()).getHours(); //get hours of the day in 24Hr format (0-23)
        if (hr < 6 || hr >= 18)
            return true
        else
            return false
    }

    Component.onCompleted: {
        log4Qml.truncateLog();
        log4Qml.qDebug_Info(0, "Qt.platform.os = " + Qt.platform.os);
        log4Qml.qDebug_Info(0, "PixelDensity = " + Screen.pixelDensity);
        log4Qml.qDebug_Info(0, "1 dp = " + Units.dp(1) + " px");
        log4Qml.qDebug_Info(0, "1 inch = " + Units.inch(1) + " px");
        log4Qml.qDebug_Info(0, "1 mm = " + Units.mm(1) + " px");
    }
}
