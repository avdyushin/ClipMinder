//
//  HistoryService.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 24/02/2025.
//


import Foundation

@Observable
final class HistoryService<Item: SupportedEntity>: Storage {

    var items = [Item]()
    var count: Int { items.count }

    subscript(index: Int) -> Item? {
        guard items.indices ~= index else {
            return nil
        }
        return items[index]
    }

    func append(_ item: Item) {
        if let index = items.firstIndex(where: { $0.value == item.value }) {
            move(fromIndex: index, toIndex: 0)
        } else {
            items.insert(item, at: 0)
        }
        // check limit
        try? save()
    }

    func move(fromIndex: Int, toIndex: Int) {
        if var item = self[fromIndex] {
            item.updateTimestamp(timestamp: Date())
        }
        items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex)
    }

    func clear() {
        items = []
        try? save()
    }

    func save() throws {
        debugPrint("Saved \(items)")
    }

    func load() throws {
        items = []
        debugPrint("Loaded")
    }
}
