//
//  AppMenu.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 03/02/2025.
//

import SwiftUI

struct AppMenu: View {
    let onClear: () -> Void

    var body: some View {
        VStack {
            SettingsLink()
                .keyboardShortcut(",", modifiers: [.command])
            Button("Clear", action: onClear)
                .keyboardShortcut("c", modifiers: [.option])
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q", modifiers: [.command])
        }
    }
}

#Preview {
    AppMenu { }
}
