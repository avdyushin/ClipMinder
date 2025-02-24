//
//  HotKey.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//

import SwiftUI

struct HotKey: Equatable, Codable, RawRepresentable {

    typealias RawValue = String

    static let defaultKeyCode: CGKeyCode = 9
    static let defaultModifiers: [EventModifiers] = [.shift, .command]
    static let `default` = HotKey(rawValue: "⇧+⌘+V")

    let keyCode: CGKeyCode
    let modifiers: EventModifiers

    init(rawValue: String) {
        var modifiers: EventModifiers = .none
        if rawValue.contains(EventModifiers.command.symbol) {
            modifiers.update(with: .command)
        }
        if rawValue.contains(EventModifiers.shift.symbol) {
            modifiers.update(with: .shift)
        }
        if rawValue.contains(EventModifiers.option.symbol) {
            modifiers.update(with: .option)
        }
        if rawValue.contains(EventModifiers.control.symbol) {
            modifiers.update(with: .control)
        }
        let letter = rawValue.last?.uppercased() ?? "V"
        let keyCode = CGKeyCode(letter) ?? Self.defaultKeyCode
        self.init(keyCode: keyCode, modifiers: modifiers)
    }

    init(keyCode: CGKeyCode, modifiers: EventModifiers) {
        self.keyCode = keyCode
        self.modifiers = modifiers
    }

    var rawValue: String {
        let modifiers = self.modifiers.toSymbols
        let code = keyCode.toString()
        let keys = (modifiers + [code]).compactMap { $0 }
        return keys.joined(separator: "+")
    }
}

extension HotKey: CustomStringConvertible {
    var description: String { rawValue }
}
