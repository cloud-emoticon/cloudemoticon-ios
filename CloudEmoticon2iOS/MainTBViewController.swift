//
//  MainTBViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/6.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class MainTBViewController: UITabBarController {
    
//    var load: LoadingView!
    
    @IBOutlet weak var tab: UITabBar!
    let 文件管理器:FileManager = FileManager()
    var 等待提示框:UIView? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        检查用户登录()
        let 进入视图:EnterView = EnterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(进入视图)
        initSetting()
        载入背景()
        文件管理器.补充空白数据()
       
        NotificationCenter.default.addObserver(self, selector: #selector(MainTBViewController.alertview(_:)), name: NSNotification.Name(rawValue: "alertview"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTBViewController.复制到剪贴板方法(_:)), name: NSNotification.Name(rawValue: "复制到剪贴板通知"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTBViewController.显示自动关闭的提示框方法(_:)), name: NSNotification.Name(rawValue: "显示自动关闭的提示框通知"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTBViewController.切换到源商店方法(_:)), name: NSNotification.Name(rawValue: "切换到源商店通知"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTBViewController.显示等待提示框方法(_:)), name: NSNotification.Name(rawValue: "显示等待提示框通知"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTBViewController.切换主题), name: NSNotification.Name(rawValue: "切换主题通知"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTBViewController.切换到主题管理(_:)), name: NSNotification.Name(rawValue: "切换到主题管理通知"), object: nil)
        self.language()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(MainTBViewController.延迟切换主题), userInfo: nil, repeats: false)
        
        //执行测试用代码()
    }
    
    func 执行测试用代码() {
//        let 同步数据格式转换测试:UserSync = UserSync()
//        同步数据格式转换测试.转换为同步用数据格式()
    }
    
    @objc func 延迟切换主题() {
        切换主题()
        let Kag:Kagurazaka = Kagurazaka()
        Kag.KagurazakaArray("　", b: "喵")
        NSLog("[MainTBViewController]云颜文字启动完毕。")
    }
    
    func initSetting()
    {
        let defaults:UserDefaults = UserDefaults.standard
        let noFirstRun:Bool = defaults.bool(forKey: "noFirstRun")
        if (!noFirstRun) {
            defaults.set(true, forKey: "noFirstRun")
            defaults.synchronize()
            self.selectedIndex = 1
        }
    }

    
    func 载入背景()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "widget2.png"), for: UIBarMetrics.default)
//        self.tabBar.backgroundImage = UIImage(named: "widget2.png")
    }
    
//MARK - 主题
    @objc func 切换主题()
    {
//        self.tabBar.tintColor = UIColor(red: 240, green: 240, blue: 240, alpha: 255) //TabBar颜色
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 240, green: 240, blue: 240, alpha: 255) //NavBar颜色
//        self.navigationController?.navigationBar.tintColor = UIColor.blueColor() //NavBar按钮颜色
//        let titlecolor = NSDictionary(object: UIColor.blackColor(),
//            forKey:NSForegroundColorAttributeName)
//        self.navigationController?.navigationBar.titleTextAttributes = titlecolor as [NSObject : AnyObject] //NavBar标题颜色
        
        //默认设置
        let items:NSArray = self.tabBar.items! as NSArray
        for i in 0...items.count - 1 {
            let nowVC:UITabBarItem = items.object(at: i) as! UITabBarItem
            if(i == 0){
                nowVC.image = UIImage(named: "edit-vector.png") //自定表情
            }
            if(i == 1){
                nowVC.image = UIImage(named: "shared-vector.png") //云颜文字
            }
            if(i == 2){
                nowVC.image = UIImage(named: "idea-vector.png") //附加功能
            }
            if(i == 3){
                nowVC.image = UIImage(named: "settings-vector.png") //设置
            }
            nowVC.selectedImage = nil
        }
        
        NSLog("[Skin]->MainTBViewController")
