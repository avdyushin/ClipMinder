//
//  AppPermissionsListenEventServiceImpl.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 11/02/2025.
//


import SwiftUI
import IOKit

final class AppPermissionsListenEventServiceImpl : AppPermissionsService {
    var isEnabled: Bool {
        switch  IOHIDCheckAccess(kIOHIDRequestTypeListenEvent) {
        case kIOHIDAccessTypeGranted: return true
        case kIOHIDAccessTypeDenied: return false
        case kIOHIDAccessTypeUnknown: return false
        default: return false
        }
    }

    func openSettings() {
        NSWorkspace.shared.open(
            URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent")!
        )
    }
}
