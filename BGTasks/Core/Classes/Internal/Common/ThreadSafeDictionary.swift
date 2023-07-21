//
//  ThreadSafeDictionary.swift
//  BGFramework
//
//  Created by Shridhara V on 31/05/21.
//

import Foundation

final class ThreadSafeDictionary<Key: Hashable, Value> {
    
    private var dictionary: [Key: Value]
    private let queue = DispatchQueue(label: "com.phonepe.thread.safe.dictionary.queue", attributes: .concurrent)
    
    init(_ initialValue: [Key: Value] = [:]) {
        self.dictionary = initialValue
    }
    
    subscript(_ key: Key) -> Value? {
        get {
            var value: Value?
            queue.sync {
                value = dictionary[key]
            }
            return value
        }
        set {
            queue.async(flags: .barrier) {
                self.update(key, value: newValue)
            }
        }
    }
    
    var allValues: [Value] {
        return queue.sync {
            return Array(dictionary.values)
        }
    }
    
    private func update(_ key: Key, value: Value?) {
        self.dictionary[key] = value
    }
    
    func getUnsafeDictionary() -> [Key: Value] {
        var dict = [Key: Value]()
        queue.sync {
            dict = self.dictionary
        }
        return dict
    }
}
