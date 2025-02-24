//
//  HotKeyFormatStyle.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//

import SwiftUI

struct HotKeyFormatStyle: ParseableFormatStyle {
    struct Strategy : ParseStrategy {
        func parse(_ value: String) throws -> HotKey {
            HotKey(rawValue: value)
        }
    }
    var parseStrategy = Strategy()
    func format(_ value: HotKey) -> String {
        value.rawValue
    }
}
