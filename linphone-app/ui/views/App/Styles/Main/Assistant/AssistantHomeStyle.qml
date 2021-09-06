pragma Singleton
import QtQml 2.2

import Units 1.0
import ColorsList 1.0

// =============================================================================

QtObject {
  property QtObject info: QtObject {
    property int height: 245
    property int iconSize: 150

    property QtObject description: QtObject {
      property color color: ColorsList.add("Assistant_home_description", "g").color
      property int pointSize: Units.dp * 10
      property int height: 40
    }

    property QtObject title: QtObject {
      property color color: ColorsList.add("Assistant_home_title", "g").color
      property int pointSize: Units.dp * 11
      property int height: 40
    }
  }

  property QtObject buttons: QtObject {
    property int height: 90
    property int maxWidth: 690
    property int spacing: 5
  }
}
