pragma Singleton
import QtQml 2.2

import ColorsList 1.0

// =============================================================================

QtObject {
  property color color: ColorsList.add("Norification", "k").color
  property int height: 120
  property int iconSize: 40
  property int width: 300

  property QtObject border: QtObject {
    property color color: ColorsList.add("Norification_border", "n").color
    property int width: 1
  }
}
