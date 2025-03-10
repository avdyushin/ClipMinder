//
//  HistoryServiceMock.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 03/03/2025.
//

import SwiftUI

final class MockStorage: Storage {

    var items = [
        StringEntity("Hello, world"),
        StringEntity("This is \n\nalso item", createdAt: Date.now.advanced(by: -3600)),
        StringEntity("A\nB\nC\nD\nE\nF\n..."),
        StringEntity("😎"),
        StringEntity("Some random 1"),
        StringEntity("Some random 2"),
        StringEntity("Some random 3"),
        StringEntity("Some random 4"),
        StringEntity("Some random 5"),
        StringEntity("Some random 6"),
        StringEntity("Some random 7"),
        StringEntity("Some random 8"),
    ]

    var count: Int { items.count }

    func append(_ item: StringEntity) {
        items.append(item)
    }

    subscript(index: Int) -> StringEntity? {
        items[index]
    }

    func move(fromIndex: Int, toIndex: Int) {
    }

    func remove(atIndex: Int) {
        guard items.indices ~= atIndex else {
            return
        }
        items.remove(at: atIndex)
    }

    func clear() {
        items.removeAll()
    }
    
    func load() throws {
    }

    func save() throws {
    }
}
