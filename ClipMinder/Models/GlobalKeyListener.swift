//
//  GlobalKeyListener.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//

import SwiftUI

@Observable
final class GlobalKeyListener {

    private var eventTap: CFMachPort?
    var hotKeyTriggered = false

    init() {
        let callback: CGEventTapCallBack = { (proxy, type, event, info) -> Unmanaged<CGEvent>? in
            guard let rawValue = UserDefaults.standard.string(forKey: "hot_key") else {
                debugPrint("No hot key is defined, check settings!")
                return .passUnretained(event)
            }
            let hotKey = HotKey(rawValue: rawValue)
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
            let modifiers = event.flags.toEventModifiers()
            if keyCode == hotKey.keyCode, modifiers == hotKey.modifiers {
                if let info {
                    Unmanaged<GlobalKeyListener>.fromOpaque(info).takeUnretainedValue().hotKeyTriggered = true
                    return nil
                }
            }
            return .passUnretained(event)
        }
        let userInfo = Unmanaged.passRetained(self).toOpaque()
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly,
            eventsOfInterest: (CGEventMask(1 << CGEventType.keyDown.rawValue)),
            callback: callback,
            userInfo: userInfo
        )
        guard let eventTap else {
            Unmanaged<GlobalKeyListener>.fromOpaque(userInfo).release()
            debugPrint("Can't create <CGEvent.tapCreate>!")
            return
        }
        let runLoop = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoop, .defaultMode)
    }

    deinit {
        Unmanaged.passUnretained(self).release()
    }
}
