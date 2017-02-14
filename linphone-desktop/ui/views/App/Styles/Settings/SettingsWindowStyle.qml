pragma Singleton
import QtQuick 2.7

// =============================================================================

QtObject {
  property int height: 640
  property int width: 1024

  property QtObject forms: QtObject {
    property int spacing: 10
  }

  property QtObject validButton: QtObject {
    property int bottomMargin: 30
    property int rightMargin: 30
    property int topMargin: 30
  }
}
