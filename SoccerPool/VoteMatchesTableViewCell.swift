//
//  VoteMatchesTableViewCell.swift
//  SoccerPool
//
//  Created by Soner Yuksel on 2016-06-08.
//  Copyright © 2016 XIO. All rights reserved.
//

import UIKit

class VoteMatchesTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
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
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
