//
//  Settings.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 03/02/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var hotKey: String = ""

    var body: some View {
        Form {
            Section("General") {
                TextField("Hot key", text: $hotKey)
            }
            Section("Startup") {
            }
        }
        Button("back", action: dismiss.callAsFunction)
    }
}

#Preview {
    SettingsView()
}
