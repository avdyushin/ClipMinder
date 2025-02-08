//
//  AppLaunchServiceImpl.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//

import SwiftUI
import Observation
import ServiceManagement

final class AppLaunchServiceImpl: AppLaunchService {

    private var status: SMAppService.Status { SMAppService.mainApp.status }
    var launchAtLogin: Bool { status == .enabled }

    func toggleLaunchAtLogin(isLaunchAtLogin: Bool) {
        if isLaunchAtLogin {
            try? SMAppService.mainApp.register()
        } else {
            try? SMAppService.mainApp.unregister()
        }
    }
}
