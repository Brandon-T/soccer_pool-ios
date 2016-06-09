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
    
    var pools = [[Pool]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initControls()
        self.setTheme()
        self.registerClasses()
        self.doLayout()
        
        ServiceLayer.getPool { [unowned self](json, error) in
            guard error == nil else {
                return
            }
            
            if let poolArray = json?["data"] as? [[String: AnyObject]] {
                let pools = Pool.fromJSONArray(poolArray) as! [Pool]
                
                var pool = [Pool]()
                
                for i in 0..<pools.count {
                    if i > 0 && i % 3 == 0 {
                        self.pools.append(pool)
                        pool = [Pool]()
                        pool.append(pools[i])
                    }
                    else {
                        pool.append(pools[i])
                    }
                }
                
                if pool.count > 0 {
                    self.pools.append(pool)
                }
                
                self.collectionView.reloadData()
            }
        }
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
        return pools.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pools[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let pool = self.pools[indexPath.section][indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StandingsUserCellID", forIndexPath: indexPath) as! StandingsUserCollectionViewCell
        
        cell.userPhotoView.loadImage(pool.photo)
        
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