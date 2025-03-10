//
//  LocalStorage.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 03/03/2025.
//


import Foundation

struct LocalStorage<Item: SupportedEntity>: Storage {

    private let storageKey = "HistoryStorage"
    private let encoder = JSONEncoder()
    private let defaults = UserDefaults.standard

    var items = [Item]()
    var count: Int { items.count }

    init() {
        try? load()
    }

    subscript(index: Int) -> Item? {
        guard items.indices ~= index else {
            return nil
        }
        return items[index]
    }

    mutating func append(_ item: Item) {
        if let index = items.firstIndex(where: { $0.value == item.value }) {
            move(fromIndex: index, toIndex: 0)
        } else {
            items.insert(item, at: 0)
        }
        // check limit
        try? save()
    }

    mutating func move(fromIndex: Int, toIndex: Int) {
        if var item = self[fromIndex] {
            item.updateTimestamp(timestamp: Date())
        }
        items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex)
    }

    mutating func clear() {
        items = []
        try? save()
    }

    func save() throws {
        let encoded = try encoder.encode(items)
        defaults.set(encoded, forKey: storageKey)
    }

    mutating func load() throws {
        guard let stored = defaults.object(forKey: storageKey) as? Data,
              let decoded = try? JSONDecoder().decode([Item].self, from: stored) else {
                  return
        }
        items = decoded
    }
}
