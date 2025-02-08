import SwiftUI
import Observation
import ServiceManagement

protocol AppLaunchService {
    var launchAtLogin: Bool { get }
    func toggleLaunchAtLogin(isLaunchAtLogin: Bool)
}