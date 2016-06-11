//
//  UIView+Utilities.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-08.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import UIKit

//Keyboard Adjuster

extension UIView {
    
    enum KeyboardAdjuster : String {
        case TapGestureRecognizerKey
        case DidAdjustFrameKey
        case OriginalAdjusterFrameKey
    }
    
    
    func startKeyboardListener() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func stopKeyboardListener() -> Void {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func setTapOutsideAdjuster(enabled: Bool) -> Void {
        let tapGestureRecognizer: UITapGestureRecognizer? = self.getObject(KeyboardAdjuster.TapGestureRecognizerKey.rawValue)
        
        if enabled {
            if tapGestureRecognizer == nil {
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapOutside))
                gestureRecognizer.numberOfTapsRequired = 1
                
                self.addGestureRecognizer(gestureRecognizer)
                self.setObject(gestureRecognizer, key: KeyboardAdjuster.TapGestureRecognizerKey.rawValue)
            }
        }
        else {
            if tapGestureRecognizer != nil {
                self.removeGestureRecognizer(tapGestureRecognizer!)
                self.removeObject(KeyboardAdjuster.TapGestureRecognizerKey.rawValue)
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) -> Void {
        let didAdjustFrame: Bool = self.getObject(KeyboardAdjuster.DidAdjustFrameKey.rawValue) ?? false
        
        if !didAdjustFrame {
            self.setObject(self.frame, key: KeyboardAdjuster.OriginalAdjusterFrameKey.rawValue)
        }
        
        self.setObject(true, key: KeyboardAdjuster.DidAdjustFrameKey.rawValue)
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let curveInfo = UIViewAnimationCurve(rawValue: notification.userInfo![UIKeyboardAnimationCurveUserInfoKey]!.integerValue)!
        let duration = NSTimeInterval(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationCurve(curveInfo)
        UIView.setAnimationDuration(duration)
        
        self.frame = self.getObject(KeyboardAdjuster.OriginalAdjusterFrameKey.rawValue)!
        self.frame.origin.y -= endFrame.size.height
        
        UIView.commitAnimations()
    }
    
    func keyboardWillHide(notification: NSNotification) -> Void {
        let didAdjustFrame: Bool = self.getObject(KeyboardAdjuster.DidAdjustFrameKey.rawValue) ?? false
        
        if didAdjustFrame {
            self.setObject(false, key: KeyboardAdjuster.DidAdjustFrameKey.rawValue)
            let curveInfo = UIViewAnimationCurve(rawValue: notification.userInfo![UIKeyboardAnimationCurveUserInfoKey]!.integerValue)!
            let duration = NSTimeInterval(notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue)
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationCurve(curveInfo)
            UIView.setAnimationDuration(duration)
            
            self.frame = self.getObject(KeyboardAdjuster.OriginalAdjusterFrameKey.rawValue)!
            
            UIView.commitAnimations()
        }
    }
    
    func onTapOutside(gestureRecognizer: UITapGestureRecognizer) {
        self.resignFirstResponder()
        self.endEditing(true)
    }
}