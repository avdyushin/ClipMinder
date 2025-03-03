//
//  MockAppSettings.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//

import SwiftUI
import ServiceManagement

struct MockAppSettings: PreviewModifier {
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

extension PreviewTrait {
    static var withMockSettings: PreviewTrait<Preview.ViewTraits> { .modifier(MockAppSettings()) }
}
