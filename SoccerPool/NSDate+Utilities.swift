//
//  NSDate+Utilities.swift
//  SoccerPool
//
//  Created by Brandon Anthony on 2016-06-09.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation

extension NSDate {
    func format(format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
}