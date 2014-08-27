//
//  SettingViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫 on 14/8/26.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var adflist:NSMutableArray = NSMutableArray.array()
    var actlist:NSMutableArray = NSMutableArray.array()
    

    @IBOutlet weak var SettingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adflist.addObject("广告显示频率")
        adflist.addObject("")
        adflist.addObject("复制后退出")
        SettingTable.delegate = self
        SettingTable.dataSource = self
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        if(section == 0)
        {
            return 2
        } else {
            return 1
        }
    }
    
    func  tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String!
    {
        if(section == 0)
        {
            return "广告"
        } else {
            return "行为"
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let Cellidentifer:NSString = "SettingCell"
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SettingCell", forIndexPath: indexPath) as UITableViewCell
        
        if(indexPath.section == 1){
        var switchview:UISwitch = UISwitch(frame: CGRectZero)
        cell.accessoryView = switchview
        cell.contentView.addSubview(switchview)
        }
        if(indexPath.section == 0){
        cell.textLabel.text = adflist.objectAtIndex(indexPath.row) as NSString
        } else {
        cell.textLabel.text = adflist.objectAtIndex(indexPath.row + 2) as NSString

        }
        

        return cell
    }
    
    func updateSwitchAtIndesPath(sender:AnyObject){
        var switchview:UISwitch = sender as UISwitch
        if(switchview.on){
            
        } else {
        
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
