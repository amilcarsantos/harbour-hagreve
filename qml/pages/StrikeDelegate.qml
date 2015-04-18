/*
  Copyright (C) 2015 Amilcar Santos
  Contact: Amilcar Santos <amilcar.santos@gmail.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
	* Redistributions of source code must retain the above copyright
	  notice, this list of conditions and the following disclaimer.
	* Redistributions in binary form must reproduce the above copyright
	  notice, this list of conditions and the following disclaimer in the
	  documentation and/or other materials provided with the distribution.
	* Neither the name of the Amilcar Santos nor the
	  names of its contributors may be used to endorse or promote products
	  derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: container

    width: parent.width
    height: background.height + Theme.paddingMedium

    Rectangle {
		id: background

		anchors.left: parent.left;
		anchors.leftMargin: Theme.paddingMedium
		anchors.right: parent.right;
		anchors.rightMargin: Theme.paddingMedium
		anchors.verticalCenter: parent.verticalCenter
		height: column.height + 2 * Theme.paddingMedium
		color: Theme.rgba(Theme.highlightBackgroundColor, 0.2)
	}

    Column {
        id: column
        anchors.left: background.left;
        anchors.leftMargin: Theme.paddingMedium
        anchors.right: background.right;
        anchors.rightMargin: Theme.paddingMedium
		spacing: Theme.paddingSmall
        anchors.verticalCenter: parent.verticalCenter


        // Header
        Item {
            anchors.left: parent.left;
            anchors.right: parent.right
            height: childrenRect.height
            CompanyItem {
                id: company
                name: model.company
                fade: model.canceled
            }

            Item {
                anchors.left: company.right;
                anchors.leftMargin: Theme.paddingMedium
                anchors.right: parent.right;
                anchors.rightMargin: Theme.paddingMedium
                height: childrenRect.height

                Label {
                    id: description
                    anchors.left: parent.left;
                    anchors.right: parent.right
                    textFormat: Text.RichText
                    text: model.description
                    font.pixelSize: Theme.fontSizeSmall
                    truncationMode: TruncationMode.Fade
					wrapMode: Text.WordWrap
                    // onLinkActivated: background.solveLink(link)
                }

                Label {
                    id: durationStart
                    anchors.top: description.bottom;
                    anchors.topMargin: Theme.paddingSmall
                    anchors.left: parent.left;
                    anchors.right: parent.right
					text: model.durationStart + (model.durationEnd? "\n" + model.durationEnd : "")
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.secondaryColor
                }
//                Label {
//                    anchors.top: durationStart.bottom;
//                    anchors.topMargin: Theme.paddingSmall
//                    anchors.left: parent.left;
//                    anchors.right: parent.right
//                    text: model.durationEnd
//                    font.pixelSize: Theme.fontSizeExtraSmall
//                    color: Theme.secondaryColor
//                }
            }
        }

        // Source link
        BackgroundItem {
            id: linkItem
            anchors.left: parent.left;
            anchors.right: parent.right
            height: Theme.iconSizeMedium
            Label {
                anchors.left: parent.left;
                anchors.leftMargin: Theme.paddingSmall
                anchors.right: linkImage.left
                anchors.verticalCenter: parent.verticalCenter

                text: model.url
                wrapMode: Text.NoWrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryHighlightColor
                truncationMode: TruncationMode.Fade
            }

            Image {
                id: linkImage
                fillMode: Image.PreserveAspectCrop
                height: Theme.iconSizeMedium
                width: Theme.iconSizeMedium
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                opacity: 0.6
                source: "image://theme/icon-m-right?"
                        + (linkItem.highlighted ? Theme.highlightColor : Theme.primaryColor)
            }
			onClicked: {
				Qt.openUrlExternally(model.url)
			}
        }
    }

    Image {
        anchors.right: column.right;
        anchors.rightMargin: Theme.paddingMedium
        anchors.bottom: column.bottom;
        anchors.bottomMargin: Theme.iconSizeMedium;
        visible: model.canceled

		source: "qrc:/img/desconvocada.png"
    }
}
