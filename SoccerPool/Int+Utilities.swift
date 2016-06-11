//
//  Int+Utilities.swift
//  SoccerPool
//
//  Created by Brandon Anthony on 2016-06-11.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation


extension Int {
    func toString(decimalPlaces: Int) -> String {
        return String.init(format: "%.\(decimalPlaces)zd", self)
    }
}