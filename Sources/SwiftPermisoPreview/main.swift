import AppKit
import SwiftPermiso

@MainActor
final class PreviewDelegate: NSObject, NSApplicationDelegate {
    private static let demoBundleURL = URL(fileURLWithPath: "/Applications/FakePaste.app")
    private static let demoDisplayName = "FakePaste"

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        let icon = NSWorkspace.shared.icon(forFile: Self.demoBundleURL.path)
        icon.size = NSSize(width: 48, height: 48)
        let hostApp = SwiftPermisoHostApp(
            displayName: Self.demoDisplayName,
            bundleURL: Self.demoBundleURL,
            icon: icon
        )
        SwiftPermisoAssistant.shared.present(panel: .accessibility, hostApp: hostApp)
    }

    func applicationWillTerminate(_ notification: Notification) {
        SwiftPermisoAssistant.shared.dismiss()
    }
}

@main
struct SwiftPermisoPreviewApp {
    @MainActor
    static func main() {
        let app = NSApplication.shared
        let delegate = PreviewDelegate()
        app.delegate = delegate
        app.run()
    }
}
