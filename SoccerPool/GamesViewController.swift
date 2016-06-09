//
//  GamesViewController.swift
//  SoccerPool
//
//  Created by Soner Yuksel on 2016-06-06.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

class GamesViewController : UITableViewController {
    
    var upcomingGames = [Game]()
    var inProgressGames = [Game]()
    var completedGames = [Game]()
    
    let currentDateTime = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initControllers()
        self.setTheme()
        self.registerClasses()
        self.doLayout()
  
        
        ServiceLayer.getGames { [unowned self](json, error) in
            guard error == nil else {
                return
            }
            if let gamesArray = json?["data"] as? [[String: AnyObject]] {
                let games = Game.fromJSONArray(gamesArray) as! [Game]
                
                for game in games {
                    let startTime = game.startTime!
                    let endTime = startTime.dateByAddingTimeInterval(2 * 60 * 60)
                    
                    //startTime <= currentDateTime
                    if self.currentDateTime.compare(startTime) == .OrderedAscending || self.currentDateTime.compare(startTime) == .OrderedSame {
                        self.completedGames.append(game)
                    }
                    else if self.currentDateTime.compare(endTime) == .OrderedSame {
                        self.completedGames.append(game)
                    }
                    else if self.currentDateTime.compare(endTime) == .OrderedDescending {
                        self.upcomingGames.append(game)
                    }
                    else {
                        //startTime < currentDateTime < endTime
                        if self.currentDateTime.compare(startTime) == .OrderedDescending && self.currentDateTime.compare(endTime) == .OrderedAscending {
                            self.inProgressGames.append(game)
                        }
                    }
                }

                print("Sasaas")
                
            }
        }
    }
    
    func initControllers() -> Void {
        
        let titleCupView = TitleView(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
        titleCupView.titleLabel.text = "Cup"        
        navigationItem.titleView = titleCupView

        let rightInformationBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "InformationBarButtonItem"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(informationBarButtonPressed))
        
        let rightLogoutBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "LogoutBarButtonItem"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(logoutBarButtonPressed))
    
        self.navigationItem.setRightBarButtonItems([rightLogoutBarButtonItem,rightInformationBarButtonItem], animated: true)
        
    }
    
    func setTheme() -> Void {
        let backgroundImageView = UIImageView(image: UIImage(named: "IntroBackground"))
        backgroundImageView.frame = self.tableView.frame
        self.tableView.backgroundView = backgroundImageView;
        
    }
    
    func registerClasses() -> Void {

        self.tableView.registerNib(UINib(nibName: "NoMatchesTableViewCell", bundle: nil), forCellReuseIdentifier: "NoMatchesCell")
        self.tableView.registerNib(UINib(nibName: "VoteMatchesTableViewCell", bundle: nil), forCellReuseIdentifier: "VoteMatchesCell")
        self.tableView.registerNib(UINib(nibName: "FinishedMatchesTableViewCell", bundle: nil), forCellReuseIdentifier: "FinishedMatchesCell")
        
    }
    
    func doLayout() -> Void {
        
    }
    
    // MARK: - BAR BUTTON ITEM ACTIONS
    
    @IBAction func logoutBarButtonPressed(sender: AnyObject) {
        ServiceLayer.logoutUser()
        
        let storyboard = UIStoryboard(name: "SoccerPool", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("loginViewController")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func informationBarButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("segueHelp", sender: nil)

    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 2
            case 1:
                return 1
            default:
                return 2
        }
    }

    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 44))
        let label = UILabel(frame: CGRectMake(0, 0, tableView.frame.size.width, 44))
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(17)
        label.textColor = UIColor.whiteColor()
        
        switch section {
            case 0:
                label.text = "Upcoming Games"
            case 1:
                label.text = "In progress Games"
            default:
                label.text = "Completed"
        }
        
        view.addSubview(label)
        view.backgroundColor = UIColor.clearColor()
        
        return view
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        if(indexPath.section == 1){
            return 44.0
        }
        else{
            return 100.0
        }
  
    }
 
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let section = indexPath.section
        var cell = UITableViewCell()
        
        switch section {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("VoteMatchesCell", forIndexPath: indexPath)
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("NoMatchesCell", forIndexPath: indexPath)
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("FinishedMatchesCell", forIndexPath: indexPath)

        }
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        print(indexPath.row)
        
        if indexPath.section == 0{
        
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont.systemFontOfSize(18, weight: UIFontWeightSemibold),
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                showCloseButton: false
            )
            
            let alert: SCLAlertView = SCLAlertView(appearance: appearance)

            let subView = BetDialogView(frame: CGRectMake(0,0,215,135))

            // Add the subview to the alert's UI property
            alert.customSubview = subView
            
            alert.addButton("Submit") {
                print("Submit The Score")
            }
            alert.addButton("Cancel", backgroundColor: UIColor.navigationBarBackgroundColor(), textColor: UIColor.whiteColor(), showDurationStatus: false) {
                alert.hideView()
            }
            
            alert.showInfo("Place Bet", subTitle: "", circleIconImage: UIImage(named: "EuroCupIcon"))
            
        }
        
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
}