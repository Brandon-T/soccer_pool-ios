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

class StandingsViewController : BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, BarGraphViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var barGraph: BarGraphView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    
    var pools = [[Pool]]()
    let emptyBarHeight: Double = 0.5
    var scrollCompletion: (() -> Void)? = nil
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        ServiceLayer.getPool { [unowned self](json, error) in
            guard error == nil else {
                return
            }
            
            self.pools.removeAll()
            
            if let poolArray = json?["data"] as? [[String: AnyObject]] {
                
                //Sort into groups of 3 per row.
                var pool = [Pool]()
                let pools = Pool.fromJSONArray(poolArray) as! [Pool]
                
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
                
                
                //Source for bar graph
                self.barGraph.graphData.removeAll()
                self.barGraph.graphBarColors.removeAll()
                
                for i in 0..<pools.count {
                    let pool = pools[i]
                    self.barGraph.graphBarColors[pool.name!] = self.generateColour(UInt(i), total: UInt(pools.count))
                    self.barGraph.graphData[pool.name!] = Double(pool.points) > 0 ? Double(pool.points) : self.emptyBarHeight
                }
                
                //Update UI.
                self.barGraph.reloadData()
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initControls()
        self.setTheme()
        self.registerClasses()
        self.doLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionViewHeightConstraint.constant = self.collectionView.contentSize.height
    }
    
    func generateColour(idx: UInt, total: UInt) -> UIColor {
        return UIColor(hue: CGFloat(idx) / CGFloat(total), saturation: 0.9, brightness: 0.9, alpha: 1.0)
    }
    
    func initControls() -> Void {
        self.title = "Standings"
        
        let rightInformationBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "InformationBarButtonItem"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(informationBarButtonPressed))
        
        let rightLogoutBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "LogoutBarButtonItem"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(logoutBarButtonPressed))
        
        self.navigationItem.setRightBarButtonItems([rightLogoutBarButtonItem,rightInformationBarButtonItem], animated: true)
    }
    
    func setTheme() -> Void {
        self.barGraph.title = "Leader Board (Competitors vs. Points)"
        self.barGraph.delegate = self
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.backgroundView?.backgroundColor = UIColor.clearColor()
    }
    
    func registerClasses() -> Void {
        self.collectionView.registerNib(UINib(nibName: "StandingsUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StandingsUserCellID")
    }
    
    func doLayout() -> Void {
        self.barGraph.reloadData()
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
        let colour = self.barGraph.graphBarColors[pool.name!]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StandingsUserCellID", forIndexPath: indexPath) as! StandingsUserCollectionViewCell
        
        cell.userPhotoView.loadImage(pool.photo)
        cell.userNameLabel.text = pool.name
        cell.userNameLabel.textColor = colour
        cell.userPointsLabel.text = "\(pool.points) Pts"
        cell.userPointsLabel.textColor = colour
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let numberOfItemsInSection = CGFloat(self.collectionView(collectionView, numberOfItemsInSection: 0))
            let width = collectionView.bounds.width - ((layout.sectionInset.left + layout.sectionInset.right) * (numberOfItemsInSection - 1))
            return CGSizeMake(width / numberOfItemsInSection, 180);
        }
        
        return CGSizeZero
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.barGraph.pulseColour(indexPath.row)
    }
    
    func barSelected(barGraph: BarGraphView, index: UInt) -> Void {
        var idx = 0
        
        for section in 0..<self.pools.count {
            for item in 0..<self.pools[section].count {
                if UInt(idx) == index {
                    let indexPath = NSIndexPath(forItem: item, inSection: section)
                    let attributes = self.collectionView.layoutAttributesForItemAtIndexPath(indexPath);
                    
                    if let attributes = attributes {
                        var frame = attributes.frame
                        frame.origin.y -= self.barGraph.frame.size.height
                        frame = self.collectionView.convertRect(attributes.frame, toView: self.scrollView)

                        let visibleFrame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.size.height - 5, width: frame.size.width, height: frame.size.height)
                        
                        if CGRectIntersectsRect(self.scrollView.bounds, visibleFrame) {
                            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.0 * Double(NSEC_PER_SEC)))
                            
                            dispatch_after(delayTime, dispatch_get_main_queue(), {
                                let pool = self.pools[section][item]
                                let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as! StandingsUserCollectionViewCell
                                cell.pulseColour(barGraph.graphBarColors[pool.name!]!)
                            })
                        }
                        else {
                            self.scrollCompletion = {
                                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
                                
                                dispatch_after(delayTime, dispatch_get_main_queue(), {
                                    let pool = self.pools[section][item]
                                    let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as! StandingsUserCollectionViewCell
                                    cell.pulseColour(barGraph.graphBarColors[pool.name!]!)
                                })
                            }
                            
                            self.scrollView.delegate = self
                            self.scrollView.scrollRectToVisible(frame, animated: true)
                        }
                        
                        return
                    }
                }
                
                idx += 1
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if self.scrollCompletion != nil {
            scrollView.delegate = nil
            self.scrollCompletion!()
        }
    }
}