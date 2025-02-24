//
//  StringEntity.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 24/02/2025.
//


import Foundation

struct StringEntity: SupportedEntity {

    let value: String
    var createdAt: Date

    init(_ value: String, createdAt: Date = Date()) {
        self.value = value
        self.createdAt = createdAt
    }

    var description: String { value.trimmingCharacters(in: .whitespacesAndNewlines) }

    mutating func updateTimestamp(timestamp: Date) {
        self.createdAt = timestamp
    }
}