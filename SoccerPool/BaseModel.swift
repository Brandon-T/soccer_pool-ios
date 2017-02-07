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
        return "\(self.toJSON())"
    }
    
    override var debugDescription: String {
        return "\(self.toJSON())"
    }
}

extension Array {
    var description: String {
        let array = self.map { String($0) }
        return array.joinWithSeparator(", ")
    }
}

extension Dictionary {
    var description: String {
        let array = Array(self.map { "{" + String($0) + ": " + String($1) + "}" })
        return array.joinWithSeparator(",\n")
    }
}