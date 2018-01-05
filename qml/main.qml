import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    objectName: "mainWindow"
    id: mainWindow
    visible: true
    width: design.windowHeight
    height: design.windowWidth
    title: qsTr("Profilometer")

    Design{ id: design }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBarH.currentIndex

        FrameConfig {
            Label {
                objectName: "frameConfig"
                text: qsTr("Configuration")
                color: design.trafficBlue
                anchors.centerIn: parent
            }
        }
        FrameProfileCanvas {
            Label {
                text: qsTr("Profile with canvas")
                color: design.trafficBlue
                anchors.centerIn: parent
            }
        }
        FrameProfileQPI {
            Label {
                text: qsTr("Nominal and profile with painter")
                color: design.trafficBlue
                anchors.centerIn: parent
            }
        }
    }

    header: TabBar {
        id: tabBarH
        currentIndex: swipeView.currentIndex
        background: Rectangle {
                color: design.tabBgnd
        }
        TabButton {
            id: tabButton0
//            contentItem: Text {
//                text: qsTr("Configuration")
//                color: design.red
//                horizontalAlignment: Text.AlignHCenter
//                verticalAlignment: Text.AlignVCenter
//                elide: Text.ElideRight
//            }
            contentItem: Image {
                fillMode: Image.PreserveAspectFit
                source: "../images/Histogram.png"
            }
            background: Rectangle {
                 color: tabBarH.currentIndex == 0 ? design.tabBgndActive : design.tabBgnd
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
                color: tabBarH.currentIndex == 1 ? design.tabBgndActive : design.tabBgnd
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
                color: tabBarH.currentIndex == 2 ? design.tabBgndActive : design.tabBgnd
            }
        }
    }

    footer: Label {
        text: qsTr("Version 0.0.4")
    }
}
