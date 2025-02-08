//
//  AppLaunchService.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//

import SwiftUI
import Observation
import ServiceManagement

protocol AppLaunchService {
    var launchAtLogin: Bool { get }
    func toggleLaunchAtLogin(isLaunchAtLogin: Bool)
}
