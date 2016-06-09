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

class StandingsViewController : BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var barGraph: BarGraphView!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initControls()
        self.setTheme()
        self.registerClasses()
        self.doLayout()
    }
    
    func initControls() -> Void {
        //self.barGraph = BarGraphView()
        
        self.title = "Standings"
        
        let rightInformationBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "InformationBarButtonItem"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(informationBarButtonPressed))
        
        let rightLogoutBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "LogoutBarButtonItem"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(logoutBarButtonPressed))
        
        self.navigationItem.setRightBarButtonItems([rightLogoutBarButtonItem,rightInformationBarButtonItem], animated: true)
    }
    
    func setTheme() -> Void {
        self.barGraph.title = "Leader Board (Competitors vs. Points)"
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.backgroundView?.backgroundColor = UIColor.clearColor()
    }
    
    func registerClasses() -> Void {
        self.collectionView.registerNib(UINib(nibName: "StandingsUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StandingsUserCellID")
    }
    
    func doLayout() -> Void {
        self.barGraph.hostedGraph?.reloadData()
    }
    
    //MARK: BAR BUTTON ACTIONS
    
    @IBAction func logoutBarButtonPressed(sender: AnyObject) {
        ServiceLayer.logoutUser()
        
        let storyboard = UIStoryboard(name: "SoccerPool", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("loginViewController")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func informationBarButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("segueHelp", sender: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StandingsUserCellID", forIndexPath: indexPath)
        
        return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let numberOfItemsInSection = CGFloat(self.collectionView(collectionView, numberOfItemsInSection: 1))
            let width = collectionView.bounds.width - ((layout.sectionInset.left + layout.sectionInset.right) * (numberOfItemsInSection - 1))
            return CGSizeMake(width / numberOfItemsInSection, 150);
        }
        
        
        return CGSizeZero
        
    }
}