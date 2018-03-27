// Units.qml
pragma Singleton
import QtQuick 2.7
import QtQuick.Window 2.2

/*!
   \qmltype Units

   \brief Provides access to screen-independent units known as DPs (device-independent pixels).

   This singleton provides methods for building a user interface that automatically scales based on
   the screen density. Use the \l units::dp function wherever you need to specify a screen size,
   and your app will automatically scale to any screen density.

   Here is a short example:

   \qml
   import QtQuick 2.0
   import Material 0.1

   Rectangle {
       width: Units.dp(100)
       height: Units.dp(80)

       Label {
           text:"A"
           font.pixelSize: Units.dp(50)
       }
   }
   \endqml
*/
QtObject {

    /*!
       \internal
       This holds the pixel density used for converting millimeters into pixels. This is the exact
       value from \l Screen:pixelDensity, but that property only works from within a \l Window type,
       so this is hardcoded here and we update it from within \l ApplicationWindow
    */
    property real __pixelDensity: Screen.pixelDensity // pixels/mm

    function cm(number) {
        return number * __pixelDensity * 10
    }

    /*!
       Converts millimeters into pixels. Used primarily by \l units::dp, but there might be other
       uses for it as well.
    */
    function mm(number) {
        return number * __pixelDensity
    }

    function inch(number) {
        return number * __pixelDensity * 10 * 2.54
    }

    // 相对以视窗的宽度，视窗宽度是100vm
    function vw(i, width) {
        return number * (width / 100)
    }

    // 相对以视窗的高度，视窗高度是100vh
    function vh(number, height) {
        return number * (height / 100)

    }

    function vmin(number, width, height) {
        return number * (Math.min(width, height) / 100)
    }

    function vmax(number, width, height){
        return number * (Math.max(width, height) / 100)
    }

    function dp(number) {
        var px = Math.round(number * (__pixelDensity * 25.4 / 160));

        if(Qt.platform.os === "windows" || Qt.platform.os === "mac")
            return px * 2;
        else
            return px;
    }
}
