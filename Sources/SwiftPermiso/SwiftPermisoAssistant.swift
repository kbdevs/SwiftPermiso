import AppKit
import Foundation

@MainActor
public final class SwiftPermisoAssistant {
    public static let shared = SwiftPermisoAssistant()

    private var overlayController: OverlayWindowController?
    private var trackingTimer: Timer?
    private var activationObserver: NSObjectProtocol?
    private var pendingPanels: [SwiftPermisoPanel] = []
    private var pendingSourceFrameInScreen: CGRect?
    private var didPresentCurrentOverlay = false

    public init() {}

    public func present(
        panel: SwiftPermisoPanel,
        hostApp: SwiftPermisoHostApp = .current(),
        sourceFrameInScreen: CGRect? = nil
    ) {
        pendingPanels = [panel]
        presentCurrent(hostApp: hostApp, sourceFrameInScreen: sourceFrameInScreen)
    }

    public func presentMissingPanels(
        _ panels: [SwiftPermisoPanel],
        hostApp: SwiftPermisoHostApp = .current(),
        sourceFrameInScreen: CGRect? = nil
    ) {
        pendingPanels = panels
        presentCurrent(hostApp: hostApp, sourceFrameInScreen: sourceFrameInScreen)
    }

    public func dismiss() {
        trackingTimer?.invalidate()
        trackingTimer = nil
        if let activationObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(activationObserver)
            self.activationObserver = nil
        }
        overlayController?.close()
        overlayController = nil
        pendingPanels = []
        pendingSourceFrameInScreen = nil
        didPresentCurrentOverlay = false
    }

    private func presentCurrent(hostApp: SwiftPermisoHostApp, sourceFrameInScreen: CGRect?) {
        guard let panel = pendingPanels.first else {
            dismiss()
            return
        }

        pendingSourceFrameInScreen = sourceFrameInScreen
        didPresentCurrentOverlay = false
        overlayController = OverlayWindowController(hostApp: hostApp, panel: panel) { [weak self] in
            self?.showPreviousPanel(hostApp: hostApp)
        }
        NSWorkspace.shared.open(panel.settingsURL)
        startTracking()
    }

    private func showPreviousPanel(hostApp: SwiftPermisoHostApp) {
        guard pendingPanels.count > 1 else {
            dismiss()
            return
        }
        pendingPanels.removeFirst()
        presentCurrent(hostApp: hostApp, sourceFrameInScreen: nil)
    }

    private func startTracking() {
        trackingTimer?.invalidate()
        trackingTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.refreshPosition() }
        }

        if let activationObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(activationObserver)
        }
        activationObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in self?.refreshPosition() }
        }
        refreshPosition()
    }

    private func refreshPosition() {
        guard let snapshot = SettingsWindowLocator.frontmostWindow() else {
            overlayController?.hide()
            return
        }
        if didPresentCurrentOverlay {
            overlayController?.updatePosition(with: snapshot.frame, visibleFrame: snapshot.visibleFrame)
            return
        }

        overlayController?.present(
            from: pendingSourceFrameInScreen,
            settingsFrame: snapshot.frame,
            visibleFrame: snapshot.visibleFrame
        )
        didPresentCurrentOverlay = true
    }
}
