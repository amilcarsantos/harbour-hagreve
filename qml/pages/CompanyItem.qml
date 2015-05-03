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
	id:root
	height: Theme.itemSizeLarge
	width: Theme.itemSizeExtraLarge

	property alias name: _name.text
	property bool fade

	Rectangle {
//        anchors.fill: parent
		radius: 4
		clip: true

		anchors.centerIn: parent
		width: parent.height
		height: parent.width
		rotation: 90
		gradient: Gradient {
			GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightBackgroundColor, 0.1) }
			GradientStop { position: 0.9; color: "transparent" }
		}

		Image {
			anchors {
				bottom: parent.bottom
				right: parent.right
			}

			width: Math.min(parent.width, sourceSize.width)
			height: Math.min(parent.height, sourceSize.height)

			opacity: 0.30
		source: "image://theme/graphic-gradient-corner?" + Theme.highlightBackgroundColor
		}
	}

	Label {
		id:_name
		anchors.fill: parent
		wrapMode: Text.Wrap
		font.bold: true
		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter
		font.pixelSize: Theme.fontSizeMedium
		opacity: fade ? 0.7 : 1
	}


	Component.onCompleted: {
		//print(_name.paintedHeight + " - " + _name.paintedWidth)
		if (_name.paintedHeight > root.height || _name.paintedWidth > root.width) {
			//print("small " + name)
			_name.font.pixelSize = Theme.fontSizeExtraSmall
		} else {
			_name.font.pixelSize = Theme.fontSizeMedium
		}
	}
}
