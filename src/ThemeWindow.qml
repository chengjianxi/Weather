import QtQuick 2.7
import QtQuick.Controls 2.2

Dialog {
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    modal: true
    x: parent.width / 2 - width / 2;
    y: parent.height / 2 - height / 2
    //width: 200
    //height: 300

    contentItem: Rectangle {
        Grid {
            id: grid
            spacing : 20
            padding: 20
            columns: 3

            ThemeColorCell { cellColor: "#FF2196F3" }
            ThemeColorCell { cellColor: "#FF03A9F5" }
            ThemeColorCell { cellColor: "#FFFA7298" }

            ThemeColorCell { cellColor: "#FFF44236" }
            ThemeColorCell { cellColor: "#FF9C28B1" }
            ThemeColorCell { cellColor: "#FF673BB7" }

            ThemeColorCell { cellColor: "#FF009788" }
            ThemeColorCell { cellColor: "#FFFE5722" }
            ThemeColorCell { cellColor: "#FF47C66D" }

            ThemeColorCell { cellColor: "#FF00BCD5" }
            ThemeColorCell { cellColor: "#FFFF9700" }
            ThemeColorCell { cellColor: "#FF5F51B5" }

            ThemeColorCell { cellColor: "#FF795547" }
            ThemeColorCell { cellColor: "#FF607D8B" }
            ThemeColorCell { cellColor: "#FF000000" }
        }
    }

    function setPrimaryColor(c) {
        settings.primaryColor = c
        themeWnd.close();
    }
}
