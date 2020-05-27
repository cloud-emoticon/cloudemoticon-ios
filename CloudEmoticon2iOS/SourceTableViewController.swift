//
//  ScoreTableViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/13.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

protocol SourceTableViewControllerDelegate:NSObjectProtocol{
    func 源管理页面代理：退出源管理页面时()
}

class SourceTableViewController: UITableViewController, UIAlertViewDelegate { //, UITableViewDelegate, UITableViewDataSource
    
    var 文件管理器:FileManager = FileManager()
    var 源列表:NSMutableArray = NSMutableArray()
    var 用户设置:UserDefaults = UserDefaults.standard
    var 临时数据:NSMutableArray = NSMutableArray()
    var 代理:SourceTableViewControllerDelegate?
    var 已经载入:Bool = false
    
    // MARK: - 初始化
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    var 左上按钮: UIBarButtonItem!
    var 右上按钮: UIBarButtonItem!
    

    
    // MARK: - 进入画面
    override func viewDidLoad() {
        if (已经载入 == false) {
            已经载入 = true
            载入数据()
        } else {
            文件清理()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (!self.tableView.isEditing) {
            左上按钮 = UIBarButtonItem(title: lang.uage("返回"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SourceTableViewController.左上按钮点击(_:)))
            self.navigationItem.leftBarButtonItem = 左上按钮
            右上按钮 = UIBarButtonItem(title: lang.uage("编辑"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SourceTableViewController.右上按钮点击(_:)))
            self.navigationItem.rightBarButtonItem = 右上按钮
        } else {
            左上按钮 = UIBarButtonItem(title: lang.uage("添加"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SourceTableViewController.左上按钮点击(_:)))
            self.navigationItem.leftBarButtonItem = 左上按钮
            右上按钮 = UIBarButtonItem(title: lang.uage("完成"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SourceTableViewController.右上按钮点击(_:)))
            self.navigationItem.rightBarButtonItem = 右上按钮
        }
    }
    
    //MARK: - 主题
    
    func 载入数据()
    {
        super.viewDidLoad()
        let set_nowurl:NSString? = 用户设置.string(forKey: "nowurl") as NSString?
        if ((set_nowurl) != nil) {
            p_nowurl = 用户设置.string(forKey: "nowurl")! as NSString
        } else {
            用户设置.setValue(p_nowurl, forKey: "nowurl")
            用户设置.synchronize()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(SourceTableViewController.数据载入完毕(_:)), name: NSNotification.Name(rawValue: "loaddataok"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SourceTableViewController.网络失败时(_:)), name: NSNotification.Name(rawValue: "网络失败"), object: nil)
        p_storeIsOpen = true
        源列表.removeAllObjects()
        let 刚载入的源列表:NSArray = 文件管理器.loadSources()
        
        if (刚载入的源列表.count == 0) {
            添加本地源()
        } else {
            
            源列表.addObjects(from: 刚载入的源列表 as [AnyObject])
        }
        左上按钮 = UIBarButtonItem(title: lang.uage("返回"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SourceTableViewController.左上按钮点击(_:)))
        self.navigationItem.leftBarButtonItem = 左上按钮
        右上按钮 = UIBarButtonItem(title: lang.uage("编辑"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SourceTableViewController.右上按钮点击(_:)))
        self.navigationItem.rightBarButtonItem = 右上按钮
        self.title = lang.uage("源管理")
        self.tableView.reloadData()
    }
    
    // MARK: - 添加本地源
    func 添加本地源()
    {
        let 当前颜文字库记录名称:NSString = ""
        let 当前颜文字库原始名称:NSString = lang.uage("本地默认源") as NSString
        let 当前颜文字库请求网址:NSString = "localhost"
        let 当前颜文字库删除权限:NSArray = ["default","system"]
        let 当前颜文字库:NSArray = [当前颜文字库记录名称,当前颜文字库原始名称,当前颜文字库请求网址,当前颜文字库删除权限]
        源列表.removeAllObjects()
        源列表.add("iOSv2")
        源列表.add(当前颜文字库)
        
    }
    
    
//    // MARK: - 接收完成通知（弃用）
//    func loadwebdataokf2(notification:NSNotification)
//    {
//        let 网络请求数组:NSArray = notification.object as NSArray
//        let 网址:NSString = 网络请求数组.objectAtIndex(0) as NSString
//        let 网络请求方式序号对象:NSNumber = 网络请求数组.objectAtIndex(1) as NSNumber
//        let 网络请求方式序号:Int = 网络请求方式序号对象.integerValue
//        let 网络请求方式:NetDownloadTo = NetDownloadTo.fromRaw(网络请求方式序号)!
//        if (网络请求方式 == NetDownloadTo.SOURCEMANAGER) {
////            if (p_storeIsOpen == false) {
//                加入源(网址, 来自源商店: true)
////            }
//        }
//    }
    
//    func 下载提示窗(开关:Bool)
//    {
//        if (开关) {
//            let 下载中提示:UIAlertView = UIAlertView(title: "下载中", message: "", delegate: nil, cancelButtonTitle: nil)
//            let 等待提示:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
////            等待提示.center = CGPointMake(下载中提示.bounds.size.width/2.0, 下载中提示.bounds.size.height/2.0);
//            等待提示.frame = CGRectMake(0, 0, 10, 10)
//            等待提示.startAnimating()
//            下载中提示.addSubview(等待提示)
//            下载中提示.show()
//        }
//    }
    
    func 加入源(_ 网址:NSString, 来自源商店:Bool)
    {
        let 网络传输给:Int = NetDownloadTo.sourcemanager.rawValue
        let 下载网址:NSString = 网址
        let 网络请求数组:NSMutableArray = [下载网址,NSNumber(value: 网络传输给 as Int)]
//        if (!isStore) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "显示等待提示框通知"), object: NSNumber(value: true as Bool))
        NotificationCenter.default.post(name: Notification.Name(rawValue: "loadwebdata"), object: 网络请求数组)
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
                    let 当前颜文字数组:NSArray = 当前颜文字对象 as! NSArray
                    let 当前颜文字网址:NSString = 当前颜文字数组.object(at: 2) as! NSString
                    if (当前颜文字网址.isEqual(to: 当前颜文字库网址 as String)) {
                        重复 = true
                    }
                }
            }
            if (!重复) {
                let 删除权限:NSArray = ["user"]
                临时数据 = [当前颜文字库记录名称,当前颜文字库网址,删除权限]
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "显示等待提示框通知"), object: NSNumber(value: false as Bool))
                let 源已在列表中提示框:UIAlertView = UIAlertView(title: lang.uage("你已经添加过这个源了"), message: "", delegate: nil, cancelButtonTitle: lang.uage("确定"))
                源已在列表中提示框.show()
            }
        }
    }
    
    @objc func 数据载入完毕(_ notification:Notification)
    {
        print("数据载入完毕")
        let 临时源列表数据:NSMutableArray = 临时数据
        临时数据 = NSMutableArray()
        if (!p_tempString.isEqual(to: "") && 临时源列表数据.count > 0) {
            临时源列表数据.insert(p_tempString, at: 1)
            源列表.add(临时源列表数据)
            let indexPath:IndexPath = IndexPath(row: 源列表.count - 2, section: 0)
            self.tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            if (源列表.count > 2) {
                let 源列表已有数据:NSArray = 源列表.object(at: 1) as! NSArray
                let 当前网址:NSString = 源列表已有数据.object(at: 2) as! NSString
                if (当前网址.isEqual(to: "localhost")) {
                    源列表.removeObject(at: 1)
                    let 要删除的行:IndexPath = IndexPath(row: 0, section: 0)
                    self.tableView.deleteRows(at: [要删除的行], with: UITableView.RowAnimation.automatic)
                }
            }
            
            文件管理器.saveSources(源列表)
        }
        print("选择源")
        print(源列表)
        if (源列表.count == 2) {
            选择源(tableView,didSelectRowAtIndexPath: IndexPath(row: 0, section: 0))
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "显示等待提示框通知"), object: NSNumber(value: false as Bool))
    }
    
    @objc func 网络失败时(_ notification:Notification)
    {
        print("网络失败")
    }
    
    func 文件清理()
    {
        let 文档文件夹:NSString = 文件管理器.DocumentDirectoryAddress()
        let 全部文件:NSArray = try! 全局_文件管理.contentsOfDirectory(atPath: 文档文件夹 as String) as NSArray
        let 要删除的文件:NSMutableArray = NSMutableArray()
        for 当前文件名对象 in 全部文件 {
            let 当前文件名:NSString = 当前文件名对象 as! NSString
            if(当前文件名.length >= 6)
            {
                let 当前文件前缀:NSString = 当前文件名.substring(to: 6) as NSString
                if (当前文件前缀.isEqual(to: "cache-")) {
                要删除的文件.add(当前文件名)
                }
            }
        }
        
        var 第一遍循环:Bool = true
        for 当前颜文字对象 in 源列表 {
            if (第一遍循环) {
                第一遍循环 = false
            } else {
                let 当前颜文字数组:NSArray = 当前颜文字对象 as! NSArray
                let 当前颜文字网址:NSString = 当前颜文字数组.object(at: 2) as! NSString
                for i in 0 ..< 要删除的文件.count {
//                for (var i:Int = 0; i < 要删除的文件.count; i += 1) {
                    let 要删除的文件名:NSString = 要删除的文件.object(at: i) as! NSString
                    let 当前文件名:NSString = NSString(format: "cache-%@.plist", md5(当前颜文字网址 as String) as String)
                    if (要删除的文件名.isEqual(to: 当前文件名 as String)) {
                        要删除的文件.removeObject(at: i)
                        break;
                    }
                }
                for 要删除的文件名对象 in 要删除的文件 {
                    let 要删除的文件名:NSString = 要删除的文件名对象 as! NSString
                    let 要删除文件完整路径:NSString = NSString(format: "%@%@", 文档文件夹,要删除的文件名)
                    print("[源管理]删除缓存 \(要删除文件完整路径)")
                    var err:NSError? = nil
                    do {
                        try 全局_文件管理.removeItem(atPath: 要删除文件完整路径 as String)
                    } catch let error as NSError {
                        err = error
                    }
                    if (err != nil) {
                        print("[源管理]删除缓存失败。")
                    }
                }
            }
        }
    }
    
    // MARK: - 内存警告处理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func 左上按钮点击(_ sender: UIBarButtonItem) {
