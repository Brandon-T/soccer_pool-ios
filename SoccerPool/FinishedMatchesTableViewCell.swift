//
//  VoteMatchesTableViewCell.swift
//  SoccerPool
//
//  Created by Soner Yuksel on 2016-06-08.
//  Copyright © 2016 XIO. All rights reserved.
//

import UIKit
import SDWebImage

class FinishedMatchesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var homeTeamFlagImageView: UIImageView!
    @IBOutlet weak var awayTeamFlagImageView: UIImageView!
    @IBOutlet weak var homeTeamScoreLabel: UILabel!
    @IBOutlet weak var awayTeamScoreLabel: UILabel!
    @IBOutlet weak var finalScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTheme()
    }
    
    func setTheme() -> Void {
        
        self.containerView.backgroundColor = UIColor.whiteColor()
        self.containerView.layer.cornerRadius = 5.0
        self.containerView.layer.borderColor = UIColor.grayColor().CGColor
        self.containerView.layer.borderWidth = 0.5
        self.containerView.layer.shadowColor = UIColor.blackColor().CGColor
        self.containerView.layer.shadowOffset = CGSizeZero
        self.containerView.layer.shadowOpacity = 0.5
        self.containerView.layer.shadowRadius = 5
        self.containerView.clipsToBounds = true
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    func setHomeTeamName(name: String) -> Void{
        
        self.homeTeamNameLabel.text = name
    }
    
    func setAwayTeamName(name: String) -> Void{
        
        self.awayTeamNameLabel.text = name
    }
    
    func setHomeTeamFlagImage(urlImageString: String) -> Void{
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in}
        let url = NSURL(string: urlImageString)
        self.homeTeamFlagImageView.sd_setImageWithURL(url, completed: block)
    }
    
    func setawayTeamFlagImage(urlImageString: String) -> Void{
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in}
        let url = NSURL(string: urlImageString)
        self.awayTeamFlagImageView.sd_setImageWithURL(url, completed: block)
    }
    
    func setHomeTeamScoreName(name: String) -> Void{
        
        self.homeTeamScoreLabel.text = name
    }
    
    func setAwayTeamScoreName(name: String) -> Void{
        
        self.awayTeamScoreLabel.text = name
    }
    
    func setFinalScore(name: String) -> Void{
        
        self.finalScoreLabel.text = name
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