//        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        //默认设置
        let 底部工具栏着色视图:UIImageView? = self.tabBar.viewWithTag(515514) as? UIImageView
        if (底部工具栏着色视图 != nil) {
            底部工具栏着色视图?.image = nil
        }
        self.tabBar.barTintColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.tabBar.backgroundColor = UIColor.clear
        self.tabBar.selectionIndicatorImage = nil
        self.tabBar.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        let tool_titletextattributes_dic = NSDictionary(object: UIColor.black, forKey:convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) as NSCopying)
        UITabBarItem.appearance().setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary(tool_titletextattributes_dic as? [String : AnyObject]), for: UIControl.State())
        
        if (全局_皮肤设置.count > 0 && 全局_皮肤设置.object(forKey: "md5") != nil) {
            let 主题参数转对象:Skin2Object = Skin2Object()
            
            //图片文件名：底部工具栏“自定表情”按钮图标 ok
            let items:NSArray = self.tabBar.items! as NSArray
            let myemo:UITabBarItem = items.object(at: 0) as! UITabBarItem
            let tool_icon_myemo_S:String = 全局_皮肤设置.object(forKey: "tool_icon_myemo") as! String
            NSLog("[Skin]tool_icon_myemo_S=%@",tool_icon_myemo_S)
            if (tool_icon_myemo_S != "null") {
                let tool_icon_myemo:UIImage? = 主题参数转对象.image(tool_icon_myemo_S) //tool_icon_myemo_S
                if (tool_icon_myemo != nil) {
                    myemo.image = tool_icon_myemo
                }
            }
            
            let myemo_select:UITabBarItem = items.object(at: 0) as! UITabBarItem
            let tool_icon_myemo_select_S:String = 全局_皮肤设置.object(forKey: "tool_icon_myemo_select") as! String
            NSLog("[Skin]tool_icon_myemo_select_S=%@",tool_icon_myemo_select_S)
            if (tool_icon_myemo_select_S != "null") {
                let tool_icon_myemo_select:UIImage? = 主题参数转对象.image(tool_icon_myemo_select_S) //tool_icon_myemo_select_S
                if (tool_icon_myemo_select != nil) {
                    myemo.selectedImage = tool_icon_myemo_select
                }
            }

            //图片文件名：底部工具栏“云颜文字”按钮图标 ok
            let cloemo:UITabBarItem = items.object(at: 1) as! UITabBarItem
            let tool_icon_cloemo_S:String = 全局_皮肤设置.object(forKey: "tool_icon_cloemo") as! String
            NSLog("[Skin]tool_icon_cloemo_S=%@",tool_icon_cloemo_S)
            if (tool_icon_cloemo_S != "null") {
                let tool_icon_cloemo:UIImage? = 主题参数转对象.image(tool_icon_cloemo_S) //tool_icon_cloemo_S
                if (tool_icon_cloemo != nil) {
                    cloemo.image = tool_icon_cloemo
                }
            }

            let cloemo_select:UITabBarItem = items.object(at: 1) as! UITabBarItem
            let tool_icon_cloemo_select_S:String = 全局_皮肤设置.object(forKey: "tool_icon_cloemo_select") as! String
            NSLog("[Skin]tool_icon_cloemo_select_S=%@",tool_icon_cloemo_select_S)
            if (tool_icon_cloemo_select_S != "null") {
                let tool_icon_cloemo_select:UIImage? = 主题参数转对象.image(tool_icon_cloemo_select_S) //tool_icon_cloemo_select_S
                if (tool_icon_cloemo_select != nil) {
                    cloemo.selectedImage = tool_icon_cloemo_select
                }
            }
            //图片文件名：底部工具栏“附加工具”按钮图标 ok
            let addons:UITabBarItem = items.object(at: 2) as! UITabBarItem
            let tool_icon_addons_S:String = 全局_皮肤设置.object(forKey: "tool_icon_addons") as! String
            NSLog("[Skin]tool_icon_addons_S=%@",tool_icon_addons_S)
            if (tool_icon_addons_S != "null") {
                let tool_icon_addons:UIImage? = 主题参数转对象.image(tool_icon_addons_S) //tool_icon_addons_S
                if (tool_icon_addons != nil) {
                    addons.image = tool_icon_addons
                }
            }

            let addons_select:UITabBarItem = items.object(at: 2) as! UITabBarItem
            let tool_icon_addons_select_S:String = 全局_皮肤设置.object(forKey: "tool_icon_addons_select") as! String
            NSLog("[Skin]tool_icon_addons_select_S=%@",tool_icon_addons_select_S)
            if (tool_icon_addons_select_S != "null") {
                let tool_icon_addons_select:UIImage? = 主题参数转对象.image(tool_icon_addons_select_S) //tool_icon_addons_select_S
                if (tool_icon_addons_select != nil) {
                    addons.selectedImage = tool_icon_addons_select
                }
            }
            //图片文件名：底部工具栏“设置”按钮图标 ok
            let set:UITabBarItem = items.object(at: 3) as! UITabBarItem
            let tool_icon_set_S:String = 全局_皮肤设置.object(forKey: "tool_icon_set") as! String
            NSLog("[Skin]tool_icon_set_S=%@",tool_icon_set_S)
            if (tool_icon_set_S != "null") {
                let tool_icon_set:UIImage? = 主题参数转对象.image(tool_icon_set_S) //tool_icon_set_S
                if (tool_icon_set != nil) {
                    set.image = tool_icon_set
                }
            }
            let set_select:UITabBarItem = items.object(at: 3) as! UITabBarItem
            let tool_icon_set_select_S:String = 全局_皮肤设置.object(forKey: "tool_icon_set_select") as! String
            NSLog("[Skin]tool_icon_set_select_S=%@",tool_icon_set_select_S)
            if (tool_icon_set_select_S != "null") {
                let tool_icon_set_select:UIImage? = 主题参数转对象.image(tool_icon_set_select_S) //tool_icon_set_select_S
                if (tool_icon_set_select != nil) {
                    set.selectedImage = tool_icon_set_select
                }
            }
            //底部工具栏自定义配置 ok
            var 底部工具栏着色视图:UIImageView? = self.tabBar.viewWithTag(515514) as? UIImageView
            if (底部工具栏着色视图 == nil) {
                底部工具栏着色视图 = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tabBar.frame.width, height: self.tabBar.frame.height))
                底部工具栏着色视图?.tag = 515514
                //底部工具栏着色视图?.backgroundColor = UIColor.orangeColor()
                self.tabBar.insertSubview(底部工具栏着色视图!, at: 1)
