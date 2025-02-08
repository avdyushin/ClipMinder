//
//  AppSettingsMock.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//

import SwiftUI
import ServiceManagement

private final class AppSettingsMock: AppSettingsProtocol {
    var launchAtLogin: Bool = true
    func toggleLaunchAtLogin(isLaunchAtLogin: Bool) {
        launchAtLogin = isLaunchAtLogin
    }
    func verifyLaunchAtLogin() {}
}
