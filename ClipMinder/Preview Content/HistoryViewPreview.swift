//
//  HistoryViewPreview.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 02/04/2025.
//

import SwiftUI

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
