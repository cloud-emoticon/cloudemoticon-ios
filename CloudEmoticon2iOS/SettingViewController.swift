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
    
    var SetTable:UITableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.width), style: UITableViewStyle.Grouped)

    var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var adf:Float? = NSUserDefaults.standardUserDefaults().valueForKey("adfrequent") as? Float
    var copyexit:Bool? = NSUserDefaults.standardUserDefaults().valueForKey("exitaftercopy") as? Bool
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        adflist.addObject("广告显示频率")
        adflist.addObject("")
        adflist.addObject("复制后退出")
        SetTable.delegate = self
        SetTable.dataSource = self
        view.addSubview(SetTable)
        
        
        
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
        
        if(adf == nil){
        adf = 100
        }
        if(copyexit == nil){
        copyexit = false
        }
        var sliderview:UISlider = UISlider(frame: CGRectMake(0, 0, self.view.frame.size.width - 36, 20))
            sliderview.minimumValue = 0
            sliderview.maximumValue = 100
            sliderview.value = adf!
        var switchview:UISwitch = UISwitch(frame: CGRectZero)
            switchview.on = copyexit!

        let CellIdentifier:NSString = "SettingCell"
        var cell:UITableViewCell? = SetTable.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        
        if(indexPath.section == 0){
        cell!.textLabel.text = adflist.objectAtIndex(indexPath.row) as NSString
        } else {
        cell!.textLabel.text = adflist.objectAtIndex(indexPath.row + 2) as NSString
        }

        if(indexPath.section == 0 && indexPath.row == 1){
            
            cell!.accessoryView = sliderview
            sliderview.addTarget(self, action: Selector(updateSliderAtIndesPath(sliderview)), forControlEvents: UIControlEvents.TouchUpInside)
            cell!.contentView.addSubview(sliderview)
        }
        
        if(indexPath.section == 1){
                cell!.accessoryView = switchview
            switchview.addTarget(self, action: Selector(updateSwitchAtIndesPath(switchview)), forControlEvents: UIControlEvents.ValueChanged)
            cell!.contentView.addSubview(switchview)
        }
                
        
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func updateSwitchAtIndesPath(sender:UISwitch){
        var switchview:UISwitch = sender
//        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
              defaults.setBool(switchview.on, forKey: "exitaftercopy")
        defaults.synchronize()

    }
    
    func updateSliderAtIndesPath(sender:UISlider){
        var sliderview:UISlider = sender
//         var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(sliderview.value, forKey: "adfrequent")
        defaults.synchronize()
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
