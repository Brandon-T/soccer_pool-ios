//
//  BaseNavigationController.swift
//  SoccerPool
//
//  Created by Soner Yuksel on 2016-06-06.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import UIKit

class BaseNavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor.navigationBarBackgroundColor()
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}