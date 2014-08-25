//
//  ScoreTableViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/13.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

protocol ScoreTableViewControllerDelegate:NSObjectProtocol{
    func 源管理页面代理：退出源管理页面时()
}

class ScoreTableViewController: UITableViewController, UIAlertViewDelegate { //, UITableViewDelegate, UITableViewDataSource
    
    var fileMgr:FileManager = FileManager()
    var sfile:NSMutableArray = NSMutableArray.array()
    var timer:NSTimer?
    var timerI:Int = 0
    var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var waitArr:NSMutableArray = NSMutableArray.array()
    var 代理:ScoreTableViewControllerDelegate?
    
    // MARK: - 初始化
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    override init() {
        super.init()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: - 初始化属性
//    func initvar() {
//        if (fileMgr == nil) {
//            fileMgr = FileManager()
//        }
//        if (sfile == nil) {
//            sfile = NSMutableArray.array()
//        }
//    }

    var editBtn: UIBarButtonItem!
    var backBtn: UIBarButtonItem!
    
    // MARK: - 进入画面
    override func viewDidLoad() {
        super.viewDidLoad()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadwebdataokf2:", name: "loaddataok2", object: nil)
        
        var set_nowurl:NSString? = defaults.stringForKey("nowurl")
        if ((set_nowurl) != nil) {
            p_nowurl = defaults.stringForKey("nowurl")!
        } else {
            defaults.setValue(p_nowurl, forKey: "nowurl")
            defaults.synchronize()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "time:", name: "loaddataok", object: nil)
        
        p_storeIsOpen = true
        sfile.removeAllObjects()
        var loadArrays:NSArray = fileMgr.loadSources()

        if (loadArrays.count == 0) {
            addLocalSource()
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
    
    // MARK: - 添加本地源
    func addLocalSource()
    {
        let o_note:NSString = ""
        let o_name:NSString = "本地默认源"
        let o_url:NSString = "localhost"
        let o_delete:NSArray = ["default","system"]
        let s_emoset0:NSArray = [o_note,o_name,o_url,o_delete]
        sfile.removeAllObjects()
        sfile.addObject("iOSv2")
        sfile.addObject(s_emoset0)
    }
    
//    @IBOutlet weak var editBtn: UIBarButtonItem!
//    @IBAction func editBtn(sender: UIBarButtonItem) {
//        sfile.insertObject("TEST", atIndex: sfile.count)
//    }
    
    // MARK: - 接收完成通知（弃用）
    func loadwebdataokf2(notification:NSNotification)
    {
        let urlArr:NSArray = notification.object as NSArray
        let urlStr:NSString = urlArr.objectAtIndex(0) as NSString
        let downloadModeIntNB:NSNumber = urlArr.objectAtIndex(1) as NSNumber
        let downloadModeInt:Int = downloadModeIntNB.integerValue
        let nowDownloadMode:NetDownloadTo = NetDownloadTo.fromRaw(downloadModeInt)!
        if (nowDownloadMode == NetDownloadTo.SOURCEMANAGER) {
//            if (p_storeIsOpen == false) {
                addSource(urlStr, isStore: true)
//            }
        }
    }
    
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
//            let o_name:NSString = p_tempString
//            p_tempString = ""
            let o_url:NSString = urlStr
            //检查重复
            var isone:Bool = true
            var r:Bool = false
            for nowitem in sfile {
                if (isone) {
                    isone = false
                } else {
                    let nowitemArr:NSArray = nowitem as NSArray
                    let o_url2:NSString = nowitemArr.objectAtIndex(2) as NSString
                    if (o_url2.isEqualToString(o_url)) {
                        r = true
                    }
                }
            }
            if (!r) {
                let o_delete:NSArray = ["user"]
//                var s_emosetX:NSMutableArray = [o_note,o_url,o_delete]
//                time(s_emosetX)
                waitArr = [o_note,o_url,o_delete]
//                if (!timer) {
//                    timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "time:", userInfo: s_emosetX, repeats: true)
//                }
//                timer?.fire()
            } else {
                //已在列表中
            }
        }
    }
    
    //定时执行的代码
    func time(notification:NSNotification)
    {
        var s_emosetX:NSMutableArray = waitArr
        waitArr = NSMutableArray.array()
//        var s_emosetX:NSMutableArray = sender.userInfo as NSMutableArray
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
//            timer?.invalidate()
//            timer = nil
        } else {
            println("NO")
//            self.timerI++
//            if (timerI >= 3) {
//                timerI = 0
//                timer?.invalidate()
//                timer = nil
//            }
        }
    }
    
