//
//  BaseModel.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-06.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation

class BaseModel : NSObject, Serializeable {
    override var description: String {
        return "\(NSStringFromClass(self.dynamicType)): \(self.toJSON())"
    }
}