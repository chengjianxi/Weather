import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.2
import QtGraphicalEffects 1.0
import QtQuick.LocalStorage 2.0
import "Database.js" as DBJS

Page {
    id: citysMange

    header: NavigationBar {
        id: h
        title: qsTr("城市管理")
    }

    DelegateModel {
        id: visualModel
        model: ListModel {
            //ListElement { cityname: "Apple" }
            //ListElement { cityname: "Orange" }
            //ListElement { cityname: "Banner" }
            //ListElement { cityname: "Apple" }
        }

        delegate: MouseArea {
            id: dragArea
            property bool held: false
            property bool needRemove: false
            width: l.width
            height: 48

            drag.target: wrapper    //held ? wrapper : undefined
            drag.axis: held ? Drag.YAxis : Drag.XAxis

            onPressAndHold: held = true
            onReleased: {
                if (!held && needRemove && visualModel.model.count > 1) {
                    DBJS.removeCityFromLocalStorage(visualModel.model.get(index).cityid)
                    visualModel.model.remove(index)
                }

                needRemove = false;
                held = false
            }
            onPositionChanged: {
                if (wrapper.x > wrapper.width/2 || wrapper.x < -wrapper.width/2)
                    needRemove = true;
                else
                    needRemove = false
            }

            Rectangle {
                id: wrapper
                color: dragArea.held ? "#655E67" : dragArea.pressed ? "#EEEEEE" : "transparent"
                //Behavior on color { ColorAnimation { duration: 1000 } }
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                width: dragArea.width; height: dragArea.height

                Drag.active: dragArea.pressed//dragArea.held
                Drag.source: dragArea
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                states: State {
                    when: dragArea.pressed//dragArea.held

                    ParentChange { target: wrapper; parent: citysMange }
                    AnchorChanges {
                        target: wrapper
                        anchors { horizontalCenter: undefined; verticalCenter: undefined }
                    }
                }

                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 17
                    text: cityname
                }

//                Image {
//                    id: deleteButton
//                    anchors.right: parent.right
//                    anchors.verticalCenter: parent.verticalCenter
//                    width: 48;
//                    height: width
//                    source: "qrc:/resource/trash.png"

//                    MouseArea {
//                        anchors.fill: parent
//                        onClicked: {
//                            console.log("deleteButton onClicked");
//                        }
//                    }


//                }

//                ColorOverlay {
//                    anchors.fill: deleteButton
//                    source: deleteButton
//                    color: settings.primaryColor
//                }

                ToolButton {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 48;
                    height: width
                    Image {
                        id: deleteImage
                        anchors.fill: parent
                        source: "qrc:/resource/trash.png"
                    }
                    ColorOverlay {
                        anchors.fill: parent
                        source: deleteImage
                        color: settings.primaryColor
                    }
                    onClicked: {
                        if (visualModel.model.count > 1) {
                            DBJS.removeCityFromLocalStorage(visualModel.model.get(index).cityid)
                            visualModel.model.remove(index);
                        }
                    }
                }

                Behavior on x {
                    NumberAnimation { duration: 1000 }
                }
            }

            DropArea {
                anchors { fill: parent; margins: 10 }

                onEntered: {
                    //console.log(drag.source.DelegateModel.itemsIndex,
                    //            dragArea.DelegateModel.itemsIndex)

                    if (drag.source.DelegateModel.itemsIndex !== dragArea.DelegateModel.itemsIndex) {
                        visualModel.model.move(drag.source.DelegateModel.itemsIndex,
                                    dragArea.DelegateModel.itemsIndex, 1)


                    }
                }
            }

            // 需要配合ListView{remove: Transition}
            //ListView.onRemove: SequentialAnimation {
            //    PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: true }
            //    NumberAnimation { target: wrapper; property: "scale"; to: 0; duration: 2500; easing.type: Easing.InOutQuad }
            //    PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: false }
            //}

            ListView.onAdd: {
                //var component = Qt.createComponent("WeatherUnit.qml");
                //if (component.status === Component.Ready)
                //    mainForm.pageView.addItem(component.createObject(mainForm.pageView, {"cityid": cityid, "cityname": cityname}))
            }
        }
    }

    contentItem: ListView {
        id: l
        clip: true
        //anchors.top: h.bottom
        //anchors.fill: parent
        //interactive: false
        model: visualModel

        moveDisplaced: Transition {
            NumberAnimation { properties: "y"; duration: 200 }
        }

        removeDisplaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 200 }
        }
    }

    ToolButton {
        id: addCityButton
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 20
        anchors.rightMargin: 20

        background: Item {
            implicitWidth: 40
            implicitHeight: 40
            //color: Qt.darker(settings.primaryColor, addCityButton.enabled && (addCityButton.checked || addCityButton.highlighted || addCityButton.pressed) ? 1.5 : 1.0)
            //opacity: addCityButton.enabled ? 1 : 0.3

            Image {
                id: addCityImage
                anchors.fill: parent
                fillMode: Image.Stretch
                source: "qrc:/resource/plus-circle.png"
            }

            ColorOverlay {
                anchors.fill: addCityImage
                source: addCityImage
                color: Qt.darker(settings.primaryColor, addCityButton.enabled && (addCityButton.checked || addCityButton.highlighted || addCityButton.pressed) ? 1.5 : 1.0)
            }

        }

        onClicked: {
            if (visualModel.model.count >= 5) {
                mainWnd.toast.showToast(qsTr("最多添加5个城市"))
                return;
            }

            mainWnd.stackView.push(Qt.resolvedUrl("qrc:///SearchCityPage.qml"), {"citysMangePage": citysMange});
        }
    }

    Component.onCompleted: {
        // fixbug, stackView.push(Page{s})
        height = parent.height-1
        height = parent.height

        var citys = DBJS.loadCitysFromLocalStorage()
        for (var i=0; i<citys.length; i+=2) {
            addCity(citys[i], citys[i+1], false)
        }
    }

    Component.onDestruction: {
        // 更新sequence
        var ls = new Array
        for (var i=0; i<visualModel.model.count; i++ ) {
            //ls.push([false, visualModel.model.get(i).cityid, i]);
            ls.push(visualModel.model.get(i).cityid);
        }
        if (ls.length > 0) {
            DBJS.updateCitySequenceToLocalStorage(ls);
        }

        while (mainWnd.swipeView.count > 0)
            mainWnd.swipeView.removeItem(0)
        mainWnd.swipeView.loadCitys();
    }

    function addCity(cid, cname, insertDb) {
        var exist = false;
        for (var i=0; i<visualModel.model.count; i++ ) {
            if (visualModel.model.get(i).cityid === cid)
                exist = true
        }
        if (!exist) {
            visualModel.model.append({cityid: cid, cityname: cname})
            if (insertDb) {
                DBJS.insertToLocalStorage(cid, cname, visualModel.model.count-1)
            }
        }
    }
}
