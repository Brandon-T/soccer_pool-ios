//
//  LoginFieldsView.swift
//  SoccerPool
//
//  Created by Soner Yuksel on 2016-06-05.
//  Copyright © 2016 XIO. All rights reserved.
//

import UIKit
import SCLAlertView


protocol LoginFieldsViewDelegate: class {
    func didEnterPoolPressed(sender: AnyObject, name: String, password: String)
}

class LoginFieldsView: UIView, UITextFieldDelegate{

    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterPoolButton: UIButton!
    
    
    var delegate: LoginFieldsViewDelegate?
    var errorMessage: String?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.initControllers()
        self.setTheme()
        self.doLayout()
    }
    
    func initControllers() -> Void {
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func setTheme() -> Void {
    
        self.backgroundColor = UIColor.loginFieldViewBackgroundColor()
        self.alpha = 0.8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.emailTextField.placeholder = "Enter Plastic Email"
        self.passwordTextField.placeholder = "Set Password"
        self.emailTextField.returnKeyType = .Next
        self.passwordTextField.returnKeyType = .Default
        
        self.emailTextField.autocapitalizationType = .None
        self.emailTextField.autocorrectionType = .No
        self.emailTextField.spellCheckingType = .No
        self.emailTextField.keyboardType = .EmailAddress

        self.passwordTextField.autocapitalizationType = .None
        self.passwordTextField.autocorrectionType = .No
        self.passwordTextField.spellCheckingType = .No
        self.passwordTextField.keyboardType = .EmailAddress
        
        self.passwordTextField.secureTextEntry = true
    }
    
    func doLayout() -> Void {
        
    }
    
    func validateTextFields() -> Bool {
     
        if let name = self.emailTextField?.text , password = self.passwordTextField.text{

            if name.characters.count == 0 {
                errorMessage = "Please enter your Plastic Email"
                self.passwordTextField.text = ""
                return false
            }
            
            if password.characters.count == 0 {
                errorMessage = "Please enter a password"
                return false
            }
         
        }
        
        return true
    }
    
    
    // MARK: LOGIN DELEGATES
    
    @IBAction func enterPoolButtonPressed(sender: AnyObject) {
        if let name = emailTextField?.text , password = passwordTextField.text{
            if validateTextFields(){
                delegate?.didEnterPoolPressed(self, name: name, password: password)
            }
            else{
                if let error = errorMessage{
                    SCLAlertView().showInfo("Error", subTitle: error, circleIconImage: UIImage(named: "EuroCupIcon"))
                    self.emailTextField.resignFirstResponder()
                    self.passwordTextField.resignFirstResponder()

                }
            }
        }
    }
    
    // MARK: LOGIN DELEGATES
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        return true
    }
    
}