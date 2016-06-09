//
//  BetDialogView.swift
//  SoccerPool
//
//  Created by Soner Yuksel on 2016-06-08.
//  Copyright © 2016 XIO. All rights reserved.
//

import UIKit

class BetDialogView: UIView {

    @IBOutlet var view:UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSBundle.mainBundle().loadNibNamed("BetDialogView", owner: self, options: nil)
        self.addSubview(self.view);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("BetDialogView", owner: self, options: nil)
        self.addSubview(self.view);
    }
    
 
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.initControllers()
        self.setTheme()
        self.doLayout()
    }

    func initControllers(){
    
    }
    
    func setTheme(){
    
    }
    
    func doLayout(){
    
    }
    
}
