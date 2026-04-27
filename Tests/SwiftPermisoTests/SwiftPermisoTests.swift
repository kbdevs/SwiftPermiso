import SwiftPermiso
import XCTest

final class SwiftPermisoTests: XCTestCase {
    func testPanelTitles() {
        XCTAssertEqual(SwiftPermisoPanel.accessibility.title, "Accessibility")
        XCTAssertEqual(SwiftPermisoPanel.inputMonitoring.title, "Input Monitoring")
        XCTAssertEqual(SwiftPermisoPanel.screenRecording.title, "Screen Recording")
    }

    func testPanelURLsUseSystemSettingsPrivacyExtension() {
        XCTAssertTrue(SwiftPermisoPanel.accessibility.settingsURL.absoluteString.contains("Privacy_Accessibility"))
        XCTAssertTrue(SwiftPermisoPanel.inputMonitoring.settingsURL.absoluteString.contains("Privacy_ListenEvent"))
        XCTAssertTrue(SwiftPermisoPanel.screenRecording.settingsURL.absoluteString.contains("Privacy_ScreenCapture"))
    }
}
