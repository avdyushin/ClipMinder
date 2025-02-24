//
//  Events.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//

import SwiftUI

extension EventModifiers: Codable {}

extension EventModifiers {
    static let none = EventModifiers()

    var symbol: String {
        switch self {
        case .control: "⌃"
        case .option: "⌥"
        case .shift: "⇧"
        case .command: "⌘"
        default: "?"
        }
    }

    var toSymbols: [String] {
        [.control, .option, .shift, .command]
            .filter { self.contains($0) }
            .map { $0.symbol }
    }

    var toHotKeyPrefix: String {
        toSymbols.joined(separator: "+")
    }
}

extension NSEvent.ModifierFlags {
    func toEventModifiers() -> EventModifiers {
        var modifiers: EventModifiers = .none
        if self.contains(.command) {
            modifiers.update(with: .command)
        }
        if self.contains(.shift) {
            modifiers.update(with: .shift)
        }
        if self.contains(.option) {
            modifiers.update(with: .option)
        }
        if self.contains(.control) {
            modifiers.update(with: .control)
        }
        return modifiers
    }
}

extension CGEventFlags {
    func toEventModifiers() -> EventModifiers {
        var modifiers: EventModifiers = .none
        if self.contains(.maskCommand) {
            modifiers.update(with: .command)
        }
        if self.contains(.maskShift) {
            modifiers.update(with: .shift)
        }
        if self.contains(.maskAlternate) {
            modifiers.update(with: .option)
        }
        if self.contains(.maskControl) {
            modifiers.update(with: .control)
        }
        return modifiers
    }
}

extension NSEvent {
    func toHotKey() -> HotKey {
        HotKey(keyCode: keyCode, modifiers: modifierFlags.toEventModifiers())
    }
}
