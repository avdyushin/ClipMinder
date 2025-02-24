//
//  AppIconLabelStyle.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//

import SwiftUI

struct AppIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 16) {
            configuration.icon
            VStack(alignment: .leading) {
                configuration.title
            }
        }
    }
}
