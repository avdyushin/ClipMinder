//
//  PasteboardService.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 18/02/2025.
//

protocol PasteboardService {
    associatedtype Item: SupportedEntity
    var currentItem: Item? { get }
    func placeItem(_ item: Item)
}
