import QtQuick 2.7
import QtQuick.Layouts 1.3

import Clipboard 1.0
import Common 1.0
import Linphone 1.0

import Common.Styles 1.0
import Linphone.Styles 1.0
import TextToSpeech 1.0
import Utils 1.0
import Units 1.0
import UtilsCpp 1.0
import LinphoneEnums 1.0

import 'Message.js' as Logic

// =============================================================================

Item {
	id: container
	
	// ---------------------------------------------------------------------------
	
	property alias backgroundColor: rectangle.color
	property alias color: message.color
	property alias pointSize: message.font.pointSize
	
	default property alias _content: content.data
	
	// ---------------------------------------------------------------------------
	
	implicitHeight: message.contentHeight 
						+ (ephemeralTimerRow.visible? message.padding * 4 : message.padding * 2) 
						+ (deliveryLayout.visible? deliveryLayout.height : 0)
	
	Rectangle {
		id: rectangle
		
		height: parent.height - (deliveryLayout.visible? deliveryLayout.height : 0)
		radius: ChatStyle.entry.message.radius
		width: (
				   message.contentWidth < ephemeralTimerRow.width
				   ? ephemeralTimerRow.width
				   : message.contentWidth < parent.width
					 ? message.contentWidth
					 : parent.width
				   ) + message.padding * 2
		Row{
			id:ephemeralTimerRow
			anchors.right:parent.right
			anchors.bottom:parent.bottom	
			anchors.bottomMargin: 5
			anchors.rightMargin : 5
			visible:$chatEntry.isEphemeral
			spacing:5
			Text{
				visible : $chatEntry.ephemeralExpireTime > 0
				text: Utils.formatElapsedTime($chatEntry.ephemeralExpireTime)
				color:"#FF5E00"
				font.pointSize: Units.dp * 8
				Timer{
					running:parent.visible
					interval: 1000
					repeat:true
					onTriggered: parent.text = Utils.formatElapsedTime($chatEntry.getEphemeralExpireTime())// Use the function
				}
			}
			Icon{
				icon:'timer'
				iconSize: 15
			}
		}
	}
	
	// ---------------------------------------------------------------------------
	// Message.
	// ---------------------------------------------------------------------------
	
	TextEdit {
		id: message
		property string lastTextSelected : ''
		
		anchors {
			left: container.left
			right: container.right
		}
		
		clip: true
		padding: ChatStyle.entry.message.padding
		readOnly: true
		selectByMouse: true
		text: Utils.encodeTextToQmlRichFormat($chatEntry.content, {
												  imagesHeight: ChatStyle.entry.message.images.height,
												  imagesWidth: ChatStyle.entry.message.images.width
											  })
		
		// See http://doc.qt.io/qt-5/qml-qtquick-text.html#textFormat-prop
		// and http://doc.qt.io/qt-5/richtext-html-subset.html
		textFormat: Text.RichText // To supports links and imgs.
		wrapMode: TextEdit.Wrap
		
		onCursorRectangleChanged: Logic.ensureVisible(cursorRectangle)
		onLinkActivated: Qt.openUrlExternally(link)
		onSelectedTextChanged:if(selectedText != '') lastTextSelected = selectedText
		onActiveFocusChanged: {
			if(activeFocus)
				lastTextSelected = ''
			deselect()
		}
		
		ChatMenu{
			height: parent.height
			width: rectangle.width
			
			lastTextSelected: message.lastTextSelected 
			content: $chatEntry.content
			deliveryCount: deliveryLayout.model.count
			onDeliveryStatusClecked: deliveryLayout.visible = !deliveryLayout.visible
		}
	}
	
	// ---------------------------------------------------------------------------
	// Extra content.
	// ---------------------------------------------------------------------------
	
	Item {
		id: content
		
		anchors {
			left: rectangle.right
			leftMargin: ChatStyle.entry.message.extraContent.leftMargin
		}
	}
	ChatDeliveries{
		id: deliveryLayout
		anchors.top:rectangle.bottom
		anchors.left:parent.left
		anchors.right:parent.right
		anchors.rightMargin: 50
		
		chatMessageModel: $chatEntry
	}
}
