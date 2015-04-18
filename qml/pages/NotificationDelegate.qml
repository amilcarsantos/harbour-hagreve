import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
           id: background
           property string identifier: '' //NotificationsHelper.getObject(model.contentItem.data)
           height: Math.max(message.height + itemFooter.height, avatar.height) + Theme.paddingLarge
           enabled: identifier.length > 0

           Rectangle {
                   anchors.fill: parent
                   anchors.bottomMargin: Theme.paddingSmall
                   color: Theme.rgba(Theme.highlightBackgroundColor, 0.2)
               }

           GlassItem {
               id: glass
               anchors.verticalCenter: avatar.verticalCenter
               anchors.horizontalCenter: parent.left
               visible: false //model.contentItem.unread !== 0
           }

           FacebookPicture {
               id: avatar
               anchors.top: parent.top; anchors.topMargin: Theme.paddingLarge / 2
               anchors.left: glass.right
               identifier: 'xx' //model.contentItem.from.objectIdentifier
               pictureWidth: Theme.iconSizeMedium
               pictureHeight: Theme.iconSizeMedium
           }

           Label {
               id: message
               anchors.left: avatar.right; anchors.leftMargin: Theme.paddingMedium
               anchors.top: parent.top; anchors.topMargin: Theme.paddingLarge / 2
               anchors.right: parent.right; anchors.rightMargin: Theme.paddingLarge
               text: 'Title ' + index //model.contentItem.title
               font.pixelSize: Theme.fontSizeSmall
               horizontalAlignment: Text.AlignLeft
               wrapMode: Text.Wrap
           }

           Label {
               id: itemFooter
               anchors.left: avatar.right; anchors.leftMargin: Theme.paddingMedium
               anchors.top: message.bottom
               anchors.right: parent.right;anchors.rightMargin: Theme.paddingLarge
               opacity: 0.6
               width: parent.width
               font.pixelSize: Theme.fontSizeExtraSmall
               text: Format.formatDate(new Date(),//DateHelper.fromString(model.contentItem.createdTime),
                                       Formatter.DurationElapsed)
           }

           onClicked: {
               model.contentItem.markAsRead()
               var page = pageStack.push(Qt.resolvedUrl("TypeSolverPage.qml"),
                                         {"identifier": background.identifier})
               page.load()
           }
       }
