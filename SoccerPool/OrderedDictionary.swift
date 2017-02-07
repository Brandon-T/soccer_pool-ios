//
//  OrderedDictionary.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-07.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation

class OrderedDictionary<Key: Hashable, Value> : DictionaryLiteralConvertible {
    var keys = Array<Key>()
    var values = Dictionary<Key, Value>()
    
    required init(dictionaryLiteral elements: (Key, Value)...) {
        for element in elements {
            self[element.0] = element.1
        }
    }
    
    var count: Int {
        assert(keys.count == values.count, "The number of Keys is different from the number of values")
        return self.keys.count;
    }
    
    subscript(index: Int) -> Value? {
        get {
            if index < self.keys.count {
                return self.values[self.keys[index]]
            }
            return nil
        }
        
        set(newValue) {
            let key = self.keys[index]
            if newValue != nil {
                self.values[key] = newValue
            }
            else {
                self.values.removeValueForKey(key)
                self.keys.removeAtIndex(index)
            }
        }
    }
    
    subscript(key: Key) -> Value? {
        get {
            return self.values[key]
        }
        set(newValue) {
            if newValue == nil {
                self.values.removeValueForKey(key)
                self.keys = self.keys.filter {$0 != key}
            } else {
                let oldValue = self.values.updateValue(newValue!, forKey: key)
                if oldValue == nil {
                    self.keys.append(key)
                }
            }
        }
    }
    
    func removeAll() -> Void {
        self.keys.removeAll()
        self.values.removeAll()
    }
}