//
//  AppSettingsMock.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//

final class AppLaunchServiceMock: AppLaunchService {
    var launchAtLogin: Bool = true {
        didSet {
            debugPrint("Did set launchAtLogin to", launchAtLogin)
        }
    }
    func toggleLaunchAtLogin(isLaunchAtLogin: Bool) {
        launchAtLogin = isLaunchAtLogin
    }
}
