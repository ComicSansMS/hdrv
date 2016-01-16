import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2
import Hdrv 1.0


ApplicationWindow {
  width: 1200
  height: 800
  visible: true
  color: 'black'
  title: images.current.name + ' - hdrv 0.2'

  ColumnLayout {
    anchors.fill: parent
    spacing: 0

    Rectangle {
      color: '#404040'
      Layout.preferredHeight: 24
      Layout.fillWidth: true

      RowLayout {
        anchors.fill: parent

        TabBar {
          Layout.fillWidth: true
          Layout.fillHeight: true
        }

        Button {
          id: imagePropertiesButton
          Layout.preferredWidth: 30
          Layout.preferredHeight: 20
          Layout.alignment: Qt.AlignBottom
          iconSource: 'qrc:/hdrv/media/Properties.png'
          checkable: true
          style: ButtonStyle {
            background: Item {
              Rectangle {
                anchors.fill: parent
                anchors.rightMargin: 4
                anchors.leftMargin: 4
                color: control.checked || control.hovered ? '#FAFAFA' : '#C0C0C0'
              }
            }
          }
        }

      }
    }

    Rectangle {
      Layout.preferredHeight: 4
      Layout.fillWidth: true
      color: '#FAFAFA'
    }

    RowLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      spacing: 0

      ImageArea {
        color: 'white'
        model: images
        Layout.fillHeight: true
        Layout.fillWidth: true

        DropArea {
            id: dropArea;
            anchors.fill: parent;
            onEntered: drag.accept(Qt.CopyAction);
            onDropped: {
              for (var i = 0; i < drop.urls.length; ++i) {
                if (!images.load(drop.urls[i])) {
                  errorMessageDialog.open();
                }
              }
            }
        }

        ErrorMessage { id: errorMessageDialog; show: false }
      }

      Rectangle {
        Layout.fillHeight: true
        Layout.preferredWidth: 1
        color: 'darkgrey'
      }

      ImageProperties {
        id: imageProperties
        visible: imagePropertiesButton.checked
        Layout.fillHeight: true
        Layout.preferredWidth: 240
      }
    }

    Keys.onPressed: {
      if (event.key == Qt.Key_Plus) {
        images.current.gamma += 0.2
      } else if (event.key == Qt.Key_Minus) {
        images.current.gamma -= 0.2
      } else if (event.key == Qt.Key_R) {
        images.current.position = Qt.point(0, 0)
      } else if (event.key == Qt.Key_W && event.modifiers & Qt.ControlModifier) {
        if (images.items.length > 1) images.remove(images.currentIndex);
        else Qt.quit();
      }
    }
  }
}
