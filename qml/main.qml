import QtQuick 2.9
import Lomiri.Components 2.0
import QtWebEngine 1.9

MainView {
    id: mainView
    objectName: "mainView"
    applicationName: "touchpiano.pparent"
    backgroundColor: "transparent"
    automaticOrientation: false   

    PageStack {
        id: mainPageStack
        anchors.fill: parent

        Component.onCompleted: {
            mainPageStack.push(pageMain)
        }

        Page {
            id: pageMain
            anchors.fill: parent

            WebEngineView {
                id: webview
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                //url: "http://127.0.0.1:3000"
                url: Qt.resolvedUrl("..")+"pianco/index.html"
                focus: true
                settings.pluginsEnabled: true
                settings.localContentCanAccessFileUrls: true
                settings.localContentCanAccessRemoteUrls: true
                zoomFactor: 1.1
                onFeaturePermissionRequested: {
                    grantFeaturePermission(securityOrigin, feature, true)
                }
            }
        }
    }
}
