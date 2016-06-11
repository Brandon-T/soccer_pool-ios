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
                let currentDateTime = NSDate()
                
                for game in games {
                    let startTime = game.startTime!
                    let endTime = startTime.dateByAddingTimeInterval(2 * 60 * 60)
                    
                    //currentDateTime < startTime
                    if currentDateTime.compare(startTime) == .OrderedDescending {
                        if currentDateTime.compare(endTime) == .OrderedAscending {
                            self.inProgressGames.append(game)
                        }
                        else {
                            self.completedGames.append(game)
                        }
                    }
                    else {
                        self.upcomingGames.append(game)
                    }
                }

                self.upcomingGames.sortInPlace({ (first, second) -> Bool in
                    return first.startTime!.compare(second.startTime!) == .OrderedAscending
                })
                
                self.inProgressGames.sortInPlace({ (first, second) -> Bool in
                    return first.startTime!.compare(second.startTime!) == .OrderedAscending
                })
                
                self.completedGames.sortInPlace({ (first, second) -> Bool in
                    return first.startTime!.compare(second.startTime!) == .OrderedAscending
                })
                
                self.tableView.reloadData()
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
                return self.inProgressGames.count > 0 ? self.inProgressGames.count : self.upcomingGames.count
            case 1:
                return self.inProgressGames.count > 0 ? self.upcomingGames.count : 1
            default:
                return self.completedGames.count
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
                label.text = self.inProgressGames.count > 0 ? "In progress Games" : "Upcoming Games"
            case 1:
                label.text = self.inProgressGames.count > 0 ? "Upcoming Games" : "In progress Games"
            default:
                label.text = "Completed"
        }
        
        view.addSubview(label)
        view.backgroundColor = UIColor.clearColor()
        
        return view
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.inProgressGames.count > 0 ? 141 : 130.0
        }
        
        if indexPath.section == 1 {
            return self.inProgressGames.count > 0 ? 130.0 : 44.0
        }
        
        return 141.0
    }
 
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case 0:
            if self.inProgressGames.count > 0 {
                cell = tableView.dequeueReusableCellWithIdentifier("FinishedMatchesCell", forIndexPath: indexPath) as! FinishedMatchesTableViewCell
                if let cell = cell as? FinishedMatchesTableViewCell {
                    let game = self.inProgressGames[indexPath.row]
                    
                    let secondsLeft = NSDate().timeIntervalSinceDate(game.startTime!);
                    let hours = secondsLeft / 3600;
                    let minutes = (secondsLeft % 3600) / 60;
                    let seconds = (secondsLeft % 3600) % 60;
                    let timeLeft = String.init(format: "%02zd:%02zd:%02zd", Int(hours), Int(minutes), Int(seconds))
                    
                    
                    cell.homeTeamNameLabel.text = game.homeTeam?.name
                    cell.awayTeamNameLabel.text = game.awayTeam?.name
                    cell.homeTeamFlagImageView.loadImage(game.homeTeam?.image)
                    cell.awayTeamFlagImageView.loadImage(game.awayTeam?.image)
                    cell.homeTeamScoreLabel.text = "\(game.hasBeenPredicted ? "\(game.prediction!.homeGoals)" : "-")"
                    cell.awayTeamScoreLabel.text = "\(game.hasBeenPredicted ? "\(game.prediction!.awayGoals)" : "-")"
                    cell.finalScoreLabel.text = "Current Score: \(game.homeGoals) - \(game.awayGoals)"
                    cell.cornerLabel.text = "+\(game.prediction!.points)"
                    cell.gameTimeLabel.text = "Playing Right Now! -- Time Left: \(timeLeft)"
                }
            }
            else {
                cell = tableView.dequeueReusableCellWithIdentifier("VoteMatchesCell", forIndexPath: indexPath)
                
                if let cell = cell as? VoteMatchesTableViewCell {
                    let game = self.upcomingGames[indexPath.row]
                    
                    cell.homeTeamNameLabel.text = game.homeTeam?.name
                    cell.awayTeamNameLabel.text = game.awayTeam?.name
                    cell.homeTeamFlagImageView.loadImage(game.homeTeam?.image)
                    cell.awayTeamFlagImageView.loadImage(game.awayTeam?.image)
                    cell.homeTeamScoreLabel.text = "\(game.hasBeenPredicted ? "\(game.prediction!.homeGoals)" : "-")"
                    cell.awayTeamScoreLabel.text = "\(game.hasBeenPredicted ? "\(game.prediction!.awayGoals)" : "-")"
                    cell.gameTimeLabel.text = game.startTime?.format("dd MMM yyyy, HH:mm")
                }
            }
        
        case 1:
            if self.inProgressGames.count > 0 {
                cell = tableView.dequeueReusableCellWithIdentifier("VoteMatchesCell", forIndexPath: indexPath)
                
                if let cell = cell as? VoteMatchesTableViewCell {
                    let game = self.upcomingGames[indexPath.row]
                    
                    cell.homeTeamNameLabel.text = game.homeTeam?.name
                    cell.awayTeamNameLabel.text = game.awayTeam?.name
                    cell.homeTeamFlagImageView.loadImage(game.homeTeam?.image)
                    cell.awayTeamFlagImageView.loadImage(game.awayTeam?.image)
                    cell.homeTeamScoreLabel.text = "\(game.hasBeenPredicted ? "\(game.prediction!.homeGoals)" : "-")"
                    cell.awayTeamScoreLabel.text = "\(game.hasBeenPredicted ? "\(game.prediction!.awayGoals)" : "-")"
                    cell.gameTimeLabel.text = game.startTime?.format("dd MMM yyyy, HH:mm")
                }
            }
            else {
                cell = tableView.dequeueReusableCellWithIdentifier("NoMatchesCell", forIndexPath: indexPath) as! NoMatchesTableViewCell
            }
            
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("FinishedMatchesCell", forIndexPath: indexPath) as! FinishedMatchesTableViewCell
            if let cell = cell as? FinishedMatchesTableViewCell {
                let game = self.completedGames[indexPath.row]
                
                cell.homeTeamNameLabel.text = game.homeTeam?.name
                cell.awayTeamNameLabel.text = game.awayTeam?.name
                cell.homeTeamFlagImageView.loadImage(game.homeTeam?.image)
                cell.awayTeamFlagImageView.loadImage(game.awayTeam?.image)
                cell.homeTeamScoreLabel.text = "\(game.hasBeenPredicted ? "\(game.prediction!.homeGoals)" : "-")"
                cell.awayTeamScoreLabel.text = "\(game.hasBeenPredicted ? "\(game.prediction!.awayGoals)" : "-")"
                cell.finalScoreLabel.text = "Final Score: \(game.homeGoals) - \(game.awayGoals)"
                cell.cornerLabel.text = "+\(game.prediction!.points)"
                cell.gameTimeLabel.text = "Completed On:   \(game.startTime!.dateByAddingTimeInterval(2 * 60 * 60).format("dd MMM yyyy, HH:mm"))"
            }
        }
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == (self.inProgressGames.count > 0 ? 1 : 0) {
            
            let game = self.upcomingGames[indexPath.row]
            let homeGoalsPrediction = game.prediction != nil ? game.prediction!.homeGoals : 0
            let awayGoalsPrediction = game.prediction != nil ? game.prediction!.awayGoals : 0
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont.semiBoldSystemFont(18),
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                showCloseButton: false
            )
            
            let alert: SCLAlertView = SCLAlertView(appearance: appearance)

            let subView = BetDialogView(frame: CGRectMake(0, 0, 215, 135))
            subView.homeTeamNameLabel.text = game.homeTeam?.name
            subView.homeTeamFlagView.loadImage(game.homeTeam?.image)
            subView.homeTeamScoreLabel.text = "\(homeGoalsPrediction)"
            
            subView.awayTeamNameLabel.text = game.awayTeam?.name
            subView.awayTeamFlagView.loadImage(game.awayTeam?.image)
            subView.awayTeamScoreLabel.text = "\(awayGoalsPrediction)"

            // Add the subview to the alert's UI property
            alert.customSubview = subView
            
            alert.addButton("Submit") {
                let homeGoals: UInt! = UInt(subView.homeTeamScoreLabel.text ?? "0")
                let awayGoals: UInt! = UInt(subView.awayTeamScoreLabel.text ?? "0")
                
                ServiceLayer.predictGame(game.gameID, awayGoals: awayGoals, homeGoals: homeGoals, completion: { (json, error) in
                    
                    guard error == nil else {
                        SCLAlertView().showInfo("Error", subTitle: error!.localizedDescription, circleIconImage: UIImage(named: "EuroCupIcon"))
                        return
                    }
                    
                    game.hasBeenPredicted = true
                    game.prediction!.homeGoals = homeGoals
                    game.prediction!.awayGoals = awayGoals
                    
                    alert.hideView()
                    tableView.reloadData()
                })
            }
            alert.addButton("Cancel", backgroundColor: UIColor.navigationBarBackgroundColor(), textColor: UIColor.whiteColor(), showDurationStatus: false) {
                alert.hideView()
                tableView.reloadData()
            }
            
            alert.showInfo("Place Bet", subTitle: "", circleIconImage: UIImage(named: "EuroCupIcon"))
        }
    }
}