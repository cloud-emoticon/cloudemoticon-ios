//
//  SkinTableViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 王 燚 on 14/9/6.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class SkinTableViewController: UITableViewController, UIAlertViewDelegate {
    
    var 文件管理器:FileManager = FileManager()
    var 用户设置:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var 皮肤ID列表:NSMutableArray = NSMutableArray.array()
    var 左上按钮: UIBarButtonItem!
    var 右上按钮: UIBarButtonItem!
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: .Plain)
    }
    
    override init() {
        super.init()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = lang.uage("皮肤管理")
        左上按钮 = UIBarButtonItem(title: lang.uage("返回"), style: UIBarButtonItemStyle.Plain, target: self, action: "右上按钮:")
        self.navigationItem.leftBarButtonItem = 左上按钮
        右上按钮 = UIBarButtonItem(title: lang.uage("编辑"), style: UIBarButtonItemStyle.Plain, target: self, action: "左上按钮:")
        self.navigationItem.rightBarButtonItem = 右上按钮
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 返回按钮
    func 右上按钮(sender: UIBarButtonItem) {
        if (self.tableView.editing) {
            var alert:UIAlertView = UIAlertView(title: lang.uage("下载皮肤"), message: "", delegate: self, cancelButtonTitle: lang.uage("取消"), otherButtonTitles: lang.uage("添加"), lang.uage("从在线皮肤库添加"))
            alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
            var alertImport:UITextField = alert.textFieldAtIndex(0) as UITextField!
            alert.tag = 200
            alertImport.keyboardType = UIKeyboardType.URL
            alertImport.text = "http://"
            alert.show()
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // MARK: - 提示框被点击
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        var 提示框输入框:
        UITextField = alertView.textFieldAtIndex(0) as UITextField!
        if (buttonIndex == 1) {
            //添加
            //addSource(alertImport.text, isStore: false)
        } else if (buttonIndex == 2) {
            //源商店
//            UIApplication.sharedApplication().openURL(NSURL.URLWithString("http://emoticon.moe/?cat=2"))
        }
    }
    
    // MARK: - 编辑按钮
    func 左上按钮(sender: UIBarButtonItem) {
        self.tableView.setEditing(!self.tableView.editing, animated: true)
        if (self.tableView.editing) {
            self.navigationItem.rightBarButtonItem?.title = lang.uage("完成")
            self.navigationItem.leftBarButtonItem?.title = lang.uage("添加")
        } else {
            self.navigationItem.rightBarButtonItem?.title = lang.uage("编辑")
            self.navigationItem.leftBarButtonItem?.title = lang.uage("返回")
        }
        
    }

    // MARK: - 表格分组数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // MARK: - 表格行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 皮肤ID列表.count
    }
    
    // MARK: - 表格内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let 单元格标识:NSString = "Cell"
        var 单元格:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(单元格标识) as? UITableViewCell
        if (单元格 == nil) {
            单元格 = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: 单元格标识)
            单元格!.selectionStyle = UITableViewCellSelectionStyle.None
            单元格!.accessoryType = UITableViewCellAccessoryType.None
            单元格!.imageView?.backgroundColor = UIColor.lightGrayColor()
        }
        
        
        
        return 单元格!
    }
    // MARK: - 表格更改
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            
            
            
        } else if editingStyle == .Insert {
        }
    }
    // MARK: - 表格编辑范围
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        return UITableViewCellEditingStyle.Delete
    }
    // MARK: - 表格是否可以移动项目
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return false
    }
    // MARK: - 表格是否可以编辑
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    // MARK: - 点击表格中的项目
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        for i in 0...(皮肤ID列表.count-1)
        {
            var 要操作的单元格位置:NSIndexPath = NSIndexPath(forRow: i, inSection: 0)
            var 当前单元格:UITableViewCell = tableView.cellForRowAtIndexPath(要操作的单元格位置)!
            当前单元格.accessoryType = UITableViewCellAccessoryType.None
        }
        var 当前单元格:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        当前单元格.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    // MARK: - 表格高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}
