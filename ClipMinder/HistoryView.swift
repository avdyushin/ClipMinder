//
//  HistoryView.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 10/02/2025.
//

import SwiftUI

struct HistoryView: View {

    @Environment(\.dismissWindow) private var dismissWindow
    @FocusState private var isFocused: Bool
    @State private var listSelection: Int = 0
    private let keyPoster = KeyPoster<String>()

    private let list = [
        "Hello",
        "This",
        "Is",
        "Sample",
        "List"
    ]

    private func closeWindow() {
        NSApp.hide(self)
        dismissWindow(id: "main-window")
    }

    @MainActor private func nextSelection() {
        listSelection = (listSelection + 1) % list.count
    }

    @MainActor private func prevSelection() {
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
    }
}
