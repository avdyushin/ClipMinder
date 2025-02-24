//
//  Storage.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 24/02/2025.
//

import Foundation

protocol Storage {
    associatedtype Item: SupportedEntity

    var count: Int { get }
    subscript(_ index: Int) -> Item? { get }
    func append(_ item: Item)
    func move(fromIndex: Int, toIndex: Int)
    func clear()
    func load() throws
    func save() throws
}
