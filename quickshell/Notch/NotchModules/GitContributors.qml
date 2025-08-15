


import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services
pragma Singleton

// GitHub API logic and caching
Singleton {
  id: root

  property string githubDataFile: Quickshell.env("NOCTALIA_GITHUB_FILE") || (Settings.cacheDir + "github.json")
  property int githubUpdateFrequency: 60 * 60 // 1 hour expressed in seconds
  property var data: adapter // Used to access via GitHub.data.xxx.yyy
  property bool isFetchingData: false

  // Public properties for easy access
  property string latestVersion: "Unknown"
  property var contributors: []

  FileView {
    objectName: "githubDataFileView"
    path: githubDataFile
    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter()
    Component.onCompleted: {
      reload()
    }
    onLoaded: {
      loadFromCache()
    }
    onLoadFailed: function (error) {
      if (error.toString().includes("No such file") || error === 2) {
        // Fetch data after a short delay to ensure file is created
        Qt.callLater(() => {
                       fetchFromGitHub()
                     })
      }
    }

    JsonAdapter {
      id: adapter

      property string version: "Unknown"
      property var contributors: []
      property double timestamp: 0
    }
  }

  // --------------------------------
  function loadFromCache() {
    const now = Time.timestamp
    if (!data.timestamp || (now >= data.timestamp + githubUpdateFrequency)) {
      console.log("[GitHub] Cache expired or missing, fetching new data from GitHub...")
      fetchFromGitHub()
      return
    }
    console.log("[GitHub] Loading cached GitHub data (age:", Math.round((now - data.timestamp) / 60), "minutes)")

    if (data.version) {
      root.latestVersion = data.version
    }
    if (data.contributors) {
      root.contributors = data.contributors
    }
  }

  // --------------------------------
  function fetchFromGitHub() {
    if (isFetchingData) {
      console.warn("[GitHub] GitHub data is still fetching")
      return
    }

    isFetchingData = true
    versionProcess.running = true
    contributorsProcess.running = true
  }

  // --------------------------------
  function saveData() {
    data.timestamp = Time.timestamp
    Qt.callLater(() => {
                   // Access the FileView's writeAdapter method
                   var fileView = root.children.find(child => child.objectName === "githubDataFileView")
                   if (fileView) {
                     fileView.writeAdapter()
                   }
                 })
  }

  // --------------------------------
  function resetCache() {
    data.version = "Unknown"
    data.contributors = []
    data.timestamp = 0

    // Try to fetch immediately
    fetchFromGitHub()
  }

  Process {
    id: versionProcess

    command: ["curl", "-s", "https://api.github.com/repos/Ly-sec/Noctalia/releases/latest"]

    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const response = text
          if (response && response.trim()) {
            const data = JSON.parse(response)
            if (data.tag_name) {
              const version = data.tag_name
              root.data.version = version
              root.latestVersion = version
              console.log("[GitHub] Latest version fetched from GitHub:", version)
            } else {
              console.log("[GitHub] No tag_name in GitHub response")
            }
          } else {
            console.log("[GitHub] Empty response from GitHub API")
          }
        } catch (e) {
          console.error("[GitHub] Failed to parse version:", e)
        }

        // Check if both processes are done
        checkAndSaveData()
      }
    }
  }

  Process {
    id: contributorsProcess

    command: ["curl", "-s", "https://api.github.com/repos/Ly-sec/Noctalia/contributors?per_page=100"]

    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const response = text
          if (response && response.trim()) {
            const data = JSON.parse(response)
            root.data.contributors = data || []
            root.contributors = root.data.contributors
            console.log("[GitHub] Contributors fetched from GitHub:", root.contributors.length)
          } else {
            console.log("[GitHub] Empty response from GitHub API for contributors")
            root.data.contributors = []
            root.contributors = []
          }
        } catch (e) {
          console.error("[GitHub] Failed to parse contributors:", e)
          root.data.contributors = []
          root.contributors = []
        }

        // Check if both processes are done
        checkAndSaveData()
      }
    }
  }

  // --------------------------------
  function checkAndSaveData() {
    // Only save when both processes are finished
    if (!versionProcess.running && !contributorsProcess.running) {
      root.isFetchingData = false
      root.saveData()
    }
  }
}

