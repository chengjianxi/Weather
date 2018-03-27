import QtQuick 2.0
import QtQuick.Particles 2.0
import QtQuick.Layouts 1.3
import QuickWeatherEx 1.0
import QtQuick.Controls 2.1


AnimationWeather {
    anchors.fill: parent

    ParticleSystem {
        id: particleSystemStar
        running: AnimationWeather.CLEAR_N === animationWeather.type
    }
    ImageParticle {
        system: particleSystemStar
        source: "qrc:///particleresources/star.png"
    }
    Emitter {
        system: particleSystemStar
        anchors.fill: parent

        lifeSpan: 4000
        lifeSpanVariation: 200
        emitRate: 20
    }

    ParticleSystem {
        id: particleSystemRain
        running: AnimationWeather.RAIN_D === animationWeather.type ||
                 AnimationWeather.RAIN_N === animationWeather.type ||
                 AnimationWeather.RAIN_SNOW_D === animationWeather.type ||
                 AnimationWeather.RAIN_SNOW_N === animationWeather.type
    }
    ItemParticle {
        system: particleSystemRain
        delegate: Rectangle {
            color: "#BBBBBBBB"
            width: 1
            height: 20
        }
    }
    Emitter {
        system: particleSystemRain

        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: 0

        lifeSpan: 4000
        lifeSpanVariation: 200
        emitRate: 20
    }
    Gravity {
        system: particleSystemRain
        angle: 90
        magnitude: 1000
    }

    ParticleSystem {
        id: particleSystemSnow
        running: AnimationWeather.SNOW_D === animationWeather.type ||
                 AnimationWeather.SNOW_N === animationWeather.type ||
                 AnimationWeather.RAIN_SNOW_D === animationWeather.type ||
                 AnimationWeather.RAIN_SNOW_N === animationWeather.type
    }
    ImageParticle {
        system: particleSystemSnow
        source: "qrc:///particleresources/glowdot.png"
    }
    Emitter {
        system: particleSystemSnow

        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: 0

        lifeSpan: parent.height * 10
        lifeSpanVariation: 200
        emitRate: 10
    }
    Gravity {
        system: particleSystemSnow
        angle: 90
        magnitude: 100
    }

    ParticleSystem {
        id: particleSystemHaze
        running: AnimationWeather.HAZE_D === animationWeather.type ||
                 AnimationWeather.HAZE_N === animationWeather.type
    }
    ImageParticle {
        system: particleSystemHaze
        color: "#FFFF8000"
        source: "qrc:///particleresources/glowdot.png"
    }
    Emitter {
        system: particleSystemHaze

        anchors.top: parent.top
        anchors.left: parent.left
        width: 0
        height: parent.height

        size: 10
        lifeSpan: parent.width * 10   // width / speed * 1000ms
        lifeSpanVariation: 200
        emitRate: 20

        velocity: AngleDirection {
            angle: 0
            angleVariation: 15
            magnitude: 100
            magnitudeVariation: 50
        }
    }

    onTypeChanged: {
        // console.log ("onTypeChanged", type)
        if (type !== AnimationWeather.CLEAR_N)
            particleSystemStar.reset()
        if (type !== AnimationWeather.RAIN_D && type !== AnimationWeather.RAIN_N &&
                type !== AnimationWeather.RAIN_SNOW_D && type !== AnimationWeather.RAIN_SNOW_N)
            particleSystemRain.reset()
        if (type !== AnimationWeather.SNOW_D && type !== AnimationWeather.SNOW_N &&
                type !== AnimationWeather.RAIN_SNOW_D && type !== AnimationWeather.RAIN_SNOW_N)
            particleSystemSnow.reset()
        if (type !== AnimationWeather.HAZE_D && type !== AnimationWeather.HAZE_N)
            particleSystemHaze.reset()
    }
}

//    StackLayout {
//        id: layout
//        anchors.fill: parent
//        currentIndex: 2

//        Rectangle {
//            color: 'teal'
//            implicitWidth: 200
//            implicitHeight: 200
//        }

//        Canvas {
//            visible: layout.currentIndex == 1
//            property int offset: 0
//            anchors.fill: parent
//            id: ccccc

//            SequentialAnimation on offset {
//                running: ccccc.visible
//                loops: Animation.Infinite
//                NumberAnimation { from: -10; to: 10; duration: 3000 }
//                NumberAnimation { from: 10; to: -10; duration: 3000 }
//            }

//            onOffsetChanged: ccccc.requestPaint()

//            onPaint: {
//                var ctx = getContext("2d");
//                //ctx.strokeStyle = "#4495a2ab"

//                //ctx.fillStyle = "#4495a2ab"
//                //

//                var gradient = ctx.createLinearGradient(0, 0, 0, height)
//                gradient.addColorStop(0, "#ff688597")
//                gradient.addColorStop(1, "#ff44515b")
//                ctx.fillStyle = gradient
//                ctx.fillRect(0, 0, width, height);

//                ctx.fillStyle = "#4495a2ab"
//                ctx.strokeStyle = "#00000000"
//                ctx.beginPath()
//                ctx.arc(0-offset, 0-offset, Math.sqrt(width*width+height*height)/2, 0, 360);
//                ctx.closePath();
//                ctx.fill()

//                ctx.beginPath()
//                ctx.arc(width+offset, height+offset, Math.sqrt(width*width+height*height)/2, 0, 360);
//                ctx.closePath();
//                ctx.fill()

//                ctx.stroke();
//            }
//        }

//        DailyWeather {
//            anchors.fill: parent
//            anchors.margins: 5
//            property int offset: 0
//            id: ccccc1

//            SequentialAnimation on offset {
//                running: ccccc1.visible
//                loops: Animation.Infinite
//                NumberAnimation { from: -10; to: 10; duration: 3000 }
//                NumberAnimation { from: 10; to: -10; duration: 3000 }
//            }

//            onOffsetChanged: ccccc1.update()
//        }
//    }

//    ParticleSystem {
//        id: particleSystem
//    }

    /*Emitter {
        id: emitter
        system: particleSystem

        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: 0

        lifeSpan: 4000
        lifeSpanVariation: 200
        emitRate: 20
    }

    Gravity {enabled: false
        system: particleSystem
        angle: 90
        magnitude: 100
    }*/

    /*Emitter {
        id: emitter
        system: particleSystem

        anchors.top: parent.top
        anchors.left: parent.left
        width: 0
        height: parent.height

        lifeSpan: 4000
        lifeSpanVariation: 200
        emitRate: 20

        velocity: AngleDirection {
            angle: 0
            // angleVariation: 15
            magnitude: 100
            magnitudeVariation: 50
        }
    }

    Wander {
        system: particleSystem
        anchors.fill: parent
        affectedParameter: Wander.Velocity
        pace: 200
        yVariance: 2000
        Rectangle {
            anchors.fill: parent
            color: 'transparent'
            border.color: 'green'
            border.width: 2
            opacity: 0.8
        }
    }*/

//    ImageParticle {
//        system: particleSystem
//        source: "qrc:///particleresources/glowdot.png"
//    }
