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
    
    var 文件管理器:FileManager = FileManager()
    var 源列表:NSMutableArray = NSMutableArray.array()
    var 用户设置:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var 临时数据:NSMutableArray = NSMutableArray.array()
    var 代理:ScoreTableViewControllerDelegate?
    var 已经载入:Bool = false
    
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
    
    var 左上按钮: UIBarButtonItem!
    var 右上按钮: UIBarButtonItem!
    
    // MARK: - 进入画面
    override func viewDidLoad() {
        if (已经载入 == false) {
            已经载入 = true
            载入数据()
        }
    }
    func 载入数据()
    {
        super.viewDidLoad()
        var set_nowurl:NSString? = 用户设置.stringForKey("nowurl")
        if ((set_nowurl) != nil) {
            p_nowurl = 用户设置.stringForKey("nowurl")!
        } else {
            用户设置.setValue(p_nowurl, forKey: "nowurl")
            用户设置.synchronize()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "数据载入完毕:", name: "loaddataok", object: nil)
        
        p_storeIsOpen = true
        源列表.removeAllObjects()
        var 刚载入的源列表:NSArray = 文件管理器.loadSources()
        
        if (刚载入的源列表.count == 0) {
            添加本地源()
        } else {
            
            源列表.addObjectsFromArray(刚载入的源列表)
        }
        左上按钮 = UIBarButtonItem(title: lang.uage("返回"), style: UIBarButtonItemStyle.Plain, target: self, action: "左上按钮点击:")
        self.navigationItem.leftBarButtonItem = 左上按钮
        右上按钮 = UIBarButtonItem(title: lang.uage("编辑"), style: UIBarButtonItemStyle.Plain, target: self, action: "右上按钮点击:")
        self.navigationItem.rightBarButtonItem = 右上按钮
        self.title = lang.uage("源管理")
        self.tableView.reloadData()
    }
    
    // MARK: - 添加本地源
    func 添加本地源()
    {
        let 当前颜文字库记录名称:NSString = ""
        let 当前颜文字库原始名称:NSString = lang.uage("本地默认源")
        let 当前颜文字库请求网址:NSString = "localhost"
        let 当前颜文字库删除权限:NSArray = ["default","system"]
        let 当前颜文字库:NSArray = [当前颜文字库记录名称,当前颜文字库原始名称,当前颜文字库请求网址,当前颜文字库删除权限]
        源列表.removeAllObjects()
        源列表.addObject("iOSv2")
        源列表.addObject(当前颜文字库)
    }
    
    
    // MARK: - 接收完成通知（弃用）
    func loadwebdataokf2(notification:NSNotification)
    {
        let 网络请求数组:NSArray = notification.object as NSArray
        let 网址:NSString = 网络请求数组.objectAtIndex(0) as NSString
        let 网络请求方式序号对象:NSNumber = 网络请求数组.objectAtIndex(1) as NSNumber
        let 网络请求方式序号:Int = 网络请求方式序号对象.integerValue
        let 网络请求方式:NetDownloadTo = NetDownloadTo.fromRaw(网络请求方式序号)!
        if (网络请求方式 == NetDownloadTo.SOURCEMANAGER) {
//            if (p_storeIsOpen == false) {
                加入源(网址, 来自源商店: true)
//            }
        }
    }
    
    func 加入源(网址:NSString, 来自源商店:Bool)
    {
        let 网络传输给:Int = NetDownloadTo.SOURCEMANAGER.toRaw()
        let 下载网址:NSString = 网址
        let 网络请求数组:NSMutableArray = [下载网址,NSNumber(integer: 网络传输给)]
//        if (!isStore) {
            NSNotificationCenter.defaultCenter().postNotificationName("loadwebdata", object: 网络请求数组)
//        }
        //插入数据
        if (源列表.count > 0) {
            let 当前颜文字库记录名称:NSString = ""
            let 当前颜文字库网址:NSString = 网址
            //检查重复
            var 第一遍循环:Bool = true
            var 重复:Bool = false
            for 当前颜文字对象 in 源列表 {
                if (第一遍循环) {
                    第一遍循环 = false
                } else {
                    let 当前颜文字数组:NSArray = 当前颜文字对象 as NSArray
                    let 当前颜文字网址:NSString = 当前颜文字数组.objectAtIndex(2) as NSString
                    if (当前颜文字网址.isEqualToString(当前颜文字库网址)) {
                        重复 = true
                    }
                }
            }
            if (!重复) {
                let 删除权限:NSArray = ["user"]
                临时数据 = [当前颜文字库记录名称,当前颜文字库网址,删除权限]
            } else {
                //已在列表中
            }
        }
    }
    
    func 数据载入完毕(notification:NSNotification)
    {
        var 临时源列表数据:NSMutableArray = 临时数据
        临时数据 = NSMutableArray.array()
        if (!p_tempString.isEqualToString("")) {
            临时源列表数据.insertObject(p_tempString, atIndex: 1)
            源列表.addObject(临时源列表数据)
            let indexPath:NSIndexPath = NSIndexPath(forRow: 源列表.count - 2, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            if (源列表.count > 2) {
                var 源列表已有数据:NSArray = 源列表.objectAtIndex(1) as NSArray
                var 当前网址:NSString = 源列表已有数据.objectAtIndex(2) as NSString
                if (当前网址.isEqualToString("localhost")) {
                    源列表.removeObjectAtIndex(1)
                    let 要删除的行:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                    self.tableView.deleteRowsAtIndexPaths([要删除的行], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
            }
            文件管理器.saveSources(源列表)
        }
//        else {
//           NO
//        }
    }
    
    func 文件清理()
    {
        let 文档文件夹:NSString = 文件管理器.DocumentDirectoryAddress()
        var 全部文件:NSArray = 全局_文件管理.contentsOfDirectoryAtPath(文档文件夹, error: nil)
        
        
        var 第一遍循环:Bool = true
        for 当前颜文字对象 in 源列表 {
            if (第一遍循环) {
                第一遍循环 = false
            } else {
                let 当前颜文字数组:NSArray = 当前颜文字对象 as NSArray
                let 当前颜文字网址:NSString = 当前颜文字数组.objectAtIndex(2) as NSString
                
            }
        }
    }
    
    // MARK: - 内存警告处理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func 左上按钮点击(sender: UIBarButtonItem) {
//        用户设置.synchronize()
        if (self.tableView.editing) {
            var 添加源对话框:UIAlertView = UIAlertView(title: lang.uage("添加源"), message: "", delegate: self, cancelButtonTitle: lang.uage("取消"), otherButtonTitles: lang.uage("添加"), lang.uage("从源商店添加"))
            添加源对话框.alertViewStyle = UIAlertViewStyle.PlainTextInput
            var 添加源输入框:UITextField = 添加源对话框.textFieldAtIndex(0) as UITextField!
            添加源对话框.tag = 200
            添加源输入框.keyboardType = UIKeyboardType.URL
            添加源输入框.text = "http://"
            添加源对话框.show()
        } else {
            p_storeIsOpen = false
//            timer?.invalidate()
//            timer = nil
            if (代理 != nil) {
                代理?.源管理页面代理：退出源管理页面时()
            }
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // MARK: - 提示框被点击
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        var 添加源输入框:
        UITextField = alertView.textFieldAtIndex(0) as UITextField!
        if (alertView.tag == 200) {
            if (buttonIndex == 1) {
                //添加
                加入源(添加源输入框.text, 来自源商店: false)
            } else if (buttonIndex == 2) {
                //源商店
                UIApplication.sharedApplication().openURL(NSURL.URLWithString("http://emoticon.moe/?cat=2"))
            }
        }
    }
    
    func 右上按钮点击(sender: UIBarButtonItem) {
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
        return 源列表.count - 1
    }
    
    // MARK: - 表格内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let 单元格标识:NSString = "Cell"
        var 单元格:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(单元格标识) as? UITableViewCell
        if (单元格 == nil) {
            单元格 = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: 单元格标识)
            单元格!.selectionStyle = UITableViewCellSelectionStyle.None
            单元格!.accessoryType = UITableViewCellAccessoryType.None
        }
        let 当前颜文字库:NSArray = 源列表.objectAtIndex(indexPath.row + 1) as NSArray
        let 当前颜文字库记录名称:NSString = 当前颜文字库.objectAtIndex(0) as NSString
        let 当前颜文字库原始名称:NSString = 当前颜文字库.objectAtIndex(1) as NSString
        let 当前颜文字库来源网址:NSString = 当前颜文字库.objectAtIndex(2) as NSString
        if (当前颜文字库记录名称.isEqualToString("")) {
            单元格!.textLabel?.text = 当前颜文字库记录名称
        } else {
            单元格!.textLabel?.text = NSString(format: "%@(%@)", 当前颜文字库记录名称, 当前颜文字库原始名称)
        }
        if (当前颜文字库来源网址.isEqualToString(p_nowurl)) {
            单元格!.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        单元格!.detailTextLabel?.text = 当前颜文字库来源网址
        return 单元格!
    }
    
    // MARK: - 表格更改
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
//            objects.removeObjectAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            // MARK: - 删除源
            var 当前行:NSInteger = indexPath.row + 1
            let 当前源对象:NSArray = 源列表.objectAtIndex(当前行) as NSArray
            let 当前源对象权限:NSArray = 当前源对象.objectAtIndex(3) as NSArray
            let 当前源对象网址:NSString = 当前源对象.objectAtIndex(2) as NSString
            var 当前源对象是否可删除:Bool = false
            for 当前权限用户名对象 in 当前源对象权限
            {
                let 当前权限用户名:NSString = 当前权限用户名对象 as NSString
                if (当前权限用户名.isEqualToString("user") || 当前权限用户名.isEqualToString(p_nowUserName)) {
                    当前源对象是否可删除 = true
                    break
                }
            }
            if (当前源对象是否可删除) {
                源列表.removeObjectAtIndex(当前行)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                if (源列表.count == 1) {
                    添加本地源()
                    tableView.reloadData()
                }
                文件管理器.deleteFile(当前源对象网址, smode: FileManager.saveMode.NETWORK)
                文件管理器.saveSources(源列表)
                
            } else {
                UIAlertView(title: lang.uage("无法删除这个源"), message: lang.uage("不具备删除这个源的权限"), delegate: nil, cancelButtonTitle: lang.uage("取消")).show()
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
    // MARK: - 表格项目被移动
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        var 从:NSInteger = sourceIndexPath.row
        var 至:NSInteger = destinationIndexPath.row
        
    }
    // MARK: - 点击表格中的项目
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        let 当前源对象:NSArray = 源列表.objectAtIndex(indexPath.row + 1) as NSArray
        let 当前源对象网址:NSString = 当前源对象.objectAtIndex(2) as NSString
        for i in 0...(源列表.count-2)
        {
            var 表格中当前位置:NSIndexPath = NSIndexPath(forRow: i, inSection: 0)
            var 当前循环单元格:UITableViewCell = tableView.cellForRowAtIndexPath(表格中当前位置)!
            当前循环单元格.accessoryType = UITableViewCellAccessoryType.None
        }
        var 当前单元格:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        当前单元格.accessoryType = UITableViewCellAccessoryType.Checkmark
        保存源列表(当前源对象网址)
    }
    func 保存源列表(o_url:NSString)
    {
        if (!o_url.isEqualToString(p_nowurl)) {
            p_nowurl = o_url
            用户设置.setValue(p_nowurl, forKey: "nowurl")
            用户设置.synchronize()
        }
    }
        override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String
        {
            return lang.uage("删掉喵")
        }

}
