import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "."

Rectangle {
    property bool isShow: false
    property alias text: t.text     // 显示的文字
    width: childrenRect.width
    height: childrenRect.height
    //z: 100
    color: "#666666"
    opacity: isShow ? 1 : 0
    //border.width: units.dp(1)
    //border.color: "white"
    radius: width/2

    Behavior on opacity {
        NumberAnimation { duration: 1000 }
    }


    ColumnLayout {
        Label {
            //Layout.margins: t.height
            Layout.margins: Units.dp(15)
            id: t;
            color: "white"
            text: ""
        }
    }

    Timer {
        id: toastTimer
        interval: 2000
        onTriggered: isShow = false
    }

    // 显示toast函数
    function showToast(text) {
        t.text = text;
        isShow = true;
        toastTimer.restart();
    }
}
