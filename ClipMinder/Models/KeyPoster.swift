//
//  KeyPoster.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 17/02/2025.
//

import Cocoa

@Observable
final class KeyPoster<PS: PasteboardService> {

    private let pasteboardService: PS

    init(pasteboardService: PS) {
        self.pasteboardService = pasteboardService
    }

    func postCmdV(item: PS.Item) {
        pasteboardService.placeItem(item)
        let source = CGEventSource(stateID: .hidSystemState)
        let key: CGKeyCode = 0x09 // V
        let flags = CGEventFlags.maskCommand
        func down() {
            let event = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: true)
            event?.flags = flags
            event?.post(tap: .cghidEventTap)
        }
        func up() {
            let event = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: false)
            event?.flags = flags
            event?.post(tap: .cghidEventTap)
        }
        down()
        up()
    }
}
