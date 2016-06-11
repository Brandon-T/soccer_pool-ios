//
//  StandingsUserCollectionViewCell.swift
//  SoccerPool
//
//  Created by Brandon Anthony on 2016-06-08.
//  Copyright © 2016 XIO. All rights reserved.
//

import UIKit

class StandingsUserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userPhotoView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPointsLabel: UILabel!
    
    var isPulsing: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func pulseColour(colour: UIColor) -> Void {
        if self.isPulsing {
            return
        }
        
        self.isPulsing = true
        self.contentView.alpha = 0.7
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: [.CurveEaseInOut, .Repeat, .Autoreverse], animations: {
            UIView.setAnimationRepeatCount(2)
            self.contentView.backgroundColor = colour
            self.userNameLabel.textColor = UIColor.whiteColor()
            self.userPointsLabel.textColor = UIColor.whiteColor()
        }, completion: { (completed) in
            UIView.setAnimationRepeatCount(0)
            self.contentView.backgroundColor = UIColor.whiteColor()
            self.userNameLabel.textColor = colour
            self.userPointsLabel.textColor = colour
            self.contentView.alpha = 1.0
            self.isPulsing = false
        })
    }
}
