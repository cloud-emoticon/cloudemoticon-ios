//
//  AddonTableViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫喵 on 14/8/26.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

var bgpview:UIImageView = UIImageView(image:UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("basicbg", ofType: "png")!))

class AddonTableViewController: UITableViewController {

    var list:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list.addObject(lang.uage("摇一摇"))
        list.addObject(lang.uage("扩展功能"))
        list.addObject(lang.uage("输入法"))
        self.title = lang.uage("附加工具")
        
//MARK - 主题
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 255)
        
//包括下面这里
//        bgpview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
//        bgpview.sendSubviewToBack(self.view)
//        bgpview.contentMode = UIViewContentMode.ScaleAspectFit
//        bgpview.alpha = 0.3
//        self.view.addSubview(bgpview)
        
        
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return list.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Addon", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = list.objectAtIndex(indexPath.row) as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            let push:UIViewController = storyboard?.instantiateViewControllerWithIdentifier("Shake") as! UIViewController
            push.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(push, animated: true)
            break
        case 1:
            let push:UIViewController = storyboard?.instantiateViewControllerWithIdentifier("Extension") as! UIViewController
            push.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(push, animated: true)
            break
        case 2:
            let push:UIViewController = storyboard?.instantiateViewControllerWithIdentifier("Input") as! UIViewController
            push.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(push, animated: true)
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
