//
//  HistoryView.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 10/02/2025.
//

import SwiftUI

struct HistoryView<PS: PasteboardService>: View {

    private typealias ItemList = Array<PS.Item>

    @Environment(KeyPoster<PS>.self) private var keyPoster
    @Environment(HistoryService<PS.Item>.self) private var historyService
    @Environment(\.dismissWindow) private var dismissWindow
    @FocusState private var isFocused: Bool
    @State private var listSelection: ItemList.Index = ItemList.Index.zero

    private var list: ItemList { historyService.items }

    private func closeWindow() {
        NSApp.hide(self)
        dismissWindow(id: "main-window")
    }

    @MainActor private func nextSelection() {
        guard !list.isEmpty else { return }
        listSelection = (listSelection + 1) % list.count
    }

    @MainActor private func prevSelection() {
        guard !list.isEmpty else { return }
        listSelection = listSelection == 0 ? list.count - 1 : listSelection - 1
    }

    var body: some View {
        List(selection: $listSelection) {
            ForEach(list.indices, id: \.self) { index in
                Text("\(index). \(list[index])").tag(index).padding()
            }
        }
        .focusable()
        .focused($isFocused)
        .onKeyPress(phases: [.down, .repeat]) { event in
            switch event.key {
            case "h", "k", .upArrow, .leftArrow: prevSelection()
            case "j", "l", .downArrow, .rightArrow: nextSelection()
            case .return:
                Task {
                    // try await Task.sleep(nanoseconds: 500_000_000)
                    keyPoster.postCmdV(item: list[listSelection])
                }
                fallthrough
            case .escape: closeWindow()
            default: ()
            }
            return KeyPress.Result.handled
        }
        .onAppear { isFocused = true }
        .onDisappear { isFocused = false }
        .overlay {
            if list.isEmpty {
                ContentUnavailableView(
                    "Nothing here",
                    systemImage: "arrow.trianglehead.2.clockwise.rotate.90.page.on.clipboard",
                    description: Text("No pasteboard items available yet")
                )
            }
        }
    }
}
