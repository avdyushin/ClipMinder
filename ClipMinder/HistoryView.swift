//
//  HistoryView.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 10/02/2025.
//

import SwiftUI

struct HistoryView<P: PasteboardService, S: Storage>: View where P.Item == S.Item {

    private typealias ItemList = Array<P.Item>

    private struct Scroller: View {
        @Binding var selection: ItemList.Index
        let proxy: ScrollViewProxy
        func scroll(id: any Hashable, anchor: UnitPoint) {
            proxy.scrollTo(id, anchor: anchor)
        }
        var body: some View {
            EmptyView()
                .onChange(of: selection) { oldValue, newValue in
                    scroll(id: selection, anchor: .center)
                }
        }
    }

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

    @MainActor private func nextSelection() {
        guard !list.isEmpty else { return }
        listSelection = (listSelection + 1) % list.count
    }

    @MainActor private func prevSelection() {
        guard !list.isEmpty else { return }
        listSelection = listSelection == 0 ? list.count - 1 : listSelection - 1
    }

    private let formatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()

    var body: some View {
        ScrollViewReader { scrollViewProxy in
            Scroller(selection: $listSelection, proxy: scrollViewProxy)
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
                    .id(index)
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
        }
        .onAppear {
            // Ugly hack to fix 'floating' window
            if let window = NSApp.windows.first(where: { $0.title == "ClipMinder" }) {
                let buttons: [NSWindow.ButtonType] = [.closeButton, .miniaturizeButton, .zoomButton]
                buttons.forEach {
                    window.standardWindowButton($0)?.isHidden = true
                }
            }

            listSelection = 0
            isFocused = true
        }
        .ignoresSafeArea()
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
