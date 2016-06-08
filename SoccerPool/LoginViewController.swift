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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)

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
    
    
    func keyboardWillShow(notification: NSNotification) {
        let beginFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        let endFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        let curveInfo = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UIViewAnimationCurve
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval
        
        if let keyboardSize = endFrame {
            UIView.animateWithDuration(duration!, animations: {
                self.view.frame.origin.y -= keyboardSize.height
            })
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let beginFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        let endFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        let curveInfo = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UIViewAnimationCurve
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval
        
        if let keyboardSize = endFrame {
            self.view.layoutIfNeeded()
            
            UIView.animateWithDuration(0, animations: { 
                self.view.frame.origin.y += keyboardSize.height
            })
            
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}