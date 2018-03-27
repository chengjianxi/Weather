import QtQuick 2.0
import QtQuick.Window 2.1


Window {
    id: splash
    //color: "transparent"
    color: "red"
    title: "Splash Window"
    modality: Qt.ApplicationModal
    flags: Qt.SplashScreen
    property int timeoutInterval: 2000
    signal timeout
    //x: (Screen.width - splashImage.width) / 2
   // y: (Screen.height - splashImage.height) / 2
   // width: splashImage.width
   // height: splashImage.height
    width: 400
    height: 300

//    Image {
//        id: splashImage
//        source: "../shared/images/qt-logo.png"
//        MouseArea {
//            anchors.fill: parent
//            onClicked: Qt.quit()
//        }
//    }
    Timer {
        interval: timeoutInterval; running: true; repeat: false
        onTriggered: {
            visible = false
            splash.timeout()
        }
    }
    Component.onCompleted: visible = true
}
