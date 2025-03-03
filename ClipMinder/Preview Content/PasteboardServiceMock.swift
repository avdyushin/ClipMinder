//
//  PasteboardServiceMock.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 03/03/2025.
//

struct PasteboardServiceMock: PasteboardService {
    typealias Item = StringEntity

    var currentItem: StringEntity? = nil
    func placeItem(_ item: StringEntity) {
        debugPrint("Item has been placed", item)
    }
}
