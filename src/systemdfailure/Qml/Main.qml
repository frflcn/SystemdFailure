

import QtQuick
import QtQuick.Controls

import com.trevorsapps.backend




ApplicationWindow {
    
    width: label.width + 50
    height: label.height + 50
    visible: true
    title: "Systemd Failure"
    id: root
    
    // Label{
    //     anchors.verticalCenter: parent.horizontalCenter
    //     visible: true
    //     text: Backend.message
    //     anchors.horizontalCenter: parent.horizontalCenter

    // }

    TextArea{
        id: label
        text: Backend.message
        width: {
            let textWidth = Backend.message.length
            if (textWidth > Screen.width - 50) {
                return Screen.width - 50
            }
            if (textWidth < 260) {
                return 260
            }
            return Backend.message.length
        }
        anchors.top: root.contentItem.top
        anchors.topMargin: 20
        anchors.horizontalCenter: root.contentItem.horizontalCenter
        color : palette.text
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignLeft
        selectByMouse: true
        readOnly: true
        background: null
        
    }

    
}