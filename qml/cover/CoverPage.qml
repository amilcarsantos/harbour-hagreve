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

CoverBackground {

    Label {
		id: header
		anchors.top: parent.top
		//anchors.topMargin: Theme.paddingSmall
		anchors.right: parent.right
		anchors.rightMargin: Theme.paddingSmall
		text: qsTr("Hoje há greve?")
		color: Theme.highlightColor
    }

	Item {
		anchors.top: header.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		visible: !coverModel.count

		CoverPlaceholder {
			text: Qt.formatDate(new Date(), "d MMMM")
			icon.source: "qrc:/harbour-hagreve.png"
		}
	}

	ListModel {
		id: coverModel
	}

	Column {
		anchors.top: header.bottom
		anchors.topMargin: Theme.paddingLarge
		anchors.horizontalCenter: parent.horizontalCenter
		height: childrenRect.height
		width: childrenRect.width
		spacing: Theme.paddingMedium

		Repeater {

			model: coverModel

			Item {
				width: childrenRect.width
				height: Theme.itemSizeSmall
				Rectangle {
					id: company
					x: Theme.paddingSmall
					width: Theme.itemSizeMedium
					height: Theme.itemSizeSmall
					color: Theme.rgba(Theme.highlightBackgroundColor, 0.2)
					Label {
						anchors.centerIn: parent
						width: Math.min(parent.width - Theme.paddingSmall, paintedWidth)
						//anchors.leftMargin: Theme.paddingSmall
						text: model.company
						truncationMode: TruncationMode.Fade
						//verticalAlignment: Text.AlignVCenter
						//horizontalAlignment: Text.AlignJustify
					}
				}
				Label {
					anchors.left: company.right
					anchors.leftMargin: Theme.paddingSmall

					width: Theme.itemSizeMedium
					height: Theme.itemSizeSmall
					text: model.date
					truncationMode: TruncationMode.Fade
					verticalAlignment: Text.AlignVCenter
					horizontalAlignment: Text.AlignLeft
					font.strikeout: model.canceled
				}
			}
		}
	}

	onStatusChanged: {
		if (status === Cover.Activating) {
			coverModel.clear()
			for (var i = 0; i < Math.min(strikeModel.count, 3); i++) {
				coverModel.append({
					'company' : strikeModel.get(i).company,
					'date': Qt.formatDate(strikeModel.get(i).dateTime, "d MMM"),
					'canceled': strikeModel.get(i).canceled,
				});
			}
		}
	}
}


