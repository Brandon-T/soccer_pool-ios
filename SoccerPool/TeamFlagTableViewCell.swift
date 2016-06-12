//
//  TeamFlagTableViewCell.swift
//  SoccerPool
//
//  Created by Brandon Thomas on 2016-06-12.
//  Copyright © 2016 XIO. All rights reserved.
//

import UIKit

class TeamFlagTableViewCell: UITableViewCell {

    @IBOutlet weak var flagView: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = nil
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
