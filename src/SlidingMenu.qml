import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Rectangle {

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            color: "#060608"

            Image {
                anchors.fill: parent
                source: "qrc:///resource/img_nav_header.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: cityManageMouseArea.pressed ? "#EEEEEE" : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                spacing: 20

                Item {
                    Layout.preferredHeight: parent.height / 2
                    Layout.preferredWidth: parent.height / 2

                    Image {
                        id: cityManageImage
                        anchors.fill: parent
                        source: "qrc:///resource/ic_menu_city_manage.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    ColorOverlay {
                        anchors.fill: parent
                        source: cityManageImage
                        color: settings.primaryColor
                    }
                }

                Text {
                    text: qsTr("城市管理")
                    font.pixelSize: 20
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            MouseArea {
                id: cityManageMouseArea
                anchors.fill: parent
                onClicked: {
                    drawer.close()
                    stackView.push(Qt.resolvedUrl("qrc:///CitysManagePage.qml"))
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 50

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                Text {
                    text: qsTr("其他")
                    font.pixelSize: 20
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: skinManageMouseArea.pressed ? "#EEEEEE" : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                spacing: 20

                Item {
                    Layout.preferredHeight: parent.height / 2
                    Layout.preferredWidth: parent.height / 2

                    Image {
                        id: skinManageImage
                        anchors.fill: parent
                        source: "qrc:///resource/ic_menu_skin.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    ColorOverlay {
                        anchors.fill: parent
                        source: skinManageImage
                        color: settings.primaryColor
                    }
                }

                Text {
                    text: qsTr("主题皮肤")
                    font.pixelSize: 20
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            MouseArea {
                id: skinManageMouseArea
                anchors.fill: parent
                onClicked: {
                    drawer.close()
                    themeWnd.open()
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: checkUpdateMouseArea.pressed ? "#EEEEEE" : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                spacing: 20

                Item {
                    Layout.preferredHeight: parent.height / 2
                    Layout.preferredWidth: parent.height / 2

                    Image {
                        id: checkUpdateImage
                        anchors.fill: parent
                        source: "qrc:///resource/ic_menu_check_update.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    ColorOverlay {
                        anchors.fill: parent
                        source: checkUpdateImage
                        color: settings.primaryColor
                    }
                }

                Text {
                    text: qsTr("检测更新")
                    font.pixelSize: 20
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            MouseArea {
                id: checkUpdateMouseArea
                anchors.fill: parent
                onClicked: {
                    drawer.close()
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: settingsMouseArea.pressed ? "#EEEEEE" : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                spacing: 20

                Item {
                    Layout.preferredHeight: parent.height / 2
                    Layout.preferredWidth: parent.height / 2

                    Image {
                        id: settingsImage
                        anchors.fill: parent
                        source: "qrc:///resource/ic_menu_settings.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    ColorOverlay {
                        anchors.fill: parent
                        source: settingsImage
                        color: settings.primaryColor
                    }
                }

                Text {
                    text: qsTr("设置")
                    font.pixelSize: 20
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            MouseArea {
                id: settingsMouseArea
                anchors.fill: parent
                onClicked: {
                    drawer.close()
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: aboutMouseArea.pressed ? "#EEEEEE" : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                spacing: 20

                Item {
                    Layout.preferredHeight: parent.height / 2
                    Layout.preferredWidth: parent.height / 2

                    Image {
                        id: aboutImage
                        anchors.fill: parent
                        source: "qrc:///resource/ic_menu_about.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    ColorOverlay {
                        anchors.fill: parent
                        source: aboutImage
                        color: settings.primaryColor
                    }
                }

                Text {
                    text: qsTr("关于")
                    font.pixelSize: 20
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            MouseArea {
                id: aboutMouseArea
                anchors.fill: parent
                onClicked: {
                    drawer.close()
                    stackView.push(aboutPage)
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }


    Component {
        id: aboutPage
        AboutPage {
        }
    }

}
