//
//  AppPermissionsPostEventServiceImpl.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 17/02/2025.
//


import Cocoa
import SwiftUI

final class AppPermissionsPostEventServiceImpl : AppPermissionsService {
    var isEnabled: Bool {
        AXIsProcessTrusted()
    }

    func openSettings() {
        NSWorkspace.shared.open(
            URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        )
    }
}
