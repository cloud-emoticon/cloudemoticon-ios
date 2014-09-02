//
//  SetTableViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫喵 on 14/8/26.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class SetTableViewController: UITableViewController {
    
    var bgpview:UIImageView = UIImageView(image:UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("basicbg", ofType: "png")))
    
    var list:NSMutableArray = NSMutableArray.array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list.addObject("个性化")
        list.addObject("源管理")
        list.addObject("设置")
        list.addObject("关于")

        bgpview.frame = CGRectMake(0, 240, self.view.frame.size.width, self.view.frame.size.height)
        bgpview.sendSubviewToBack(self.view)
        bgpview.contentMode = UIViewContentMode.ScaleAspectFit
        bgpview.alpha = 0.3
        self.view.addSubview(bgpview)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 4
    }

    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SetNav", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = list.objectAtIndex(indexPath.row) as NSString

        return cell
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let storyboard = self.storyboard
        
        switch indexPath.row {
        case 0:
            let push:UIViewController = storyboard.instantiateViewControllerWithIdentifier("Color") as UIViewController
            push.hidesBottomBarWhenPushed = true
            self.navigationController.pushViewController(push, animated: true)
            break
        case 1:
            ScoreTableViewController().hidesBottomBarWhenPushed = true
            self.navigationController.pushViewController(ScoreTableViewController(), animated: true)
            break
        case 2:
            let push:UIViewController = storyboard.instantiateViewControllerWithIdentifier("Setting") as UIViewController
            push.hidesBottomBarWhenPushed = true
            self.navigationController.pushViewController(push, animated: true)
            break
        case 3:
            let push:UIViewController = storyboard.instantiateViewControllerWithIdentifier("About") as UIViewController
            push.hidesBottomBarWhenPushed = true
            self.navigationController.pushViewController(push, animated: true)
            break
        default:
            break
        }
    
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
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
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}


