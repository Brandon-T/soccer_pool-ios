//
//  TeamDetailsViewController.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-12.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation

class TeamDetailsViewController : UITableViewController {
    
    var flag: String?
    var country: String?
    var players: [FootballPlayer]?
    
    override func viewDidLoad() {
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "IntroBackground"))
        
        self.tableView.registerNib(UINib(nibName: "TeamFlagTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamFlagTableViewCell")
        self.tableView.registerNib(UINib(nibName: "TeamTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamTableViewCell")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players != nil ? players!.count : 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150.0
        }
        
        return 200.0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let player = players![indexPath.row]
        
        var cell: UITableViewCell!
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("TeamFlagTableViewCell", forIndexPath: indexPath)
            
            if let cell = cell as? TeamFlagTableViewCell {
                cell.flagView?.loadImage(self.flag)
                cell.countryName.text = self.country
            }
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("TeamTableViewCell", forIndexPath: indexPath)
            
            if let cell = cell as? TeamTableViewCell {
                cell.photoView.loadImage(player.image)
                cell.nameLabel.text = "Name: \(player.name ?? "N/A")"
                cell.positionLabel.text = "Position: \(player.position ?? "N/A")"
                cell.dateOfBirthLabel.text = "Date of Birth: \(player.birth_date ?? "N/A")"
                cell.weightLabel.text = "Weight: \(player.weight != nil ? "\(player.weight!)kg" : "N/A")"
                cell.heightLabel.text = "Height: \(player.height != nil ? "\(player.height!)cm" : "N/A")"
                cell.goalsLabel.text = "Goals: \(player.goals ?? 0)"
                cell.jerseyNumberLabel.text = "Jersey Number: \(player.jersey_number ?? "N/A")"
            }
        }
        
        return cell
    }
}