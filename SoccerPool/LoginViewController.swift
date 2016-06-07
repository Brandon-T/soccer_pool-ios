//
//  LoginViewController.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-03.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

class LoginViewController : BaseViewController, LoginFieldsViewDelegate {
    
    @IBOutlet weak var loginFieldsView: LoginFieldsView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControllers()
        self.setTheme()
        self.doLayout()
    }
    
    func initControllers() -> Void {
        
        loginFieldsView.delegate = self
    }
    
    func setTheme() -> Void {
        
    }
    
    func doLayout() -> Void {
        
    }
    
    func didEnterPoolPressed(sender: AnyObject, name: String, password: String){
        
        ServiceLayer.loginUser(name, password: password) { (json, error) in
            print(json)
            
            let success = json?["success"] as! Int
            let data = json?["errorMessage"] as! String
            
            if success == 0 {
                if (json?["errorCode"]) != nil {
                    ServiceLayer.registerUser(name, password: password, completion: { (json, error) in
                        print(json)
                        
                        let success = json?["success"] as! Int
                        let data = json?["errorMessage"] as! String
                        
                        if success == 0 {
                            SCLAlertView().showInfo("Error", subTitle: data, circleIconImage: UIImage(named: "EuroCupIcon"))
                        }
                        else{
                            self.performSegueWithIdentifier("segueSuccessfulLogin", sender: nil)
                        }
                    })
                    return
                }
                
                SCLAlertView().showInfo("Error", subTitle: data, circleIconImage: UIImage(named: "EuroCupIcon"))
            }
            else{
                self.performSegueWithIdentifier("segueSuccessfulLogin", sender: nil)
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}