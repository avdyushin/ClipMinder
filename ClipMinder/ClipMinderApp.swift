//
//  ClipMinderApp.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 03/02/2025.
//

import SwiftUI

@main
struct ClipMinderApp: App {

    @Environment(\.openWindow) private var openWindow
    @Environment(\.appearsActive) private var appearsActive

    @State private var appSettings = AppSettings(
        launch: AppLaunchServiceImpl(),
        permissionsListen: AppPermissionsListenEventServiceImpl(),
        permissionsPost: AppPermissionsPostEventServiceImpl()
    )
    @State private var keyListener = GlobalKeyListener()
    @State private var pasteboardService = PasteboardServiceImpl()
    @State private var historyService = HistoryService<PasteboardServiceImpl.Item>()

    var body: some Scene {
        MenuBarExtra("ClipMinder", systemImage: "paperclip") {
            AppMenu(onClear: historyService.clear)
        }
        .menuBarExtraStyle(.menu)
        .onChange(of: keyListener.hotKeyTriggered) { oldValue, newValue in
            if newValue {
                keyListener.hotKeyTriggered = false
                NSApp.activate(ignoringOtherApps: true)
                openWindow(id: "main-window")
            }
        }
        .onChange(of: pasteboardService.currentItem) { oldValue, newValue in
            if oldValue != newValue, let value = newValue {
                historyService.append(value)
            }
        }

        Window("ClipMinder", id: "main-window") {
            HistoryView<PasteboardServiceImpl>()
                .environment(historyService)
                .environment(KeyPoster(pasteboardService: pasteboardService))
                .gesture(WindowDragGesture())
        }
        .windowLevel(.floating)
        .windowStyle(.hiddenTitleBar)
        .defaultLaunchBehavior(.suppressed)

        Settings {
            SettingsView()
        }
        .environment(appSettings)
        .windowLevel(.floating)
    }
}
