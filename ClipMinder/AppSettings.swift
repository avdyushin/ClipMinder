import SwiftUI
import ServiceManagement

final class AppSettings: ObservableObject {
    @Published var launchAtLogin = SMAppService.mainApp.status == .enabled
    var status: SMAppService.Status { SMAppService.mainApp.status }

    func toggleLaunchAtLogin(isLaunchAtLogin: Bool) {
        if isLaunchAtLogin {
            try? SMAppService.mainApp.register()
        } else {
            try? SMAppService.mainApp.unregister()
        }
    }

    func verifyLaunchAtLogin() {
        launchAtLogin = status == .enabled
    }
}