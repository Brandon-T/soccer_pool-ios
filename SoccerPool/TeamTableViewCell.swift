//
//  TeamTableViewCell.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-12.
//  Copyright © 2016 XIO. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var jerseyNumberLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.backgroundColor = UIColor.whiteColor()
        self.containerView.layer.cornerRadius = 3.0
        self.containerView.layer.borderColor = UIColor.grayColor().CGColor
        self.containerView.layer.borderWidth = 0.5
        self.containerView.layer.shadowColor = UIColor.blackColor().CGColor
        self.containerView.layer.shadowOffset = CGSizeZero
        self.containerView.layer.shadowOpacity = 0.5
        self.containerView.layer.shadowRadius = 5
        self.containerView.clipsToBounds = true
        self.backgroundColor = nil
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
