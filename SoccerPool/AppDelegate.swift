//
//  AppDelegate.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-03.
//  Copyright © 2016 XIO. All rights reserved.
//

import UIKit
import MagicalRecord

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
        /*let notification = UILocalNotification()
        notification.repeatInterval = NSCalendarUnit(rawValue: 0)
        notification.alertBody = "Test"
        notification.fireDate = NSDate().dateByAddingTimeInterval(5)
        notification.timeZone = NSTimeZone.defaultTimeZone()
        application.scheduleLocalNotification(notification)*/
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
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
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

