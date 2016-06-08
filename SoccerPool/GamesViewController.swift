//
//  GamesViewController.swift
//  SoccerPool
//
//  Created by Soner Yuksel on 2016-06-06.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

class GamesViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initControllers()
        self.setTheme()
        self.registerClasses()
        self.doLayout()
    }
    
    func initControllers() -> Void {
        
        let titleCupView = TitleView(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
        titleCupView.titleLabel.text = "Cup"        
        navigationItem.titleView = titleCupView
        

        let rightInformationBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "InformationBarButtonItem"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(informationBarButtonPressed))
        
        let rightLogoutBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "LogoutBarButtonItem"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(logoutBarButtonPressed))
    
        self.navigationItem.setRightBarButtonItems([rightLogoutBarButtonItem,rightInformationBarButtonItem], animated: true)
        
    }
    
    func setTheme() -> Void {
        let backgroundImageView = UIImageView(image: UIImage(named: "IntroBackground"))
        backgroundImageView.frame = self.tableView.frame
        self.tableView.backgroundView = backgroundImageView;
        
    }
    
    func registerClasses() -> Void {

        self.tableView.registerNib(UINib(nibName: "NoMatchesTableViewCell", bundle: nil), forCellReuseIdentifier: "NoMatchesCell")
    }
    
    func doLayout() -> Void {
        
    }
    
    // MARK: - BAR BUTTON ITEM ACTIONS
    
    @IBAction func logoutBarButtonPressed(sender: AnyObject) {
        ServiceLayer.logoutUser()
        
        let storyboard = UIStoryboard(name: "SoccerPool", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("loginViewController")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func informationBarButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("segueHelp", sender: nil)

    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 2
            case 1:
                return 1
            default:
                return 2
        }
    }

    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 44))
        let label = UILabel(frame: CGRectMake(0, 0, tableView.frame.size.width, 44))
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(17)
        label.textColor = UIColor.whiteColor()
        
        switch section {
            case 0:
                label.text = "Upcoming Games"
            case 1:
                label.text = "In progress Games"
            default:
                label.text = "Completed"
        }
        
        view.addSubview(label)
        view.backgroundColor = UIColor.clearColor()
        
        return view
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let section = indexPath.section
        var cell = UITableViewCell()
        
        switch section {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("GamesCell", forIndexPath: indexPath)
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier("NoMatchesCell", forIndexPath: indexPath)
            default:
                cell = tableView.dequeueReusableCellWithIdentifier("GamesCell", forIndexPath: indexPath)

        }
        
        
       // cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}