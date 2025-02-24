//
//  AppMenu.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 03/02/2025.
//

import SwiftUI

struct AppMenu: View {
    var body: some View {
        VStack {
            SettingsLink()
                .keyboardShortcut(",", modifiers: [.command])
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q", modifiers: [.command])
        }
    }
}

#Preview {
    AppMenu()
}
