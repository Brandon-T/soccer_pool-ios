//
//  StandingsViewController.swift
//  SoccerPool
//
//  Created by Soner Yuksel on 2016-06-06.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

class StandingsViewController : BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var barGraph: BarGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initControl()
        self.setTheme()
        self.doLayout()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.barGraph.hostedGraph?.reloadData()
    }
    
    func initControl() -> Void {
        //self.barGraph = BarGraphView()
    }
    
    func setTheme() -> Void {
        
    }
    
    func doLayout() -> Void {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}