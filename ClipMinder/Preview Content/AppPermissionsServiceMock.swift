//
//  AppPermissionsMock.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 11/02/2025.
//


import SwiftUI
import ServiceManagement

struct AppPermissionsServiceMock: AppPermissionsService {
    var isEnabled: Bool = false
    func openSettings() { }
}
