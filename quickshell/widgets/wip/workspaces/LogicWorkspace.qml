pragma Singleton

import Quickshell.Hyprland 
import QtQuick
import Quickshell


Singleton {
  id: root
  property var workspaces: model.values[Hyprland.workspaces]
}