//        用户设置.synchronize()
        if (self.tableView.isEditing) {
            let 添加源对话框:UIAlertView = UIAlertView(title: lang.uage("添加源"), message: "", delegate: self, cancelButtonTitle: lang.uage("取消"), otherButtonTitles: lang.uage("添加"), lang.uage("从源商店添加"))
            添加源对话框.alertViewStyle = UIAlertViewStyle.plainTextInput
            let 添加源输入框:UITextField = 添加源对话框.textField(at: 0) as UITextField!
            添加源对话框.tag = 200
            添加源输入框.keyboardType = UIKeyboardType.URL
            添加源输入框.text = "http://emoticon.moe/emoticon/yashi.xml"
            添加源对话框.show()
        } else {
            退出源管理()
        }
    }
    func 退出源管理()
    {
        p_storeIsOpen = false
        if (代理 != nil) {
            代理?.源管理页面代理：退出源管理页面时()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 提示框被点击
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        let 添加源输入框:
        UITextField = alertView.textField(at: 0) as UITextField!
        if (alertView.tag == 200) {
            if (buttonIndex == 1) {
                //添加
                加入源(添加源输入框.text! as NSString, 来自源商店: false)
            } else if (buttonIndex == 2) {
                //源商店
                UIApplication.shared.openURL(URL(string: "http://emoticon.moe/?cat=2")!)
            }
        }
    }
    
    @objc func 右上按钮点击(_ sender: UIBarButtonItem) {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        if (self.tableView.isEditing) {
            self.navigationItem.rightBarButtonItem?.title = lang.uage("完成")
            self.navigationItem.leftBarButtonItem?.title = lang.uage("添加")
        } else {
            self.navigationItem.rightBarButtonItem?.title = lang.uage("编辑")
            self.navigationItem.leftBarButtonItem?.title = lang.uage("返回")
        }
        
    }
    
    // MARK: - 表格分组数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - 表格行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 源列表.count - 1
    }
    
    // MARK: - 表格内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let 单元格标识:NSString = "Cell"
        var 单元格:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: 单元格标识 as String)
        if (单元格 == nil) {
            单元格 = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: 单元格标识 as String)
            单元格!.selectionStyle = UITableViewCell.SelectionStyle.default
            单元格!.accessoryType = UITableViewCell.AccessoryType.none
        }
        let 当前颜文字库:NSArray = 源列表.object(at: (indexPath as NSIndexPath).row + 1) as! NSArray
        let 当前颜文字库记录名称:NSString = 当前颜文字库.object(at: 0) as! NSString
        let 当前颜文字库原始名称:NSString = 当前颜文字库.object(at: 1) as! NSString
        let 当前颜文字库来源网址:NSString = 当前颜文字库.object(at: 2) as! NSString
        if (当前颜文字库记录名称.isEqual(to: "")) {
            单元格!.textLabel?.text = 当前颜文字库原始名称 as String
        } else {
            单元格!.textLabel?.text = NSString(format: "%@(%@)", 当前颜文字库记录名称 as String, 当前颜文字库原始名称 as String) as String
        }
        if (当前颜文字库来源网址.isEqual(to: p_nowurl as String)) {
            单元格!.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        单元格!.detailTextLabel?.text = 当前颜文字库来源网址 as String
        return 单元格!
    }
    
    // MARK: - 表格更改
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            objects.removeObjectAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            // MARK: - 删除源
            let 当前行:NSInteger = (indexPath as NSIndexPath).row + 1
            let 当前源对象:NSArray = 源列表.object(at: 当前行) as! NSArray
            let 当前源对象权限:NSArray = 当前源对象.object(at: 3) as! NSArray
            let 当前源对象网址:NSString = 当前源对象.object(at: 2) as! NSString
            var 当前源对象是否可删除:Bool = false
            for 当前权限用户名对象 in 当前源对象权限
            {
                let 当前权限用户名:NSString = 当前权限用户名对象 as! NSString
                if (当前权限用户名.isEqual(to: "user") || 当前权限用户名.isEqual(to: 全局_当前用户名 as String)) {
                    当前源对象是否可删除 = true
                    break
                }
            }
            if (当前源对象是否可删除) {
                源列表.removeObject(at: 当前行)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                if (源列表.count == 1) {
                    添加本地源()
                    tableView.reloadData()
                }
                文件管理器.deleteFile(当前源对象网址, smode: FileManager.saveMode.network)
                文件管理器.saveSources(源列表)
                选择源(tableView,didSelectRowAtIndexPath: IndexPath(row: 0, section: 0))
            } else {
                UIAlertView(title: lang.uage("无法删除这个源"), message: lang.uage("不具备删除这个源的权限"), delegate: nil, cancelButtonTitle: lang.uage("取消")).show()
            }
            
        } else if editingStyle == .insert {
        }
    }
    
    // MARK: - 表格编辑范围
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        return UITableViewCell.EditingStyle.delete
    }
    // MARK: - 表格是否可以移动项目
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return false
    }
    // MARK: - 表格是否可以编辑
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    // MARK: - 表格项目被移动
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        var 从:NSInteger = (sourceIndexPath as NSIndexPath).row
        var 至:NSInteger = (destinationIndexPath as NSIndexPath).row
        
    }
    // MARK: - 点击表格中的项目
    func 选择源(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        if (源列表.count > 0) {
            let 当前源对象:NSArray = 源列表.object(at: (indexPath as NSIndexPath).row + 1) as! NSArray
            let 当前源对象网址:NSString = 当前源对象.object(at: 2) as! NSString
            for i in 0...(源列表.count-2)
            {
                let 表格中当前位置:IndexPath = IndexPath(row: i, section: 0)
                let 当前循环单元格:UITableViewCell = tableView.cellForRow(at: 表格中当前位置)!
                当前循环单元格.accessoryType = UITableViewCell.AccessoryType.none
            }
            let 当前单元格:UITableViewCell = tableView.cellForRow(at: indexPath)!
            当前单元格.accessoryType = UITableViewCell.AccessoryType.checkmark
            保存源列表(当前源对象网址)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true) //闪一下
        选择源(tableView,didSelectRowAtIndexPath: indexPath)
    }
    func 保存源列表(_ o_url:NSString)
    {
        if (!o_url.isEqual(to: p_nowurl as String)) {
            p_nowurl = o_url
            用户设置.setValue(p_nowurl, forKey: "nowurl")
            用户设置.synchronize()
        }
    }
        override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String
        {
            return lang.uage("删掉喵")
        }

}
