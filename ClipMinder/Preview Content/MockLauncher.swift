//
//  MockLauncher.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//


import SwiftUI
import ServiceManagement



struct MockLauncher: PreviewModifier {
    static func makeSharedContext() async throws -> AppSettings {
        AppSettings(
            launch: AppLaunchServiceMock(),
            permissionsListen: AppPermissionsServiceMock(),
            permissionsPost: AppPermissionsServiceMock()
        )
    }

    func body(content: Content, context: AppSettings) -> some View {
        content
            .environment(context)
    }
}
