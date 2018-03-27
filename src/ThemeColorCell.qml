import QtQuick 2.0

Rectangle {
    property color cellColor: "#FFFFFF"
    width: 40; height: 40; radius: 20
    color: cellColor

    Rectangle {
        anchors.centerIn: parent
        width: parent.width/2; height: width; radius: width/2
        color: "#FFFFFFFF"
        visible: settings.primaryColor === cellColor

        Rectangle {
            anchors.centerIn: parent
            width: parent.width/2; height: width; radius: width/2
            color: cellColor
            visible: settings.primaryColor === cellColor
        }
    }

    MouseArea {
        anchors.fill: parent;
        onClicked: {
            themeWnd.setPrimaryColor(cellColor)
        }
    }

}
