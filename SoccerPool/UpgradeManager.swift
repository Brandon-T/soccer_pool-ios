//
//  UpgradeManager.swift
//  SoccerPool
//
//  Created by Brandon Anthony on 2016-06-10.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import SCLAlertView

class UpgradeManager {
    static var shouldShowUpgrade: Bool = true
    
    static let currentVersion: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    static let currentVersionURL: String = NSBundle.mainBundle().objectForInfoDictionaryKey("XIO.SoccerPool.CurrentVersion.URL") as! String
    static let upgradingURL: String = NSBundle.mainBundle().objectForInfoDictionaryKey("XIO.SoccerPool.Upgrade.URL") as! String
    
    static func checkForLatestVersion() {
        if !ServiceLayer.isNetworkReachable() {
            SCLAlertView().showInfo("Error", subTitle: "Network Connection Unavailable", circleIconImage: UIImage(named: "EuroCupIcon"))
            return
        }
        
        if !shouldShowUpgrade {
            return
        }
        
        shouldShowUpgrade = false
        
        let plist = NSDictionary(contentsOfURL: NSURL(string: currentVersionURL)!) as? Dictionary<String, AnyObject>
        
        if let latestVersionPlist = plist {
            if let items = latestVersionPlist["items"] as? Array<Dictionary<String, AnyObject>> {
                for item in items {
                    if let metadata = item["metadata"] as? Dictionary<String, AnyObject> {
                        
                        if let latestVersion = metadata["bundle-version"] as? String {
                            if shortenedVersionNumber(currentVersion).compare(shortenedVersionNumber(latestVersion), options: .NumericSearch) == .OrderedAscending {
                                
                                let appearance = SCLAlertView.SCLAppearance(
                                    kTitleFont: UIFont.semiBoldSystemFont(18),
                                    kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                                    kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                                    showCloseButton: false
                                )
                                
                                let alert: SCLAlertView = SCLAlertView(appearance: appearance)
                                
                                alert.addButton("Yes", action: {
                                    shouldShowUpgrade = true
                                    UIApplication.sharedApplication().openURL(NSURL(string: upgradingURL)!)
                                    exit(EXIT_SUCCESS)
                                })
                                
                                alert.addButton("No", action: {
                                    shouldShowUpgrade = false
                                })
                                
                                alert.showInfo("New Version Available", subTitle: "\nWould you like to download it now?\n", closeButtonTitle: nil, colorStyle: 0x3F51B5, colorTextButton: 0xFFFFFF, circleIconImage: UIImage(named: "EuroCupIcon"))
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func shortenedVersionNumber(version: String) -> String {
        let suffix = ".0"
        var version = version
        
        while version.hasSuffix(suffix) {
            let index = version.characters.count - suffix.characters.count
            version = version.substringToIndex(version.startIndex.advancedBy(index))
        }
        return version
    }
}