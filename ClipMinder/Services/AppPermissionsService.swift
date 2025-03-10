//
//  AppPermissionsService.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 11/02/2025.
//

import SwiftUI
import ApplicationServices

protocol AppPermissionsService {
    var isEnabled: Bool { get }
    func openSettings()
}
