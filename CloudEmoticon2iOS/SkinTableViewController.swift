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
    var 皮肤列表数据:NSMutableArray = NSMutableArray()
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
        //[主标题,副标题,预览图路径,文件夹路径]
        皮肤列表数据.addObject([lang.uage("默认主题"),lang.uage("内置主题"),NSBundle.mainBundle().pathForResource("skindefault", ofType: "png")!,"<ceskin:default>"])
        皮肤列表数据.addObject([lang.uage("自定义主题"),lang.uage("内置主题"),"","<ceskin:custom>"])
        更新数据()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func 清空皮肤列表数据() {
        for (var i:Int = 2; i < 皮肤列表数据.count; i++) {
            皮肤列表数据.removeObjectAtIndex(2)
        }
    }
    
    func 更新数据() {
        let 皮肤管理器:SkinManager = SkinManager()
        let 皮肤列表:NSArray? = 皮肤管理器.读取皮肤列表()
        清空皮肤列表数据()
        if (皮肤列表 != nil) {
            for (var i:Int = 0; i < 皮肤列表?.count; i++) {
                let 当前头信息字典:NSDictionary = 皮肤列表?.objectAtIndex(i) as! NSDictionary
                let 主标题:String = 当前头信息字典.objectForKey("theme_name") as! String
                let 副标题:String = 当前头信息字典.objectForKey("theme_author") as! String
                let 预览图路径:String = 当前头信息字典.objectForKey("theme_picture") as! String
                let 文件夹路径:String = 当前头信息字典.objectForKey("dir") as! String
                皮肤列表数据.addObject([主标题,副标题,预览图路径,文件夹路径])
            }
        }
        self.tableView.reloadData()
    }
    
    // MARK: - SkinInstallerDelegate
    func 主题安装完成() {
        更新数据()
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
        return 皮肤列表数据.count
    }
    
    // MARK: - 表格内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let 单元格标识:NSString = "Cell"
        var 单元格:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(单元格标识 as String) as? UITableViewCell
        if (单元格 == nil) {
            单元格 = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: 单元格标识 as String)
            单元格!.accessoryType = UITableViewCellAccessoryType.None
            单元格!.selectionStyle = UITableViewCellSelectionStyle.Default
            单元格!.imageView?.backgroundColor = UIColor.lightGrayColor()
        }
        //[主标题,副标题,预览图路径,文件夹路径]
        let 当前皮肤数据:NSArray = 皮肤列表数据.objectAtIndex(indexPath.row) as! NSArray
        单元格?.textLabel?.text = 当前皮肤数据.objectAtIndex(0) as? String
        单元格?.detailTextLabel?.text = 当前皮肤数据.objectAtIndex(1) as? String
        let 当前皮肤图片:UIImage? = UIImage(contentsOfFile:  当前皮肤数据.objectAtIndex(2) as! String)
        if (当前皮肤图片 == nil) {
            单元格?.imageView?.image = 无图片
        } else {
            单元格?.imageView?.image = 当前皮肤图片!
        }
        //判断是否为当前选中
        if (全局_皮肤设置.count == 0) {
            if (indexPath.row == 0) {
                单元格!.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                单元格!.accessoryType = UITableViewCellAccessoryType.None
            }
        } else {
            let 当前应用的皮肤MD5对象:AnyObject? = 全局_皮肤设置.objectForKey("md5")
            if (当前应用的皮肤MD5对象 != nil) {
                let 当前应用的皮肤MD5:String = 当前应用的皮肤MD5对象 as! String
                let 当前皮肤文件夹路径:NSString = 当前皮肤数据.objectAtIndex(3) as! String
                let 当前皮肤文件夹路径层:NSArray = 当前皮肤文件夹路径.componentsSeparatedByString("/")
                let 当前皮肤md5:String = 当前皮肤文件夹路径层.lastObject as! String
                if (当前应用的皮肤MD5 == 当前皮肤md5) {
                    单元格!.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    单元格!.accessoryType = UITableViewCellAccessoryType.None
                }
            } else {
                NSLog("[SkinTableViewController]意外错误：当前应用的皮肤的MD5找不到。")
            }
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
        if (indexPath.row == 0) {
            全局_皮肤设置 = NSDictionary()
            let 皮肤管理器:SkinManager = SkinManager()
            皮肤管理器.设置正在使用皮肤()
        } else if (indexPath.row == 1) {
            var alert:UIAlertView = UIAlertView(title: "自定义皮肤编辑器", message: "功能尚未推出，敬请期待。", delegate: nil, cancelButtonTitle: "返回") //这段临时代码不用翻译
            alert.show()
        } else {
            //应用皮肤，提取信息并写入到内存和Group
            let 当前皮肤数据:NSArray = 皮肤列表数据.objectAtIndex(indexPath.row) as! NSArray
//            if (当前应用的皮肤MD5对象 != nil) {
            let 当前皮肤文件夹路径:NSString = 当前皮肤数据.objectAtIndex(3) as! String
            let 当前INI文件:String = String(format: "%@/index.ini", 当前皮肤文件夹路径)
            let INI读取器:INIReader = INIReader()
            let INI读取结果:Int = INI读取器.载入INI文件(当前INI文件)
            if (INI读取结果 != 0) {
                NSLog("[SkinTableViewController]意外错误：载入INI文件失败。")
            } else {
                var 要应用的皮肤内容:NSMutableDictionary? = INI读取器.INI文件内容字典
                let 当前皮肤文件夹路径层:NSArray = 当前皮肤文件夹路径.componentsSeparatedByString("/")
                let 当前皮肤md5:String = 当前皮肤文件夹路径层.lastObject as! String
                要应用的皮肤内容?.setObject(当前皮肤md5, forKey: "md5")
                全局_皮肤设置 = 要应用的皮肤内容!
            }
//            } else {
//                NSLog("[SkinTableViewController]意外错误：当前应用的皮肤的MD5找不到。")
//            }
            let 皮肤管理器:SkinManager = SkinManager()
            皮肤管理器.设置正在使用皮肤()
            
//            //改变表格当前打钩条目
//            for (var i:Int = 0; i < 皮肤列表数据.count; i++) {
//                let 要操作的单元格位置:NSIndexPath = NSIndexPath(forRow: i, inSection: 0)
//                let 当前单元格:UITableViewCell = tableView.cellForRowAtIndexPath(要操作的单元格位置)!
//                if (i == indexPath.row) {
//                    当前单元格.accessoryType = UITableViewCellAccessoryType.Checkmark
//                } else {
//                    当前单元格.accessoryType = UITableViewCellAccessoryType.None
//                }
//            }
        }
        更新数据()
        
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
