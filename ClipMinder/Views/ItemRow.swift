//
//  ItemRow.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 10/03/2025.
//

import SwiftUI

struct ItemRow<Item: SupportedEntity> : View {

    private let formatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()

    let item: Item
    let isSelected: Bool

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "text.page")
                .font(.title2)
                .padding([.leading, .trailing, .top], 8)
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .top) {
                    Text("\(item)")
                        .lineLimit(2)
                    if isSelected {
                        Spacer()
                        Text("⏎")
                            .foregroundStyle(.secondary)
                            .padding([.trailing], 4)
                    }
                }
                .padding([.top], 8)
                .padding([.leading], 6)
                HStack {
                    Spacer()
                    Text(formatter.localizedString(for: item.createdAt, relativeTo: Date.now))
                        .foregroundStyle(.tertiary)
                        .font(.caption)
                        .padding([.trailing], 4)
                }
            }
        }
    }
}

#Preview {
    Group {
        ItemRow(item: StringEntity("Hello, world"), isSelected: false)
            .padding(6)
        ItemRow(item: StringEntity("Selected, world"), isSelected: true)
            .padding(6)
    }
}
