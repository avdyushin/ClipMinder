//
//  SupportedEntity.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 24/02/2025.
//


import Foundation

protocol SupportedEntity: PasteboardEntity {
    associatedtype Item: Equatable
    var value: Item { get }
}
