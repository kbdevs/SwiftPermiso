# SwiftPermiso

Reusable macOS permission helper inspired by [`zats/permiso`](https://github.com/zats/permiso).

`SwiftPermiso` opens the correct System Settings privacy pane and floats a non-activating helper overlay that lets users drag your app into the permission list.

## Usage

```swift
import SwiftPermiso

@MainActor
func showAccessibilityHelper() {
    SwiftPermisoAssistant.shared.present(panel: .accessibility)
}
```

Supported panels:

- `.accessibility`
- `.inputMonitoring`
- `.screenRecording`

## Permission Checks

```swift
let trusted = SwiftPermisoPermissions.isAccessibilityTrusted(prompt: true)
SwiftPermisoAssistant.shared.presentMissingPanels([.accessibility, .inputMonitoring])
```
