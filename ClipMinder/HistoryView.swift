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

    private func fixWindowButtons() {
        // Ugly hack to fix 'floating' window
        if let window = NSApp.windows.first(where: { $0.title == "ClipMinder" }) {
            let buttons: [NSWindow.ButtonType] = [.closeButton, .miniaturizeButton, .zoomButton]
            buttons.forEach {
                window.standardWindowButton($0)?.isHidden = true
            }
        }
    }

    private func keyPressHandler(event: KeyPress) -> KeyPress.Result {
        switch event.key {
        case "h", "k", .upArrow, .leftArrow: prevSelection()
        case "j", "l", .downArrow, .rightArrow: nextSelection()
        case .backspace: Task {
            historyService.remove(at: listSelection)
            switch list.count {
            case 1: listSelection = 0
            default:
                switch listSelection {
                case list.count: listSelection -= 1
                default: ()
                }
            }
        }
        case .return: Task {
            // try await Task.sleep(nanoseconds: 500_000_000)
            keyPoster.postCmdV(item: list[listSelection])
        }
            fallthrough
        case .escape: closeWindow()
        default: ()
        }
        return KeyPress.Result.handled
    }

    var body: some View {
        ScrollViewReader { scrollViewProxy in
            Scroller(selection: $listSelection, proxy: scrollViewProxy)
            List(selection: $listSelection) {
                ForEach(list.indices, id: \.self) { index in
                    ItemRow(item: list[index], isSelected: index == listSelection)
                        .tag(index)
                        .id(index)
                        .alignmentGuide(.listRowSeparatorLeading) { dim in -20 }
                        .padding(4)
                }
            }
            .scrollIndicators(.never, axes: [.vertical])
            .listStyle(.plain)
            .focusable()
            .focused($isFocused)
            .onKeyPress(phases: [.down, .repeat], action: keyPressHandler)
        }
        .ignoresSafeArea()
        .onAppear {
            isFocused = true
            listSelection = 0
            fixWindowButtons()
        }
        .onDisappear {
            isFocused = false
        }
        .overlay {
            if list.isEmpty {
                ContentUnavailableView(
                    "Nothing here",
                    systemImage: "text.page.slash",
                    description: Text("No pasteboard items available yet")
                )
            }
        }
    }
}

fileprivate extension KeyEquivalent {
    static let backspace = KeyEquivalent("\u{7F}")
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
