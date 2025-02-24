//
//  TImestampRelated.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 24/02/2025.
//

import Foundation

protocol TimestampRelated {
    var createdAt: Date { get }
    mutating func updateTimestamp(timestamp: Date)
}
