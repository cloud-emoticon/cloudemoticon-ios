//
//  SkinTableViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/9/6.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class SkinTableViewController: UITableViewController, UIAlertViewDelegate, SkinInstallerDelegate {
    
    var 文件管理器:FileManager = FileManager()
    let 皮肤安装器:SkinInstaller = SkinInstaller()
    var 用户设置:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var 皮肤ID列表:NSMutableArray = NSMutableArray()
    var 左上按钮: UIBarButtonItem!
    var 右上按钮: UIBarButtonItem!
    var 安装提示框:UIAlertView?
    let 无图片:UIImage = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("skinnoimg", ofType: "png")!)!
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: .Plain)
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
        //[主标题,副标题,主题图片路径,主题本地文件夹路径]
        皮肤ID列表.addObject([lang.uage("默认主题"),lang.uage("内置主题"),NSBundle.mainBundle().pathForResource("skindefault", ofType: "png")!,"<ceskin:default>"])
        皮肤ID列表.addObject([lang.uage("自定义主题"),lang.uage("内置主题"),"","<ceskin:custom>"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func 显示安装提示框(显示:Bool,标题:NSString,内容:NSString,按钮:NSString?) {
        if (显示) {
            let 标题字符串:String = 标题 as String
            let 内容字符串:String = 内容 as String
            var 按钮字符串:String? = nil
            if (按钮 != nil) {
                按钮字符串 = 按钮 as? String
            }
            if (安装提示框 == nil) {
                安装提示框 = UIAlertView(title: 标题字符串, message: 内容字符串, delegate: nil, cancelButtonTitle: 按钮字符串)
                安装提示框?.show()
            }
            if (安装提示框?.title != 标题字符串) {
                安装提示框?.title = 标题字符串
            }
            if (安装提示框?.message != 内容字符串) {
                安装提示框?.message = 内容字符串
            }
            if (按钮字符串 != nil) {
                安装提示框?.dismissWithClickedButtonIndex(0, animated: false)
                安装提示框 = nil
                安装提示框 = UIAlertView(title: 标题字符串, message: 内容字符串, delegate: nil, cancelButtonTitle: 按钮字符串)
                安装提示框?.show()
                UIApplication.sharedApplication().keyWindow?.endEditing(true)
                
            }
        } else {
            安装提示框?.dismissWithClickedButtonIndex(0, animated: true)
            安装提示框 = nil
        }
    }
    
    // MARK: - 返回按钮
    func 右上按钮(sender: UIBarButtonItem) {
        if (self.tableView.editing) {
//            self.tableView.setEditing(false, animated: true)
            var alert:UIAlertView = UIAlertView(title: lang.uage("下载皮肤"), message: "", delegate: self, cancelButtonTitle: lang.uage("取消"), otherButtonTitles: lang.uage("添加"), lang.uage("从在线皮肤库添加"))
            alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
            var alertImport:UITextField = alert.textFieldAtIndex(0) as UITextField!
            alert.tag = 200
            alertImport.keyboardType = UIKeyboardType.URL
            alertImport.text = "http://127.0.0.1/skin/skin.zip"
            alert.show()
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // MARK: - 提示框被点击
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        var 提示框输入框:
        UITextField = alertView.textFieldAtIndex(0) as UITextField!
        if (buttonIndex == 1) {
            //添加
            皮肤安装器.代理 = self
            提示框输入框.userInteractionEnabled = false
            皮肤安装器.启动安装任务(提示框输入框.text)
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
        var 单元格:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(单元格标识 as String) as? UITableViewCell
        if (单元格 == nil) {
            单元格 = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: 单元格标识 as String)
            单元格!.selectionStyle = UITableViewCellSelectionStyle.Default
            单元格!.accessoryType = UITableViewCellAccessoryType.None
            单元格!.imageView?.backgroundColor = UIColor.lightGrayColor()
        }
        //[主标题,副标题,主题图片路径,主题本地文件夹路径]
        let 当前皮肤ID:NSArray = 皮肤ID列表.objectAtIndex(indexPath.row) as! NSArray
        单元格?.textLabel?.text = 当前皮肤ID.objectAtIndex(0) as? String
        单元格?.detailTextLabel?.text = 当前皮肤ID.objectAtIndex(1) as? String
        let 当前皮肤图片:UIImage? = UIImage(contentsOfFile:  当前皮肤ID.objectAtIndex(2) as! String)
        if (当前皮肤图片 == nil) {
            单元格?.imageView?.image = 无图片
        } else {
            单元格?.imageView?.image = 当前皮肤图片!
        }
        return 单元格!
    }
    // MARK: - 表格更改
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            if (indexPath.row < 2) {
                UIAlertView(title: lang.uage("无法删除这个主题"), message: lang.uage("内置主题不能被删除"), delegate: nil, cancelButtonTitle: lang.uage("取消")).show()
            }
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true) //闪一下
        //<#此处应用皮肤#>
        
//        for i in 0...(皮肤ID列表.count - 1)
//        {
//            var 要操作的单元格位置:NSIndexPath = NSIndexPath(forRow: i, inSection: 0)
//            var 当前单元格:UITableViewCell = tableView.cellForRowAtIndexPath(要操作的单元格位置)!
//            当前单元格.accessoryType = UITableViewCellAccessoryType.None
//        }
//        var 当前单元格:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
//        当前单元格.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    // MARK: - 表格高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 128
    }
}
