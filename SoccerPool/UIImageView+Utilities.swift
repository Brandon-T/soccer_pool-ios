//
//  UIImageView+Utilities.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-09.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(url: String?, placeHolder: String? = nil) -> Void {
        guard let url = url else {
            self.image = placeHolder != nil ? UIImage(named: placeHolder!) : nil
            return
        }
        
        ServiceLayer.getImage(url) { [unowned self](image, error) in
            guard error == nil else {
                self.image = placeHolder != nil ? UIImage(named: placeHolder!) : nil
                return
            }
            
            guard let image = image else {
                self.image = placeHolder != nil ? UIImage(named: placeHolder!) : nil
                return
            }
            
            self.image = image
        }
    }
}