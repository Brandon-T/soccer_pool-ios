//
//  Double+Utilities.swift
//  SoccerPool
//
//  Created by Brandon Anthony on 2016-06-11.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation

extension Double {
    func equals(other: Double) -> Bool {
        return fabs(self - other) < Double(FLT_EPSILON)
    }
}