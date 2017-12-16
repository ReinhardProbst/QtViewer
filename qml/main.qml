import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    readonly property color grey: "#b2b1b1"
    readonly property color lightGrey: "#f0f0f0"
    readonly property color darkGrey: "#808080"
    readonly property color white: "#ffffff"
    readonly property color blue: "#0000ff"
    readonly property color red: "#ff0000"

    objectName: "mainWindow"
    id: mainWindow
    visible: true
    width: 800
    height: 600
    title: qsTr("Profilometer")

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBarH.currentIndex

        FrameConfig {
            Label {
                objectName: "frameConfig"
                text: qsTr("Configuration")
                color: "blue"
                anchors.centerIn: parent
            }
        }
        FrameProfileCanvas {
            Label {
                text: qsTr("Profile with canvas")
                color: "blue"
                anchors.centerIn: parent
            }
        }
        FrameProfileQPI {
            Label {
                text: qsTr("Nominal and profile with painter")
                color: "blue"
                anchors.centerIn: parent
            }
        }
    }

    header: TabBar {
        id: tabBarH
        currentIndex: swipeView.currentIndex
        background: Rectangle {
                color: grey
        }
        height: Math.max(tabButton0.height, tabButton1.height, tabButton2.height)
        TabButton {
            id: tabButton0
//            contentItem: Text {
//                text: qsTr("Configuration")
//                color: "red"
//                horizontalAlignment: Text.AlignHCenter
//                verticalAlignment: Text.AlignVCenter
//                elide: Text.ElideRight
//            }
            contentItem: Image {
                fillMode: Image.PreserveAspectFit
                source: "../images/Histogram.png"
            }
            background: Rectangle {
                 color: tabBarH.currentIndex == 0 ? grey : darkGrey
            }
        }
        TabButton {
            id: tabButton1
            text: qsTr("Profile")
            contentItem: Image {
                fillMode: Image.PreserveAspectFit
                source: "../images/Trigger.png"
            }
            background: Rectangle {
                color: tabBarH.currentIndex == 1 ? grey : darkGrey
            }
        }
        TabButton {
            id: tabButton2
            text: qsTr("Nominal and profile")
            contentItem: Image {
                fillMode: Image.PreserveAspectFit
                source: "../images/Refresh.png"
            }
            background: Rectangle {
                color: tabBarH.currentIndex == 2 ? grey : darkGrey
            }
        }
    }

    footer: Label {
        text: qsTr("Version 0.0.3")
    }
}
