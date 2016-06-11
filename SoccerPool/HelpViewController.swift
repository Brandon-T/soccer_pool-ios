//
//  HelpViewController.swift
//  SoccerPool
//
//  Created by Soner Yuksel on 2016-06-08.
//  Copyright © 2016 XIO. All rights reserved.
//


import Foundation
import UIKit

class HelpViewController : BaseViewController {
    
    
    @IBOutlet weak var helpWebView: UIWebView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initControls()
        self.setTheme()
        self.doLayout()
    }
    
    func initControls() -> Void {
        self.title = "Help"
        helpWebView.loadRequest(NSURLRequest(URL: ServiceLayer.Router.informationURL!))
    }
    
    func setTheme() -> Void {
        
    }
    
    func doLayout() -> Void {
        
    }

    //MARK: ACTIONS
    
    @IBAction func closeBarButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}