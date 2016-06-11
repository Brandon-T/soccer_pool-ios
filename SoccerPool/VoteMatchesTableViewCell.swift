//
//  VoteMatchesTableViewCell.swift
//  SoccerPool
//
//  Created by Soner Yuksel on 2016-06-08.
//  Copyright © 2016 XIO. All rights reserved.
//

import UIKit
import SDWebImage

class VoteMatchesTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var homeTeamFlagImageView: UIImageView!
    @IBOutlet weak var awayTeamFlagImageView: UIImageView!
    @IBOutlet weak var homeTeamScoreLabel: UILabel!
    @IBOutlet weak var awayTeamScoreLabel: UILabel!
    @IBOutlet weak var gameTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTheme()
    }

    func setTheme() -> Void {
        self.containerView.backgroundColor = UIColor.whiteColor()
        self.containerView.layer.cornerRadius = 3.0
        self.containerView.layer.borderColor = UIColor.grayColor().CGColor
        self.containerView.layer.borderWidth = 0.5
        self.containerView.layer.shadowColor = UIColor.blackColor().CGColor
        self.containerView.layer.shadowOffset = CGSizeZero
        self.containerView.layer.shadowOpacity = 0.5
        self.containerView.layer.shadowRadius = 5
        self.containerView.clipsToBounds = true

        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
