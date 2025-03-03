//
//  Settings.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 03/02/2025.
//

import SwiftUI

struct SettingsView: View {

    @Environment(AppSettings.self) private var appSettings
    @Environment(\.appearsActive) private var appearsActive

    @FocusState private var hotKeyFocused: Bool
    @State private var keyListener = LocalKeyListener()
    private let doubleTapEnabled = false

    var body: some View {
        @Bindable var appSettings = appSettings
        VStack {
            Form {
                HStack {
                    Spacer()
                    Label {
                        Spacer()
                        Text("ClipMinder")
                            .font(.largeTitle)
                        Text("Version \(appSettings.version)")
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                        Spacer(minLength: 8)
                        Text("Copyright © [grigory.nl](https://grigory.nl) 2018-2025. All rights reserved.")
                            .foregroundStyle(.tertiary)
                        Divider()
                        Spacer()
                    } icon: {
                        AppIcon()
                    }
                    .labelStyle(AppIconLabelStyle())
                    .padding()
                    Spacer()
                }
                Section("General") {
                    TextField(value: $appSettings.hotKey, format: HotKeyFormatStyle()) {
                        Text("ClipMinder Hotkey")
                        Text("Select this field and type the hotkey you whould like to use to show ClipMinder.")
                    }
                    .focused($hotKeyFocused)
                    .onChange(of: hotKeyFocused) { oldValue, newValue in
                        keyListener.isActive = newValue
                    }
                    .onChange(of: keyListener.hotKeyEvent) { oldValue, newValue in
                        appSettings.hotKey = newValue.toHotKey()
                        hotKeyFocused.toggle()
                    }
                    .onKeyPress(phases: [.down]) { key in
                        KeyPress.Result.handled
                    }
                    if doubleTapEnabled {
                        Toggle(isOn: $appSettings.doubleTap) {
                            Text("Use double tap to trigger")
                            Text("If selected, hotkey has to be pressed twice quickly to show ClipMinder.")
                        }
                    }
                }
                Section("Startup") {
                    Toggle(isOn: $appSettings.launchAtLogin) {
                        Text("Launch ClipMinder at Login")
                        Text("If selected, ClipMinder will launch at login after using the \"Quit\" menu item.")
                    }
                }
                if !appSettings.listenPermissionsEnabled || !appSettings.postPermissionsEnabled {
                    Section("Permissions") {
                        if !appSettings.listenPermissionsEnabled {
                            LabeledContent {
                                Button("Open Settings") {
                                    appSettings.openSettingsListen()
                                }
                            } label: {
                                Text("Turn on input monitoring")
                                HStack(alignment: .top) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundStyle(.yellow)
                                    Text(
                                        "To be able to trigger Hotkey select the ClipMinder checkbox in Security & Privacy > Input Monitoring."
                                    )
                                }
                            }
                        }
                        if !appSettings.postPermissionsEnabled {
                            LabeledContent {
                                Button("Open Settings") {
                                    appSettings.openSettingsListen()
                                }
                            } label: {
                                Text("Turn on accessibility")
                                HStack(alignment: .top) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundStyle(.yellow)
                                    Text(
                                        "To be able to paste into other apps select the ClipMinder checkbox in Security & Privacy > Accessibility."
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .formStyle(.grouped)
        }
        .fixedSize()
        .onChange(of: appearsActive) { _, isActive in
            if isActive {
                appSettings.verifyLaunchAtLogin()
                appSettings.verifyPermissions()
            }
        }
        .onChange(of: appSettings.launchAtLogin) { _, isLaunchAtLogin in
            appSettings.toggleLaunchAtLogin(isLaunchAtLogin: isLaunchAtLogin)
        }
    }
}

#Preview(traits: .withMockSettings) {
    SettingsView()
}
