//
//  LoginViewController.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-03.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        ServiceLayer.loginUser("brandon@plasticmobile.com", password: "developer") { (json, error) in
            print("JSON: \(json) -- error: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}