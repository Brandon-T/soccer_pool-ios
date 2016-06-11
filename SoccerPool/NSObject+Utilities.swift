//
//  NSObject+Utilities.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-08.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation


//Object Association.

final class GenericWrapper<T> {
    let value: T
    init(_ val: T) {
        value = val
    }
}

extension NSObject {
    private struct Association {
        static var associatedKey: Int = 0
    }
    
    func getObject<T>() -> T? {
        if let object = objc_getAssociatedObject(self, &Association.associatedKey) as? T {
            return object
        }
        else if let object = objc_getAssociatedObject(self, &Association.associatedKey) as? GenericWrapper<T> {
            return object.value
        }
        else {
            return nil
        }
    }
    
    func setObject<T>(object: T, policy: objc_AssociationPolicy) -> Void {
        if let object = object as? AnyObject {
            objc_setAssociatedObject(self, &Association.associatedKey, object,  policy)
        }
        else {
            objc_setAssociatedObject(self, &Association.associatedKey, GenericWrapper(object),  policy)
        }
    }
    
    func removeObject() -> Void {
        objc_setAssociatedObject(self, &Association.associatedKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    
    func getObject<T>(key: String) -> T? {
        let data: [String: AnyObject]? = self.getObject()
        
        if let object = data?[key] as? T {
            return object
        }
        else if let object = data?[key] as? GenericWrapper<T> {
            return object.value
        }
        return nil
    }
    
    func setObject<T>(object: T, key: String, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) -> Void {
        var data: [String: AnyObject] = self.getObject() ?? [String: AnyObject]()
        data[key] = object as? AnyObject ?? GenericWrapper<T>(object)
        self.setObject(data, policy: policy)
    }
    
    func removeObject(key: String, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) -> Void {
        var data: [String: AnyObject] = self.getObject() ?? [String: AnyObject]()
        data.removeValueForKey(key)
        self.setObject(data, policy: policy)
    }
}