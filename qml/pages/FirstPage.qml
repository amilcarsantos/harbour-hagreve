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
import "Constants.js" as Const

Page {
    id: page

	property bool _error: false
	property bool _loading: false

	MessagePopup {
		id: reloadFailPopup
		text: qsTr("Erro ao actualizar.\nTenta novamente mais tarde.")
	}

    SilicaListView {
        id: listView

		PullDownMenu {
            MenuItem {
				text: qsTr("Sobre")
				onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
			MenuItem {
				text: qsTr("Actualizar")
				enabled: page.state == 'loaded'
				onClicked: {
					page.state = 'reload'
					loadStrikes()
				}
			}
		}

        model: strikeModel
        anchors.fill: parent
        header: Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Hoje há greve?")
				description: Qt.formatDate(new Date(), "d MMMM")
            }
        }

		delegate: StrikeDelegate { }

        section {
            property: 'section'

            delegate: SectionHeader {
                text: section
                height: Theme.itemSizeExtraSmall
            }
        }

		ViewPlaceholder {
			enabled: strikeModel.count == 0 && page.state == 'loaded'
			text: qsTr('Não há greves')
		}

		footer: Item {
			width: parent.width
			height: Theme.paddingLarge
		}

        VerticalScrollDecorator {}
	}

	MouseArea {
		anchors.fill: parent
		visible: _loading
		Rectangle {
			anchors.fill: parent
			color: Theme.highlightDimmerColor
			opacity: 0.5
		}

		BusyIndicator {
			id: busyIndicator
			anchors.centerIn: parent
			running: _loading

			size: BusyIndicatorSize.Large
		}
	}

	Column {
		anchors.centerIn: parent
		width: parent.width
		visible: _error && page.state == 'init'
		spacing: Theme.paddingLarge

		Text {
			width: parent.width
			horizontalAlignment: Text.AlignHCenter
			wrapMode: Text.Wrap
			font {
				pixelSize: Theme.fontSizeExtraLarge
				family: Theme.fontFamilyHeading
			}
			color: Theme.highlightColor
			opacity: 0.6
			text: qsTr("Erro na ligação. Tenta novamente mais tarde.")
		}

		Button {
			id: onerror
			anchors.horizontalCenter: parent.horizontalCenter
			visible: _error
			text: qsTr("Tentar novamente")
			onReleased: {
				_error = false
				loadStrikes();
			}
		}
	}

	states: [
		State {
			name: 'init'
		},
		State {
			name: 'loaded'
		},
		State {
			name: 'reload'
		}
	]

	Component.onCompleted: {
		page.state = 'init'
		loadStrikes()
	}

	function loadStrikes() {
		_error = false
		_loading = true

		var xhr = new XMLHttpRequest();
		xhr.onreadystatechange = function() {

			//print("xhr.readyState: " + xhr.readyState + " -> "+ xhr.DONE)

			if (xhr.readyState == xhr.DONE) {
				_loading = false;
				if (xhr.status === Const.HTTP_OK) {
					var jsonData = xhr.responseText;

					//print(jsonData);
					fillStrikeModel(JSON.parse(jsonData));
					page.state = 'loaded'
				} else {
					_error = true
					if (page.state === 'reload') {
						reloadFailPopup.showMessage()
						page.state = 'loaded'
					}
				}
			} else if (xhr.readyState == xhr.OPENED) {
				xhrTimeout.start()
			}
		}
		xhrTimeout._xhr = xhr
		xhr.open("GET", "http://hagreve.com/api/v1/strikes", true);
		xhr.send();
	}

	Timer {
		property var _xhr
		id: xhrTimeout
		repeat: false
		interval: 15000	// 15 sec
		onTriggered: {
			//print("abort _xhr")
			if (_xhr.readyState === XMLHttpRequest.OPENED) {
				_xhr.abort()
			}
		}
	}

	function fillStrikeModel(strikes) {
		//print(strikes)
		strikeModel.clear()

		for (var i = 0; i < strikes.length; ++i) {
			//print(strikes[i].start_date)

			var dateTime = new Date(strikes[i].start_date)
			var section = formatSectionName(dateTime)

			var durationStart = 'Todo o dia'
			var durationEnd = ''
			if (!strikes[i].all_day) {
				//var t = (new Date(strikes[i].end_date).getTime() -  dateTime.getTime()) / 1000
				//duration = Format.formatDuration( t , Formatter.TimeValueTwentyFourHours)
				durationStart = Qt.formatTime(dateTime, "hh:mm")
				durationEnd = Qt.formatTime(new Date(strikes[i].end_date), "hh:mm")
			}

			strikeModel.append({
				'dateTime': dateTime,
				'section': section,
				'company' : strikes[i].company.name,
				'description' : strikes[i].description,
				'url': strikes[i].source_link,
				'durationStart': durationStart,
				'durationEnd': durationEnd,
				'canceled': strikes[i].canceled
			})
		}
	}

	function formatSectionName(dateTime) {
		var nowDate = new Date()
		var now = nowDate.getTime()
		var section = ""

		if (dateTime.getTime() < Const.MAX_WEEK_TIME + now) {
			section = Format.formatDate(dateTime, Formatter.TimepointSectionRelative);
			if (!section) {
				return 'Hoje'
			}
		} /*else {
			section = Format.formatDate(dateTime, Formatter.DurationElapsed);
		}*/

		//print(section + "----" +dateTime );

		var dayFormat = "d"
		if (nowDate.getMonth() !== dateTime.getMonth()) {
			dayFormat = "d MMMM"
		}
		if (section) {
			section = section + ", "
		}
		section = section + Qt.formatDate(dateTime, dayFormat)
		return section
	}


	/*function loadStrikes() {
		fillStrikeModel(JSON.parse('[	{		"source_link": "http://www.cp.pt/passageiros/pt/consultar-horarios/avisos/circulacao-16-de-abril-",		"submitter": {			"first_name": "",			"last_name": ""		},		"start_date": "2015-04-15 00:26:12",		"end_date": "2015-04-15 00:26:32",		"company": {			"name": "CP",			"id": 1		},		"id": 430,		"canceled": false,		"all_day": true,		"description": "Greve. Foram decretados serviços mínimos pelo CES, disponíveis na nossa fonte."	},	{		"source_link": "http://www.publico.pt/local/noticia/greve-do-metropolitano-de-lisboa-adiada-para-dia-17-1691717",		"submitter": {			"first_name": "",			"last_name": ""		},		"start_date": "2015-04-17 23:45:18",		"end_date": "2015-04-17 23:46:21",		"company": {			"name": "Metro de Lisboa",			"id": 2		},		"id": 431,		"canceled": false,		"all_day": true,		"description": "Greve de 24h."}, {		"description": "Greve de 24h.",	"submitter": {			"last_name": "",			"first_name": ""		},		"end_date": "2015-05-01 09:18:44",		"all_day": false,		"company": {			"name": "Carris",			"id": 10		},		"id": 427,		"canceled": true,		"source_link": "http://www.jornaldenegocios.pt/empresas/detalhe/greve_na_carris_a_10_de_abril.html",		"start_date": "2015-05-01 17:18:40"	}]'));
	}*/
}


