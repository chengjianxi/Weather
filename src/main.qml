
import QtQuick 2.0

QtObject {
    property var mainWindow: MainWindow {
        visible: true
    }

    /*property var splashWindow: Splash {
        onTimeout: mainWindow.visible = true
    }*/
}
