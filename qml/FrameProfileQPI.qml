import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import FrameProfileQPI 1.0

Frame {
    id: frameUI
    background: Rectangle {
        color: design.lightGrey
    }
    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        FrameProfileQPI {
            objectName: "frameProfileQPI"
            id: frameProfileQPI
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: frameUI.width
            Layout.preferredHeight: frameUI.height*0.45
        }
        FrameProfileQPI {
            objectName: "frameProfileQPI2"
            id: frameProfileQPI2
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: frameUI.width
            Layout.preferredHeight: frameUI.height*0.45
        }
        Text {
            objectName: "frameProfileQPIText"
            text: "A nominal and profile"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: frameUI.width
            Layout.preferredHeight: frameUI.height*0.1
        }
        MouseArea {
            anchors.fill: parent
            onWheel: {
                console.info("WheelyQPI: ", wheel.angleDelta.y)
                if (wheel.angleDelta.y < 0) {
                    frameProfileQPI2.color = design.red
                }
                else {
                    frameProfileQPI2.color = design.green
                }
                frameProfileQPI2.update()
            }
        }
    }
}
