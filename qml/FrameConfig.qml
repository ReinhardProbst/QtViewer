import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import FileNameCtrl 1.0

Frame {
    background: Rectangle {
        color: design.windowBgnd
    }
    GridLayout {
        id: frameGrid
        columns: 3
        columnSpacing: 15
        rowSpacing: 15
        flow: GridLayout.TopToBottom

        function openFileDialog(load, id)
        {
            console.info("openFileDialog");
            id.selectExisting = load;
            id.open();
        }

        Button {
            id: buttonNominalLoad
            Layout.row: 0
            Layout.column: 0
            contentItem: Text {
                text: "Load nominal .."
                font: design.textStyle
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            background: Rectangle {
                implicitWidth: 170
                implicitHeight: 50
                color: design.buttonBgnd
            }
            onClicked: frameGrid.openFileDialog(true, fileNominal)
        }
        Button {
            id: buttonNominalSave
            Layout.row: 0
            Layout.column: 1
            contentItem: Text {
                text: "Save nominal .."
                font: design.textStyle
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            background: Rectangle {
                implicitWidth: 170
                implicitHeight: 50
                color: design.buttonBgnd
            }
            onClicked: frameGrid.openFileDialog(false, fileNominal)
        }
        Button {
            id: buttonTrend
            Layout.row: 1
            Layout.column: 0
            contentItem: Text {
                text: "Load trend .."
                font: design.textStyle
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            background: Rectangle {
                implicitWidth: 170
                implicitHeight: 50
                color: design.buttonBgnd
            }
            onClicked: frameGrid.openFileDialog(true, fileTrend)
        }
    }

    FileDialog {
        id: fileNominal
        title: "Choose a nominal file"
        nameFilters: ["Nominal files (*.json)", "nominal.json"]
        //folder: "file:/opt/nominal.json"
        //selectExisting: true
        //selectFolder: false
        //selectMultiple: false
        onAccepted: {
            console.info("You choose nominal file: " + fileNominal.fileUrl)

            if(fileNominal.selectExisting) {
                fileNameControl.nominalLoad = fileNominal.fileUrl
            }
            else {
                fileNameControl.nominalSave(fileNominal.fileUrl)
            }
        }
        onRejected: {
            console.info("Choosing nominal file canceled")

            if(fileNominal.selectExisting) {
                fileNameControl.nominalLoad = "NONE"
            }
            else {
                fileNameControl.nominalSave("NONE")
            }
        }
    }

    FileDialog {
        id: fileTrend
        title: "Choose a trend file"
        nameFilters: ["Trend files (*.json)", "trend.json"]
        signal trendName(string msg)
        //folder: "."
        //selectExisting: true
        //selectFolder: false
        //selectMultiple: false
        onAccepted: {
            console.info("You chose trend file: " + fileTrend.fileUrl)
            fileTrend.trendName(fileTrend.fileUrl)
        }
        onRejected: {
            console.info("Choosing trend file canceled")
            fileTrend.trendName("NONE")
        }
        Component.onCompleted: {
            fileTrend.trendName.connect(fileNameControl.trendLoad)
        }
    }
}
