//
//  NoMatchesTableViewCell.swift
//  SoccerPool
//
//  Created by Soner Yuksel on 2016-06-07.
//  Copyright © 2016 XIO. All rights reserved.
//

import UIKit

class NoMatchesTableViewCell: UITableViewCell {

    @IBOutlet weak var informationTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setTheme()

    }

    func setTheme() -> Void {
        informationTextLabel.text = "No matches yet."
        informationTextLabel.font = UIFont.boldSystemFontOfSize(17)
        informationTextLabel.textColor = UIColor.emptyCellTextColor()
    
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
