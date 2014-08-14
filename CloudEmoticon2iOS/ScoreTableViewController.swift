//
//  ScoreTableViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/13.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class ScoreTableViewController: UITableViewController, UIAlertViewDelegate { //, UITableViewDelegate, UITableViewDataSource
    
    var fileMgr:FileManager = FileManager()
    var sfile:NSMutableArray = NSMutableArray.array()
    var timer:NSTimer?
    var timerI:Int = 0
    
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
    }
    
    func initvar() {
        if (fileMgr == nil) {
            fileMgr = FileManager()
        }
        if (sfile == nil) {
            sfile = NSMutableArray.array()
        }
    }

    var editBtn: UIBarButtonItem!
    var backBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        p_storeIsOpen = true
        sfile.removeAllObjects()
        var loadArrays:NSArray = fileMgr.loadSources()
        if (loadArrays.count == 0) {
            let o_note:NSString = ""
            let o_name:NSString = "本地默认源"
            let o_url:NSString = "localhost"
            let o_delete:NSArray = ["default","system"]
            let s_emoset0:NSArray = [o_note,o_name,o_url,o_delete]
            sfile.removeAllObjects()
            sfile.addObject("iOSv2")
            sfile.addObject(s_emoset0)
        } else {
            
            sfile.addObjectsFromArray(loadArrays)
        }
//        self.tableView.dataSource = self
        editBtn = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "backBtn:")
        self.navigationItem.leftBarButtonItem = editBtn
        backBtn = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.Plain, target: self, action: "editBtn:")
        self.navigationItem.rightBarButtonItem = backBtn
        self.title = "源管理"
        self.tableView.reloadData()
        
        
//        self.navigationController.topViewController.navigationItem.leftBarButtonItem = ScoreTableViewController.displayModeButtonItem()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
//    @IBOutlet weak var editBtn: UIBarButtonItem!
//    @IBAction func editBtn(sender: UIBarButtonItem) {
//        sfile.insertObject("TEST", atIndex: sfile.count)
//    }
    
    // MARK: - 加入源
    func addSource(urlStr:NSString, isStore:Bool)
    {
//        println(urlStr)
        let nettoInt:Int = NetDownloadTo.SOURCEMANAGER.toRaw()
        let downloadURL:NSString = urlStr
        let downloadArr:NSMutableArray = [downloadURL,NSNumber(integer: nettoInt)]
        if (!isStore) {
            NSNotificationCenter.defaultCenter().postNotificationName("loadwebdata", object: downloadArr)
        }
        //插入数据
        if (sfile.count > 0) {
            
            let o_note:NSString = ""
            println(p_tempString)
            
            
            
//            let o_name:NSString = p_tempString
//            p_tempString = ""
            
            let o_url:NSString = urlStr
            let o_delete:NSArray = ["user"]
            var s_emosetX:NSMutableArray = [o_note,o_url,o_delete]
            if (!timer) {
                timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "time:", userInfo: s_emosetX, repeats: true)
            }
            timer?.fire()
        }
    }
    
    func time(sender:NSTimer)
    {
        var s_emosetX:NSMutableArray = sender.userInfo as NSMutableArray
        if (!p_tempString.isEqualToString("")) {
            println("YES")
            s_emosetX.insertObject(p_tempString, atIndex: 1)
            sfile.addObject(s_emosetX)
            let indexPath:NSIndexPath = NSIndexPath(forRow: sfile.count - 2, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            if (sfile.count > 2) {
                var s_emosetN:NSArray = sfile.objectAtIndex(1) as NSArray
                var urlN:NSString = s_emosetN.objectAtIndex(2) as NSString
                if (urlN.isEqualToString("localhost")) {
                    sfile.removeObjectAtIndex(1)
                    let delindexPath:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                    self.tableView.deleteRowsAtIndexPaths([delindexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
            }
            fileMgr.saveSources(sfile)
            timer?.invalidate()
//            timer = nil
        } else {
            println("NO")
            self.timerI++
            if (timerI >= 3) {
                timerI = 0
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - 表格数据
    func backBtn(sender: UIBarButtonItem) {
        if (self.tableView.editing) {
            var alert:UIAlertView = UIAlertView(title: "添加源", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "添加", "从源商店添加")
            alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
            var alertImport:UITextField = alert.textFieldAtIndex(0) as UITextField
            alert.tag = 200
            alertImport.keyboardType = UIKeyboardType.URL
            alertImport.text = "http://cxchope.sites.my-card.in/ce.xml"
            alert.show()
        } else {
            p_storeIsOpen = false
            timer?.invalidate()
            timer = nil
            self.navigationController.popViewControllerAnimated(true)
        }
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        var alertImport:UITextField = alertView.textFieldAtIndex(0) as UITextField
        if (alertView.tag == 200) {
            if (buttonIndex == 1) {
                //添加
                addSource(alertImport.text, isStore: false)
            } else if (buttonIndex == 2) {
                //源商店
                UIApplication.sharedApplication().openURL(NSURL.URLWithString("http://emoticon.moe/?cat=2"))
            }
        }
    }
    
    func editBtn(sender: UIBarButtonItem) {
        self.tableView.setEditing(!self.tableView.editing, animated: true)
        if (self.tableView.editing) {
            self.navigationItem
            self.navigationItem.rightBarButtonItem.title = "完成"
            self.navigationItem.leftBarButtonItem.title = "添加"
        } else {
            self.navigationItem.rightBarButtonItem.title = "编辑"
            self.navigationItem.leftBarButtonItem.title = "返回"
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sfile.count - 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier:NSString = "Cell"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)
            cell!.selectionStyle = UITableViewCellSelectionStyle.Blue
        }
//        let itemdata:NSArray = sfile.objectAtIndex(indexPath.row) as NSArray
        let itemArr:NSArray = sfile.objectAtIndex(indexPath.row + 1) as NSArray
        let o_note:NSString = itemArr.objectAtIndex(0) as NSString
        let o_name:NSString = itemArr.objectAtIndex(1) as NSString
        let o_url:NSString = itemArr.objectAtIndex(2) as NSString
        if (o_note.isEqualToString("")) {
            cell!.textLabel.text = o_name
        } else {
            cell!.textLabel.text = NSString(format: "%@(%@)", o_note, o_name)
        }
        cell!.detailTextLabel.text = o_url
//        let object = objects[indexPath.row] as NSDate
//        cell.textLabel.text = object.description
        return cell!
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
//            objects.removeObjectAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            var nowrow:NSInteger = indexPath.row + 1
            sfile.removeObjectAtIndex(nowrow)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        } else if editingStyle == .Insert {
            
            
            
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(tableView: UITableView!, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle
    {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool
    {
        return false
    }
    
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool
    {
        return true
        // Return false if you do not want the specified item to be editable.
    }
    
    override func tableView(tableView: UITableView!, moveRowAtIndexPath sourceIndexPath: NSIndexPath!, toIndexPath destinationIndexPath: NSIndexPath!)
    {
        var fromRow:NSInteger = sourceIndexPath.row
        var toRow:NSInteger = destinationIndexPath.row
        
    }

    
    

}
