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

    typealias Item = StringEntity

    private let pasteboard: NSPasteboard
    private var timer: AnyCancellable?
    private var changeCount = -1
    var currentItem: StringEntity? = nil

    init(polling: TimeInterval = 5, pasteboard: NSPasteboard = .general) {
        self.pasteboard = pasteboard
        changeCount = pasteboard.changeCount
        if let string = pasteboard.string(forType: .string) {
            currentItem = StringEntity(string)
        }
        timer = Timer.publish(every: polling, on: .current, in: .default)
            .autoconnect()
            .compactMap { [weak self] _ in
                guard pasteboard.changeCount != self?.changeCount else {
                    return nil
                }
                guard pasteboard.availableType(from: [.string]) == .string else {
                    return nil
                }
                guard let string = pasteboard.string(forType: .string) else {
                    return nil
                }
                self?.changeCount = pasteboard.changeCount
                return StringEntity(string)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                self?.currentItem = item
            }
    }

    deinit {
        timer?.cancel()
    }

    func placeItem(_ item: Item) {
        pasteboard.declareTypes([.string], owner: self)
        pasteboard.setString(item.value, forType: .string)
    }
}
