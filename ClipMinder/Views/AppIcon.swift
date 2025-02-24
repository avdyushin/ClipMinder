//
//  AppIcon.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//

import SwiftUI

struct AppIcon: View {

    var body: some View {
        ZStack {
            Circle()
                .fill(Gradient(colors: [Color.pink, Color.blue]))
                .strokeBorder(Color.white.gradient, lineWidth: 8)
                .frame(width: 128, height: 128)
                .shadow(radius: 1)
            Image(systemName: "paperclip")
                .font(.system(size: 72))
                .foregroundStyle(Color.white.gradient)
                .shadow(radius: 2)
        }
    }
}

#Preview {
    AppIcon()
}