    // MARK: - 内存警告处理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - 返回按钮
    func backBtn(sender: UIBarButtonItem) {
//        defaults.synchronize()
        if (self.tableView.editing) {
            var alert:UIAlertView = UIAlertView(title: "添加源", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "添加", "从源商店添加")
            alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
            var alertImport:UITextField = alert.textFieldAtIndex(0) as UITextField
            alert.tag = 200
            alertImport.keyboardType = UIKeyboardType.URL
            alertImport.text = "http://192.168.1.123/test1.xml"
            alert.show()
        } else {
            p_storeIsOpen = false
            timer?.invalidate()
            timer = nil
            if (代理 != nil) {
                代理?.源管理页面代理：退出源管理页面时()
            }
            self.navigationController.popViewControllerAnimated(true)
        }
    }
    
    // MARK: - 提示框被点击
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
    
    // MARK: - 编辑按钮
    func editBtn(sender: UIBarButtonItem) {
        self.tableView.setEditing(!self.tableView.editing, animated: true)
        if (self.tableView.editing) {
            self.navigationItem.rightBarButtonItem.title = "完成"
            self.navigationItem.leftBarButtonItem.title = "添加"
        } else {
            self.navigationItem.rightBarButtonItem.title = "编辑"
            self.navigationItem.leftBarButtonItem.title = "返回"
        }
        
    }
    
    // MARK: - 表格分组数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - 表格行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sfile.count - 1
    }
    
    // MARK: - 表格内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier:NSString = "Cell"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell!.accessoryType = UITableViewCellAccessoryType.None
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
        if (o_url.isEqualToString(p_nowurl)) {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        cell!.detailTextLabel.text = o_url
//        let object = objects[indexPath.row] as NSDate
//        cell.textLabel.text = object.description
        return cell!
    }
    
    // MARK: - 表格更改
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
//            objects.removeObjectAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            // MARK: - 删除源
            var nowrow:NSInteger = indexPath.row + 1
            let nowrowArr:NSArray = sfile.objectAtIndex(nowrow) as NSArray
            let chmod:NSArray = nowrowArr.objectAtIndex(3) as NSArray
            let o_url:NSString = nowrowArr.objectAtIndex(2) as NSString
            var candel:Bool = false
            for nowModObj in chmod
            {
                let nowModStr:NSString = nowModObj as NSString
                if (nowModStr.isEqualToString("user") || nowModStr.isEqualToString(p_nowUserName)) {
                    candel = true
                    break
                }
            }
            if (candel) {
                sfile.removeObjectAtIndex(nowrow)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                if (sfile.count == 1) {
                    addLocalSource()
                    tableView.reloadData()
                }
                fileMgr.deleteFile(o_url, smode: FileManager.saveMode.NETWORK)
                fileMgr.saveSources(sfile)
                
            } else {
                UIAlertView(title: "无法删除这个源", message: "这个源是系统源或者您不具备删除这个源的权限。", delegate: nil, cancelButtonTitle: "取消").show()
            }
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // MARK: - 表格编辑范围
    override func tableView(tableView: UITableView!, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle
    {
        return UITableViewCellEditingStyle.Delete
    }
    // MARK: - 表格是否可以移动项目
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool
    {
        return false
    }
    // MARK: - 表格是否可以编辑
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool
    {
        return true
        // Return false if you do not want the specified item to be editable.
    }
    // MARK: - 表格项目被移动
    override func tableView(tableView: UITableView!, moveRowAtIndexPath sourceIndexPath: NSIndexPath!, toIndexPath destinationIndexPath: NSIndexPath!)
    {
        var fromRow:NSInteger = sourceIndexPath.row
        var toRow:NSInteger = destinationIndexPath.row
        
    }
    // MARK: - 点击表格中的项目
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        
        let itemArr:NSArray = sfile.objectAtIndex(indexPath.row + 1) as NSArray
        let o_url:NSString = itemArr.objectAtIndex(2) as NSString
        for i in 0...(sfile.count-2)
        {
            var index:NSIndexPath = NSIndexPath(forRow: i, inSection: 0)
            var nowCell2:UITableViewCell = tableView.cellForRowAtIndexPath(index)
            nowCell2.accessoryType = UITableViewCellAccessoryType.None
        }
        var nowCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)
        nowCell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
//
        saveNowSource(o_url)
    }
    // MARK: - 保存源列表
    func saveNowSource(o_url:NSString)
    {
        if (!o_url.isEqualToString(p_nowurl)) {
            p_nowurl = o_url
            defaults.setValue(p_nowurl, forKey: "nowurl")
            defaults.synchronize()
        }
    }
//        override func tableView(tableView: UITableView!, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath!) -> String!
//        {
//            return "删掉喵"
//        }

}
