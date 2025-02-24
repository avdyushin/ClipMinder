//
//  KeyCode.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 08/02/2025.
//

import Carbon

extension CGKeyCode {

    private static let map = generateMap()

    init?(_ from: String) {
        guard let code = Self.map[from] else {
            return nil
        }
        self = code
    }

    static func generateMap() -> [String: CGKeyCode] {
        let range: Range<CGKeyCode> = 0..<128
        var results = [String: CGKeyCode]()
        range.forEach {
            if let value = $0.toString() {
                results[value] = $0
            }
        }
        return results
    }

    func toString() -> String? {
        let source = TISCopyCurrentASCIICapableKeyboardLayoutInputSource()?.takeRetainedValue()
        let layoutDataPtr = TISGetInputSourceProperty(source, kTISPropertyUnicodeKeyLayoutData)
        let layoutData = Unmanaged<CFData>.fromOpaque(layoutDataPtr!).takeUnretainedValue() as Data
        let layoutPtr: UnsafePointer<UCKeyboardLayout> = layoutData.withUnsafeBytes { $0 }

        var deadKeys: UInt32 = 0
        let maxLength = 4
        var nameBuffer = [UniChar](repeating: 0, count : maxLength)
        var nameLength = 1

        let status = UCKeyTranslate(
            layoutPtr,
            self,
            UInt16(kUCKeyActionDisplay),
            UInt32(1 << 1), // Shift
            UInt32(LMGetKbdType()),
            OptionBits(kUCKeyTranslateNoDeadKeysBit),
            &deadKeys,
            maxLength,
            &nameLength,
            &nameBuffer
        )

        guard status == noErr else {
            return nil
        }

        return String(utf16CodeUnits: nameBuffer, count: nameLength)
    }
}
