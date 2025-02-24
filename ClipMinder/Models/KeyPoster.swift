//
//  KeyPoster.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 17/02/2025.
//

import Cocoa

final class KeyPoster<T> {

    private func placeItemIntoPastboard(item: T) {
        guard let string = item as? String else {
            fatalError("Unsupported item \(item)")
        }

        let pb = NSPasteboard.general
        pb.declareTypes([.string], owner: self)
        pb.setString(string, forType: .string)
    }

    func postCmdV(item: T) {
        placeItemIntoPastboard(item: item)
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
