//
//  AppSettings.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//

import SwiftUI

@Observable
final class AppSettings {

    private let launchService: AppLaunchService
    private let permissionListenService: AppPermissionsService
    private let permissionPostService: AppPermissionsService
    var launchAtLogin: Bool
    var listenPermissionsEnabled: Bool
    var postPermissionsEnabled: Bool

    @ObservationIgnored @AppStorage("hot_key") var hotKey = HotKey.default
    @ObservationIgnored @AppStorage("double_tap") var doubleTap = false

    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

    init(
        launch: AppLaunchService,
        permissionsListen: AppPermissionsService,
        permissionsPost: AppPermissionsService
    ) {
        self.launchService = launch
        self.launchAtLogin = launch.launchAtLogin
        self.permissionListenService = permissionsListen
        self.listenPermissionsEnabled = permissionsListen.isEnabled
        self.permissionPostService = permissionsPost
        self.postPermissionsEnabled = permissionsPost.isEnabled
    }

    func toggleLaunchAtLogin(isLaunchAtLogin: Bool) {
        launchService.toggleLaunchAtLogin(isLaunchAtLogin: isLaunchAtLogin)
    }

    func verifyLaunchAtLogin() {
        launchAtLogin = launchService.launchAtLogin
    }

    func verifyPermissions() {
        listenPermissionsEnabled = permissionListenService.isEnabled
        postPermissionsEnabled = permissionPostService.isEnabled
    }

    func openSettingsListen() {
        permissionListenService.openSettings()
    }

    func openSettingsPost() {
        permissionPostService.openSettings()
    }
}
