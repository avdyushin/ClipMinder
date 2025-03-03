//
//  HistoryView.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 10/02/2025.
//

import SwiftUI

struct HistoryView<P: PasteboardService, S: Storage>: View where P.Item == S.Item {

    private typealias ItemList = Array<P.Item>

    @Environment(KeyPoster<P>.self) private var keyPoster
    @Environment(HistoryService<S>.self) private var historyService
    @Environment(\.dismissWindow) private var dismissWindow
    @FocusState private var isFocused: Bool
    @State private var listSelection: ItemList.Index = ItemList.Index.zero

    private var list: ItemList { historyService.items }

    private func closeWindow() {
        NSApp.hide(self)
        dismissWindow(id: "main-window")
    }

    @MainActor private func nextSelection(scrollViewProxy: ScrollViewProxy) {
        guard !list.isEmpty else { return }
        listSelection = (listSelection + 1) % list.count
        scrollViewProxy.scrollTo(list[listSelection], anchor: .center)
    }

    @MainActor private func prevSelection(scrollViewProxy: ScrollViewProxy) {
        guard !list.isEmpty else { return }
        listSelection = listSelection == 0 ? list.count - 1 : listSelection - 1
        scrollViewProxy.scrollTo(list[listSelection], anchor: .center)
    }

    private let formatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()

    var body: some View {
        ScrollViewReader { scrollViewProxy in
            List(selection: $listSelection) {
                ForEach(list.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(index). \(list[index])")
                            .padding(4)
                            .lineLimit(2)
                        HStack {
                            Spacer()
                            Text(formatter.localizedString(for: list[index].createdAt, relativeTo: Date.now))
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .tag(index)
                    .id(list[index])
                }
            }
            .focusable()
            .focused($isFocused)
            .onKeyPress(phases: [.down, .repeat]) { event in
                switch event.key {
                case "h", "k", .upArrow, .leftArrow: prevSelection(scrollViewProxy: scrollViewProxy)
                case "j", "l", .downArrow, .rightArrow: nextSelection(scrollViewProxy: scrollViewProxy)
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

#Preview {
    @Previewable @State var storage = MockStorage()
    Group {
        HistoryView<PasteboardServiceMock, MockStorage>()
            .environment(HistoryService(storage: storage))
            .environment(KeyPoster(pasteboardService: PasteboardServiceMock()))
        Button("Add item") {
            storage.append(StringEntity("Surprise"))
        }
    }
}
