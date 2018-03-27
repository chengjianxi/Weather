/****************************************************************************
  **
  ** Copyright (C) 2015 The Qt Company Ltd.
  ** Contact: http://www.qt.io/licensing/
  **
  ** This file is part of the examples of the Qt Toolkit.
  **
  ** $QT_BEGIN_LICENSE:BSD$
  ** You may use this file under the terms of the BSD license as follows:
  **
  ** "Redistribution and use in source and binary forms, with or without
  ** modification, are permitted provided that the following conditions are
  ** met:
  **   * Redistributions of source code must retain the above copyright
  **     notice, this list of conditions and the following disclaimer.
  **   * Redistributions in binary form must reproduce the above copyright
  **     notice, this list of conditions and the following disclaimer in
  **     the documentation and/or other materials provided with the
  **     distribution.
  **   * Neither the name of The Qt Company Ltd nor the names of its
  **     contributors may be used to endorse or promote products derived
  **     from this software without specific prior written permission.
  **
  **
  ** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  ** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  ** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  ** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  ** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  ** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  ** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  ** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  ** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  ** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  ** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
  **
  ** $QT_END_LICENSE$
  **
  ****************************************************************************/

import QtQuick 2.0
import QtQuick.Layouts 1.3
import "."

Item {
    id: listHeader
    height: Units.dp(20)
    width: parent.width

    RowLayout {
        spacing: Units.dp(5)
        height: Units.dp(20)
        anchors.centerIn: parent

        AnimatedImage {
            id: image
            //width: 20
            //height: 20
            Layout.preferredHeight: label.height
            Layout.preferredWidth: label.height
            source: ""
            visible: false
            playing: false
        }

        Text {
            id: label
            text: qsTr("下拉刷新")
            font.pixelSize: 17
            color: mainWnd.settings.foregroundColor
        }
    }

    function goState(name){
        if (name === 'base')           { image.source = ""; image.visible = false; image.playing = false; label.text = qsTr("下拉刷新"); }
        else if (name === 'ready') { image.source = ""; image.visible = false; image.playing = false; label.text = qsTr("松开刷新"); }
        else if (name === 'loading')  { image.source = "qrc:///update.gif"; image.visible = true; image.playing = true; label.text = qsTr("正在刷新..."); }
        else if (name === 'ok')    { image.source = "qrc:///succeed.png"; image.visible = true; image.playing = false; label.text = qsTr("刷新成功"); }
        else if (name === 'failed'){ image.source = "qrc:///fail.png"; image.visible = true; image.playing = false; label.text = qsTr("刷新失败"); }
    }
}