//                self.tabBar.opaque = true
            }

            //图片文件名：底部工具栏背景图片 ok
            let tool_backgroundimage_S:String = 全局_皮肤设置.object(forKey: "tool_backgroundimage") as! String
            NSLog("[Skin]tool_backgroundimage_S=%@",tool_backgroundimage_S)
            if (tool_backgroundimage_S != "null") {
                let tool_backgroundimage:UIImage? = 主题参数转对象.image(tool_backgroundimage_S) //tool_backgroundimage_S
                if (tool_backgroundimage != nil) {
                    底部工具栏着色视图?.image = tool_backgroundimage
                }
            }

            //RGBA色值：底部工具栏背景颜色 ok?
            let tool_selecttintcolor_S:String = 全局_皮肤设置.object(forKey: "tool_selecttintcolor") as! String
            NSLog("[Skin]tool_selecttintcolor_S=%@",tool_selecttintcolor_S)
            if (tool_selecttintcolor_S != "null") {
                let tool_selecttintcolor:UIColor? = 主题参数转对象.color(tool_selecttintcolor_S) //tool_selecttintcolor_S
                if (tool_selecttintcolor != nil) {
                    self.tabBar.barTintColor = tool_selecttintcolor
                    self.tabBar.backgroundColor = UIColor.clear
                }
            }

            //图片文件名：底部工具栏当前选中按钮的背景图片 ok
            let tool_selectionimage_S:String = 全局_皮肤设置.object(forKey: "tool_selectionimage") as! String
            NSLog("[Skin]tool_selectionimage_S=%@",tool_selectionimage_S)
            if (tool_selectionimage_S != "null") {
                let tool_selectionimage:UIImage? = 主题参数转对象.image(tool_selectionimage_S) //tool_selectionimage_S
                if (tool_selectionimage != nil) {
                    self.tabBar.selectionIndicatorImage = tool_selectionimage
                }
            }
            //RGBA色值：底部工具栏当前选中按钮的颜色 ok
            let tool_tintcolor_S:String = 全局_皮肤设置.object(forKey: "tool_tintcolor") as! String
            NSLog("[Skin]tool_tintcolor_S=%@",tool_tintcolor_S)
            if (tool_tintcolor_S != "null") {
                let tool_tintcolor:UIColor? = 主题参数转对象.color(tool_tintcolor_S) //tool_tintcolor_S
                if (tool_tintcolor != nil) {
                    self.tabBar.tintColor = tool_tintcolor
                }
            }

            //RGBA色值：底部工具栏未选中按钮的颜色 NO!
            
            let tool_unselecttintcolor_S:String = 全局_皮肤设置.object(forKey: "tool_unselecttintcolor") as! String
            NSLog("[Skin]tool_unselecttintcolor_S=%@",tool_unselecttintcolor_S)
            if (tool_unselecttintcolor_S != "null") {
                let tool_unselecttintcolor:UIColor? = 主题参数转对象.color(tool_unselecttintcolor_S)
                if (tool_unselecttintcolor != nil) {
                    let tool_unselecttintcolor_dic = NSDictionary(object: tool_unselecttintcolor!,
                        forKey:convertFromNSAttributedStringKey(NSAttributedString.Key.backgroundColor) as NSCopying)
//                    UITabBarItem.appearance().setTitleTextAttributes(tool_unselecttintcolor_dic as [NSObject : AnyObject], forState: UIControlState.Normal)
                }
            }
            //RGBA色值：底部工具栏按钮文字的颜色 ok
            let tool_titletextattributes_S:String = 全局_皮肤设置.object(forKey: "tool_titletextattributes") as! String
            NSLog("[Skin]tool_titletextattributes_S=%@",tool_titletextattributes_S)
            if (tool_titletextattributes_S != "null") {
                let tool_titletextattributes:UIColor? = 主题参数转对象.color(tool_titletextattributes_S)
                if (tool_titletextattributes != nil) {
                    let tool_titletextattributes_dic = NSDictionary(object: tool_titletextattributes!,
                        forKey:convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) as NSCopying)
                    UITabBarItem.appearance().setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary(tool_titletextattributes_dic as? [String : AnyObject]), for: UIControl.State())
                }
            }
        }
    }
    
    func language()
    {
        let tbitemtitle:NSArray = [lang.uage("自定表情"),lang.uage("云颜文字"),lang.uage("附加工具"),lang.uage("设置")]
        let items:NSArray = self.tabBar.items! as NSArray
        for i in 0...items.count - 1 {
            let nowVC:UITabBarItem = items.object(at: i) as! UITabBarItem
            nowVC.title = tbitemtitle.object(at: i) as? String
        }
    }
    
    @objc func 切换到源商店方法(_ notification:Notification)
    {
        self.selectedIndex = 1
        let vcs:NSArray? = self.viewControllers as NSArray?
        let cen:UINavigationController = vcs?.object(at: 1) as! UINavigationController
        let cea:NSArray? = cen.viewControllers as NSArray?
        let cev:CEViewController = cea?.object(at: 0) as! CEViewController
        let URL识别数组:NSArray = notification.object as! NSArray
        cev.切换到源管理页面(URL识别数组.object(at: 0) as? NSString)
    }
    @objc func 切换到主题管理(_ notification:Notification)
    {
        self.selectedIndex = 3
        let 工具栏视图组:NSArray? = self.viewControllers as NSArray?
        let 设置视图导航:UINavigationController = 工具栏视图组?.object(at: 3) as! UINavigationController
        let 设置视图导航视图组:NSArray = 设置视图导航.viewControllers as NSArray
        let 设置视图:SetTableViewController = 设置视图导航视图组.object(at: 0) as! SetTableViewController
        let 要下载的文件路径:String = notification.object as! String
        设置视图.前往主题管理(要下载的文件路径)
    }
    
    @objc func 复制到剪贴板方法(_ notification:Notification)
    {
        let 要复制的颜文字数组:NSArray = notification.object as! NSArray
        let 要复制的颜文字:NSString = 要复制的颜文字数组.object(at: 0)as! NSString
        
        显示自动关闭的提示框(NSString(format: "“ %@ ” %@", 要复制的颜文字, lang.uage("已复制到剪贴板")))
        
        let 历史记录:NSMutableArray = NSMutableArray()
        let 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.history)
        if (文件中的数据 != nil) {
            历史记录.addObjects(from: 文件中的数据! as [AnyObject])
        }
        for i in 0 ..< 历史记录.count {
//        for (var i:Int = 0; i < 历史记录.count; i += 1) {
            //            if (i >= 全部历史数组.count) {
            //                break
            //            }
            let 当前历史条目对象:AnyObject = 历史记录.object(at: i) as AnyObject
            let 当前历史条目数组:NSArray = 当前历史条目对象 as! NSArray
            let 当前历史条目:NSString = 当前历史条目数组.object(at: 0) as! NSString
            //NSLog("当前历史条目=\(当前历史条目),要复制的颜文字=\(要复制的颜文字)")
            if (当前历史条目.isEqual(to: 要复制的颜文字 as String)) {
                //NSLog("【删除】\n")
                历史记录.removeObject(at: i)
//                if (i > 0) {
//                    i -= 1
//                }
            }
        }
        历史记录.insert(要复制的颜文字数组, at: 0)
        
        while (true) {
            if (历史记录.count > 50) {
                历史记录.removeLastObject()
            } else {
                break
            }
        }
        文件管理器.SaveArrayToFile(历史记录, smode: FileManager.saveMode.history)
        保存数据到输入法()
        let 剪贴板:UIPasteboard = UIPasteboard.general
        剪贴板.string = 要复制的颜文字 as String
        NSLog(要复制的颜文字 as String)
        if (UserDefaults.standard.bool(forKey: "exitaftercopy")) {
            let window:UIWindow? = UIApplication.shared.delegate?.window!
            UIView.setAnimationCurve(UIView.AnimationCurve.easeOut)
            UIView.animate(withDuration: 0.3, animations: {
                window?.alpha = 0
                window?.frame = CGRect(x: window!.center.x, y: window!.center.x, width: 0, height: 0)
                }, completion: {
                    (completion) in
                    if completion {
                        exit(0)
                    }
            })
        }
    }
    
    @objc func 显示自动关闭的提示框方法(_ notification:Notification)
    {
        let 提示文字:NSString = notification.object as! NSString
        显示自动关闭的提示框(提示文字)
    }
    
    @objc func 显示等待提示框方法(_ notification:Notification)
    {
        let 参数:NSNumber = notification.object as! NSNumber
        let 开关:Bool = 参数.boolValue
        if (开关 == true) {
            if (等待提示框 == nil) {
                等待提示框 = WaitView(frame: self.view.frame)
                self.view.addSubview(等待提示框!)
//                等待提示框.初始化()
            }
        } else {
            if (等待提示框 != nil) {
                等待提示框?.removeFromSuperview()
                等待提示框 = nil
            }
        }
    }
    
    func 显示自动关闭的提示框(_ 提示文字:NSString)
    {
        var 提示信息框Y坐标:CGFloat = 74
        if (self.view.frame.size.width > self.view.frame.size.height) {
            提示信息框Y坐标 = 42
        }
        let 单元格高度:CGFloat = 计算单元格高度(提示文字, 字体大小:17, 单元格宽度: self.view.frame.size.width - 20)
        let 提示信息框:NotificationView = NotificationView(frame: CGRect(x: 10, y: 提示信息框Y坐标, width: self.view.frame.size.width - 20, height: 单元格高度))
        self.view.addSubview(提示信息框)
        提示信息框.显示提示(提示文字)
    }
    
    @objc func alertview(_ notification:Notification)
    {
        let altarr:NSArray = notification.object as! NSArray
        //数组：title，message，btn title
        let alert = UIAlertController(title: altarr.object(at: 0) as! NSString as String, message: altarr.object(at: 1) as! NSString as String, preferredStyle: .alert)
        let okAction = UIAlertAction(title: altarr.object(at: 2) as! NSString as String, style: .default) {
            [weak alert] action in
            //print("OK Pressed")
            alert!.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present (alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func shouldAutorotate() -> Bool
//    {
//        return true
//    }
    
    // MARK: - 发出屏幕旋转通知
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        let newScreenSize:NSArray = [size.width, size.height]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "屏幕旋转通知"), object: newScreenSize)
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
