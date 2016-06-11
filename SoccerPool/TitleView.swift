//
//  TitleView.swift
//  SoccerPool
//
//  Created by Soner Yuksel on 2016-06-07.
//  Copyright © 2016 XIO. All rights reserved.
//

import UIKit

class TitleView: UIView {


    // Our custom view from the XIB file
    var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        initControls()
        setTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        initControls()
        setTheme()

    }
    
    func initControls() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func setTheme() {
        self.titleLabel.font = UIFont.semiBoldSystemFont(17)
        self.titleLabel.textColor = UIColor.whiteColor()
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TitleView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }

}
