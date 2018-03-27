import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    header: NavigationBar {
        title: qsTr("关于")
    }

    contentItem: Flickable {
        clip: true
        contentWidth: width
        contentHeight: item.height

        Item {
            id: item
            width: parent.width
            height: childrenRect.height

            Column {
                id: layout
                width: parent.width
                spacing: 20

                Item { width:20; height:20 }

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "qrc:/logo.png"
                    fillMode: Image.PreserveAspectFit
                    height: 40
                    width: 40
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 15
                    text: qsTr("Weather")
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 15
                    text: qsTr("当前版本：1.0.0")
                }

                Item { width:20; height:Units.dp(20) }

                Row {
                    Item { width: 20; height: 10}

                    Label {
                        anchors.leftMargin: 20
                        font.pixelSize: 20
                        text: qsTr("感谢")
                    }
                }

                Row {
                    Rectangle { width: 20; height: 10}

                    Label {
                        anchors.leftMargin: 20
                        font.pixelSize: 15
                        text: qsTr("· 使用C++/Qt/QML开发")
                    }
                }

                Row {
                    Rectangle { width: 20; height: 10}

                    Label {
                        anchors.leftMargin: 20
                        font.pixelSize: 15
                        text: qsTr("· 和风天气提供数据支持")
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        // fixbug, stackView.push(Page{s})
        height = parent.height-1
        height = parent.height
    }
}
