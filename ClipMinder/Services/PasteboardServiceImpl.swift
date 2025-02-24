//
//  PasteboardServiceImpl.swift
//  ClipMinder
//
//  Created by Grigory Avdyushin   on 18/02/2025.
//

import Combine
import SwiftUI

@Observable
final class PasteboardServiceImpl: PasteboardService {

    typealias Item = String

    private let pasteboard: NSPasteboard
    private var timer: AnyCancellable?
    private var changeCount = -1
    var currentItem: String? = nil

    init(polling: TimeInterval = 5, pasteboard: NSPasteboard = .general) {
        self.pasteboard = pasteboard
        changeCount = pasteboard.changeCount
        currentItem = "Foo"
        timer = Timer.publish(every: polling, on: .current, in: .default)
            .autoconnect()
            .compactMap { [weak self] _ in
                guard pasteboard.changeCount != self?.changeCount else {
                    debugPrint("Same change count", pasteboard.changeCount)
                    return nil
                }
                guard pasteboard.availableType(from: [.string]) == .string else {
                    debugPrint("No string avaialble")
                    return nil
                }
                guard let string = pasteboard.string(forType: .string) else {
                    debugPrint("No string fetched")
                    return nil
                }
                self?.changeCount = pasteboard.changeCount
                return string
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.currentItem = item
            }
    }

    deinit {
        timer?.cancel()
    }

    func placeItem(_ item: String) {
        pasteboard.declareTypes([.string], owner: self)
        pasteboard.setString(item, forType: .string)
    }
}
