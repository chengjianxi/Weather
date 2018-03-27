import QtQuick 2.7
import QtQuick.Controls 2.0

ListView {
    property bool refresh: false
    property bool loading: false
    clip: true

    signal load();

    header: ListHeader {
        id: headerItem
    }

    headerPositioning: ListView.InlineHeader

    function moveToFirst() {
        contentY = 0;
    }

    Component.onCompleted: {
        moveToFirst();
    }

    onHeightChanged: {
        moveToFirst()
    }

    onMovementStarted: {
        if (!loading)
            headerItem.goState('base');
    }

    onMovementEnded: {
        if (refresh) {
            headerItem.goState('loading');
            loading = true;
            refresh = false;
            load();
        }
        else if (!loading) {
            if (contentY < -1) {
                moveToFirst();
            }
        }
    }

    onContentYChanged: {
        if (contentY < originY) {
            if (contentY < -120 && !loading) {
                headerItem.goState('ready');
                refresh = true;
            }
        }
    }

    Timer {
        id: timer; interval: 500
        onTriggered: moveToFirst()
    }

    function updateSucceed() {
        headerItem.goState('ok');
        loading = false
        refresh = false
        if (contentY < -1) {
            timer.start();
        }
    }

    function updateFail() {
        headerItem.goState('failed');
        loading = false
        refresh = false
        if (contentY < -1) {
            timer.start();
        }
    }
}
