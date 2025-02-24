//
//  KeyListener.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//

import SwiftUI

@Observable
final class LocalKeyListener {
    var hotKeyEvent = NSEvent()
    var isActive = false
    init() {
        NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            guard let self else { return event }
            if isActive && !event.modifierFlags.toEventModifiers().isEmpty {
                hotKeyEvent = event
                isActive = false
            }
            return event
        }
        NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) { [weak self] event in
            guard let self else { return event }
            if event.modifierFlags.toEventModifiers().isEmpty {
                isActive = true
            }
            return event
        }
    }
}
