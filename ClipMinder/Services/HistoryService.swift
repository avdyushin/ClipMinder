//
//  HistoryService.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 24/02/2025.
//


import Foundation

@Observable
final class HistoryService<S: Storage> {

    private var storage: S
    var items: [S.Item] { storage.items }

    init(storage: S) {
        self.storage = storage
    }

    func clear() { storage.clear() }
    func append(_ item: S.Item) { storage.append(item) }
    func remove(at index: [S.Item].Index) { storage.remove(atIndex: index) }
}
