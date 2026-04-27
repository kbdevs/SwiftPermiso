import ApplicationServices
import Foundation

public enum SwiftPermisoPermissions {
    public static func isAccessibilityTrusted(prompt: Bool = false) -> Bool {
        let options: CFDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: prompt] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }
}
