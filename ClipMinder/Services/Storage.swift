//
//  Storage.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 24/02/2025.
//

import Foundation

protocol Storage {
    associatedtype Item: SupportedEntity

    var items: [Item] { get }
    var count: Int { get }
    subscript(_ index: Int) -> Item? { get }
    mutating func append(_ item: Item)
    mutating func move(fromIndex: Int, toIndex: Int)
    mutating func clear()
    mutating func load() throws
    func save() throws
}
