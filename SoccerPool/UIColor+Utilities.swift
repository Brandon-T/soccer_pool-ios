//
//  UIColor+Utilities.swift
//  SoccerPool
//
//  Created by Soner Yuksel on 2016-06-05.
//  Copyright © 2016 XIO. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int, opacity: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xff) / 255
        let green = CGFloat((hex >> 08) & 0xff) / 255
        let blue = CGFloat((hex >> 00) & 0xff) / 255
        self.init(red: red, green: green, blue: blue, alpha: opacity)
    }
    
    // MARK: - Backgrounds
    
    static func loginFieldViewBackgroundColor() -> UIColor {
        return UIColor(hex: 0xDADADA)
    }
    
    // MARK: - Navigation Bar Background
    
    static func navigationBarBackgroundColor() -> UIColor {
        return UIColor(hex: 0x3F51B5)
    }
}
