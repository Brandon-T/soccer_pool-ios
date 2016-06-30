//
//  AppDelegate.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-03.
//  Copyright © 2016 XIO. All rights reserved.
//

import UIKit
import MagicalRecord
import SCLAlertView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed("SoccerPool.sqlite")
        
        if ServiceLayer.isLoggedIn() {
            self.window = UIWindow()
            self.window?.rootViewController = UIStoryboard(name: "SoccerPool", bundle: nil).instantiateViewControllerWithIdentifier("mainViewController")
            self.window?.makeKeyAndVisible()
        }
        else {
            self.window = UIWindow()
            self.window?.rootViewController = UIStoryboard(name: "SoccerPool", bundle: nil).instantiateInitialViewController()
            self.window?.makeKeyAndVisible()
        }
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        //For Testing Notifications.
        
        /*let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) { 

            let times = [1.0, 2.0, 3.0]  //Seconds..
            
            for time in times {
                let notification = UILocalNotification()
                if #available(iOS 8.2, *) {
                    notification.alertTitle = "Upcoming Game: Italy vs. Germany"
                    notification.alertBody = "You have not placed a bet on this game yet."
                } else {
                    notification.alertBody = "Upcoming Game: Italy vs. Germany. Last chance to place your bet!"
                }
                
                notification.repeatInterval = NSCalendarUnit(rawValue: 0)
                notification.fireDate = NSDate().dateByAddingTimeInterval(time * 1.0)
                notification.timeZone = NSTimeZone.localTimeZone()
                notification.applicationIconBadgeNumber = 1
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.alertAction = "View"
                
                notification.userInfo = ["gameID": "1024", "homeTeamName": "France", "awayTeamName": "Romania", "homeTeamImage": "http://104.131.118.14/images/France.png", "awayTeamImage": "http://104.131.118.14/images/Romania.png"]
                
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
        }*/
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if let userInfo = notification.userInfo, currentGameId = userInfo["gameID"] as? String, homeTeamName = userInfo["homeTeamName"] as? String, awayTeamName = userInfo["awayTeamName"] as? String {
            
            if let notifications = application.scheduledLocalNotifications {
                for notification in notifications {
                    if let info = notification.userInfo, otherGameId = info["gameID"] as? String {
                        if currentGameId == otherGameId {
                            application.cancelLocalNotification(notification)
                        }
                    }
                }
            }
            
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont.semiBoldSystemFont(18),
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                showCloseButton: false
            )
            
            let alert: SCLAlertView = SCLAlertView(appearance: appearance)
            
            if let homeTeamImage = userInfo["homeTeamImage"] as? String, awayTeamImage = userInfo["awayTeamImage"] as? String {
                let subView = BetDialogView(frame: CGRectMake(0, 0, 215, 140))
                subView.homeTeamNameLabel.text = homeTeamName
                subView.homeTeamFlagView.loadImage(homeTeamImage)
                subView.homeTeamScoreLabel.hidden = true
                
                subView.awayTeamNameLabel.text = awayTeamName
                subView.awayTeamFlagView.loadImage(awayTeamImage)
                subView.awayTeamScoreLabel.hidden = true
                
                subView.notificationLabel.text = "Will be taking place soon. Don't miss the chance to place your bet!"
                subView.notificationLabel.hidden = false
                
                alert.customSubview = subView
            }
            
            alert.addButton("OK", action: {
                alert.hideView()
            })
            
            alert.showInfo("Upcoming Game", subTitle: "\n\(homeTeamName) vs. \(awayTeamName) will be taking place soon. Don't miss the opportunity to place your bet!\n", closeButtonTitle: nil, colorStyle: 0x3F51B5, colorTextButton: 0xFFFFFF, circleIconImage: UIImage(named: "EuroCupIcon"))
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        UpgradeManager.shouldShowUpgrade = true
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        UpgradeManager.checkForLatestVersion()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    /*func application(application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect) {
        if let root = application.keyWindow?.rootViewController as? UITabBarController, let nav = root.selectedViewController as? BaseNavigationController {
            nav.setNavigationBarHidden(true, animated: true)
            nav.setNavigationBarHidden(false, animated: true)
        }
    }*/
}

