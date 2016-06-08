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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControls()
        self.setTheme()
        self.doLayout()
    }
    
    func initControls() -> Void {
        loginFieldsView.delegate = self
    }
    
    func setTheme() -> Void {
        
    }
    
    func doLayout() -> Void {
        
    }
    
    func didEnterPoolPressed(sender: AnyObject, name: String, password: String) {
        ServiceLayer.loginUser(name, password: password) { (json, error) in
            if error != nil {
                if error!.code == 2 { //Account not registered..
                    ServiceLayer.registerUser(name, password: password, completion: { (json, error) in
                        print(json)

                        if error != nil {
                            SCLAlertView().showInfo("Error", subTitle: error!.localizedDescription, circleIconImage: UIImage(named: "EuroCupIcon"))
                        }
                        else {
                            self.performSegueWithIdentifier("segueSuccessfulLogin", sender: nil)
                        }
                    })
                    return
                }
                
                SCLAlertView().showInfo("Error", subTitle: error!.localizedDescription, circleIconImage: UIImage(named: "EuroCupIcon"))
            }
            else {
                self.performSegueWithIdentifier("segueSuccessfulLogin", sender: nil)
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}