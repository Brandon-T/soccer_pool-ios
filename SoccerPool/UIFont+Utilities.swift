//
//  UIFont+Utilities.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-09.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation

extension UIFont {
    class func semiBoldSystemFont(fontSize: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFontOfSize(fontSize, weight: UIFontWeightSemibold)
        }
        
        return UIFont(name: "HelveticaNeue-Medium", size: fontSize)!
    }
}