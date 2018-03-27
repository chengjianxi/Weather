import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "."

ToolBar {
    property alias title: titleLabel.text

    property var inline: ToolBar {
        id: i
        visible: false;
        position: ToolBar.Header
    }

    background: Rectangle {
        implicitHeight: i.height
        color: settings.primaryColor
    }

    RowLayout {
        anchors.fill: parent

        ToolButton {
            id: backButton

            property var inline: ToolButton {
                id: b1
                visible: false;
            }

            background: Rectangle {
                implicitWidth:  b1.width
                implicitHeight: b1.height
                color: backButton.pressed ? "#33333333" : "transparent"

                Image {
                    anchors.fill: parent
                    anchors.margins: 4
                    fillMode: Image.Stretch
                    source: "qrc:/resource/back_arrow.png"
                }
            }

            onClicked: stackView.pop()
        }

        Label {
            id: titleLabel
            anchors.centerIn: parent
            color: settings.foregroundColor
            font.family: webFontName
            font.pixelSize: 20
            font.weight: Font.Black
            elide: Label.ElideRight
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
        }
    }
}
