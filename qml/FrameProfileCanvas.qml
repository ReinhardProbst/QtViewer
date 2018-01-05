import QtQuick 2.9
import QtQuick.Controls 2.2

Frame {
    id: frameCanvas
    background: Rectangle {
        color: design.windowBgnd
    }
    Canvas {
        objectName: "frameProfileCanvas"
        id: profileCanvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject
        renderStrategy: Canvas.Threaded
        contextType: "2d"

        property var ctx: context
        property color strokeColor: "#014D7B"
        property color strokeGridColor: "black"
        property color fillStyle: "#BEEDF5"
        property var y_pts: []
        property var x_pts: [0.1*width, 0.15*width, 0.9*width, 0.15*width]

        function draw_pts() {
            ctx.clearRect(0, 0, width, height)
            ctx.lineWidth = 1
            ctx.strokeStyle = strokeColor
            ctx.fillStyle = fillStyle
            ctx.beginPath()
            ctx.moveTo(x_pts[0], y_pts[0]*height-10)
            for (var i = 1; i < x_pts.length; i++) {
                ctx.lineTo(x_pts[i], y_pts[i]*height-10)
                ctx.lineTo(x_pts[i], y_pts[i]*height-10)
                ctx.lineTo(x_pts[i], y_pts[i]*height-10)
            }
            ctx.closePath()
            ctx.fill()
            ctx.stroke()
        }

        function draw_grid() {
            var xmax = 0.95*width
            var xmin = 0.05*width
            var ymax = 0.51*height-10
            var ymin = 0.28*height-10

            var xstep = (xmax - xmin) / 10
            var ystep = (ymax - ymin) / 5

            ctx.beginPath()
            for (var i = 0; i <= 10; ++i) {
                ctx.moveTo(xmin + i * xstep, ymin)
                ctx.lineTo(xmin + i * xstep, ymax)
            }
            for (var i = 0; i <= 5; ++i) {
                ctx.moveTo(xmin, ymin + i * ystep)
                ctx.lineTo(xmax, ymin + i * ystep)
            }
            ctx.closePath()
            ctx.strokeStyle = strokeGridColor
            ctx.stroke()
        }

        onPaint: {
            draw_pts()
            draw_grid()
        }

        MouseArea {
            anchors.fill: profileCanvas //parent
            acceptedButtons: Qt.AllButtons
            property real factor: 1.10
            property int max_cnt: 9
            property real scaling: 1.0
            property int cnt: 0
            onWheel: {
                console.info("CanvasWheely: ", wheel.angleDelta.x, wheel.angleDelta.y, wheel.x, wheel.y)
                if (wheel.angleDelta.y < 0) {
                    profileCanvas.fillStyle = "#BEEDF5"
                    if(cnt > 0) {
                        --cnt
                        scaling = 1.0/factor
                        profileCanvas.ctx.transform(scaling, 0, 0, scaling, wheel.x*(1-scaling), wheel.y*(1-scaling))
                    }
                }
                else {
                    profileCanvas.fillStyle = "green"
                    if(cnt < max_cnt) {
                        ++cnt
                        scaling = factor
                        profileCanvas.ctx.transform(scaling, 0, 0, scaling, wheel.x*(1-scaling), wheel.y*(1-scaling))
                    }
                }
                console.info("Cnt: ", cnt, "Scaling: ", scaling)
                console.info("CanvasSize: ", profileCanvas.canvasSize.width, profileCanvas.canvasSize.height)
            }
            onPressed: {
                /**************************************************************************/
                // Works because of
                // /home/rp/.config/QtProject/qtlogging.ini with content
                // [Rules]
                // *.debug=true
                // qt.*.debug=false
                console.log("CanvasMouse: ", mouse.button, mouse.x, mouse.y)
                /**************************************************************************/
                profileCanvas.fillStyle = "#BEEDF5"
                cnt = 0
                profileCanvas.ctx.resetTransform()
            }
        }
    }
}
