//
//  DynamicValue.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

class DynamicValue<T> {
    typealias CompletionHandler = ((T) -> Void)
    var value: T {
        didSet {
            notify()
        }
    }
    private var observers = [String: CompletionHandler]()
    init(_ value: T) {
        self.value = value
    }
    func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }
    func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        addObserver(observer, completionHandler: completionHandler)
        notify()
    }
    private func notify() {
        observers.forEach({ $0.value(value) })
    }
    deinit {
        observers.removeAll()
    }
}
