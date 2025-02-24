//
//  PasteboardService.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 18/02/2025.
//

protocol PasteboardService {
    associatedtype Item
    var currentItem: Item? { get }
    func placeItem(_ item: Item)
}
