import AppKit
import Foundation

public enum SwiftPermisoPanel: String, CaseIterable, Sendable {
    case accessibility = "Privacy_Accessibility"
    case inputMonitoring = "Privacy_ListenEvent"
    case screenRecording = "Privacy_ScreenCapture"

    public var title: String {
        switch self {
        case .accessibility:
            "Accessibility"
        case .inputMonitoring:
            "Input Monitoring"
        case .screenRecording:
            "Screen Recording"
        }
    }

    public var settingsURL: URL {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension?\(rawValue)") else {
            preconditionFailure("Invalid System Settings URL for \(rawValue)")
        }
        return url
    }
}
