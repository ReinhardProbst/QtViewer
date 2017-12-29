import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

Frame {
    background: Rectangle {
        color: design.lightGrey
    }
    GridLayout {
        id: frameGrid
        columns: 3
        columnSpacing: 15
        rowSpacing: 15
        flow: GridLayout.TopToBottom

        function openFileDialog(exist, id)
        {
            console.info("openFileDialog");
            id.selectExisting = exist;
            id.open();
        }

        Button {
            id: buttonNominalLoad
            Layout.row: 0
            Layout.column: 0
            Label {
                id: labelNominalLoad
                text: "Load nominal .."
                font.pointSize: 14
                font.bold: true
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
            }
            implicitWidth: labelNominalLoad.implicitWidth+15
            onClicked: frameGrid.openFileDialog(true, fileNominal)
        }
        Button {
            id: buttonNominalSave
            Layout.row: 0
            Layout.column: 1
            Label {
                id: labelNominalSave
                text: "Save nominal .."
                font.pointSize: 14
                font.bold: true
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
            }
            implicitWidth: labelNominalLoad.implicitWidth+15
            onClicked: frameGrid.openFileDialog(false, fileNominal)
        }
        Button {
            id: buttonTrend
            Layout.row: 1
            Layout.column: 0
            Label {
                id: labelTrend
                text: "Load trend .."
                font.pointSize: 14
                font.bold: true
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
            }
            implicitWidth: labelNominalLoad.implicitWidth+15
            onClicked: frameGrid.openFileDialog(true, fileTrend)
        }
    }

    FileDialog {
        objectName: "fileNominal"
        id: fileNominal
        title: "Choose a nominal file"
        nameFilters: ["Nominal files (*.json)", "nominal.json"]
        signal nominalName(string msg)
        //folder: "file:/opt/nominal.json"
        //selectExisting: true
        //selectFolder: false
        //selectMultiple: false
        onAccepted: {
            console.info("You chose: " + fileNominal.fileUrls)
            fileNominal.nominalName(fileNominal.fileUrls)
        }
        onRejected: {
            console.info("Canceled")
            fileNominal.nominalName("NONE")
        }
    }
    FileDialog {
        objectName: "fileTrend"
        id: fileTrend
        title: "Choose a trend file"
        nameFilters: ["Trend files (*.json)", "trend.json"]
        signal trendName(string msg)
        //folder: "."
        //selectExisting: true
        //selectFolder: false
        //selectMultiple: false
        onAccepted: {
            console.info("You chose: " + fileTrend.fileUrls)
            fileTrend.trendName(fileTrend.fileUrls)
        }
        onRejected: {
            console.info("Canceled")
            fileTrend.trendName("NONE")
        }
    }
}
