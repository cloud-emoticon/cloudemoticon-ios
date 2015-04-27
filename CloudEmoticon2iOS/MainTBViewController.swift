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
        self.view.backgroundColor = UIColor.whiteColor()
        initSetting()
        载入背景()
        文件管理器.补充空白数据()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "alertview:", name: "alertview", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "复制到剪贴板方法:", name: "复制到剪贴板通知", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "显示自动关闭的提示框方法:", name: "显示自动关闭的提示框通知", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "切换到源商店方法:", name: "切换到源商店通知", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "显示等待提示框方法:", name: "显示等待提示框通知", object: nil)
        self.language()
    }
    
    func initSetting()
    {
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let noFirstRun:Bool = defaults.boolForKey("noFirstRun")
        if (!noFirstRun) {
            defaults.setBool(true, forKey: "noFirstRun")
            defaults.synchronize()
            self.selectedIndex = 1
        }
    }

    
    func 载入背景()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "widget2.png"), forBarMetrics: UIBarMetrics.Default)
//        self.tabBar.backgroundImage = UIImage(named: "widget2.png")
    }
    
//MARK - 主题
    func 切换主题()
    {
        self.tabBar.tintColor = UIColor(red: 240, green: 240, blue: 240, alpha: 255) //TabBar颜色
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 240, green: 240, blue: 240, alpha: 255) //NavBar颜色
        self.navigationController?.navigationBar.tintColor = UIColor.blueColor() //NavBar按钮颜色
        let titlecolor = NSDictionary(object: UIColor.blackColor(),
            forKey:NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = titlecolor as [NSObject : AnyObject] //NavBar标题颜色
        
        let items:NSArray = self.tabBar.items!
        for i in 0...items.count - 1 {
            let nowVC:UITabBarItem = items.objectAtIndex(i) as! UITabBarItem
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
        }

        
        //紫喵留：背景图就写入到Color的相应位置就好了喵
    }
    
    func language()
    {
        let tbitemtitle:NSArray = [lang.uage("自定表情"),lang.uage("云颜文字"),lang.uage("附加工具"),lang.uage("设置")]
        let items:NSArray = self.tabBar.items!
        for i in 0...items.count - 1 {
            let nowVC:UITabBarItem = items.objectAtIndex(i) as! UITabBarItem
            nowVC.title = tbitemtitle.objectAtIndex(i) as? String
        }
    }
    
    func 切换到源商店方法(notification:NSNotification)
    {
        self.selectedIndex = 1
        let vcs:NSArray? = self.viewControllers as NSArray?
        let cen:UINavigationController = vcs?.objectAtIndex(1) as! UINavigationController
        let cea:NSArray? = cen.viewControllers as NSArray?
        let cev:CEViewController = cea?.objectAtIndex(0) as! CEViewController
        let URL识别数组:NSArray = notification.object as! NSArray
        cev.切换到源管理页面(URL识别数组.objectAtIndex(0) as? NSString)
    }
    
    func 复制到剪贴板方法(notification:NSNotification)
    {
        let 要复制的颜文字数组:NSArray = notification.object as! NSArray
        let 要复制的颜文字:NSString = 要复制的颜文字数组.objectAtIndex(0)as! NSString
        
        显示自动关闭的提示框(NSString(format: "“ %@ ” %@", 要复制的颜文字, lang.uage("已复制到剪贴板")))
        
        var 历史记录:NSMutableArray = NSMutableArray()
        var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.HISTORY)
        if (文件中的数据 != nil) {
            历史记录.addObjectsFromArray(文件中的数据! as [AnyObject])
        }
        for (var i:Int = 0; i < 历史记录.count; i++) {
            //            if (i >= 全部历史数组.count) {
            //                break
            //            }
            let 当前历史条目对象:AnyObject = 历史记录.objectAtIndex(i)
            let 当前历史条目数组:NSArray = 当前历史条目对象 as! NSArray
            let 当前历史条目:NSString = 当前历史条目数组.objectAtIndex(0) as! NSString
            //NSLog("当前历史条目=\(当前历史条目),要复制的颜文字=\(要复制的颜文字)")
            if (当前历史条目.isEqualToString(要复制的颜文字 as String)) {
                //NSLog("【删除】\n")
                历史记录.removeObjectAtIndex(i)
                if (i > 0) {
                    i--
                }
            }
        }
        历史记录.insertObject(要复制的颜文字数组, atIndex: 0)
        
        while (true) {
            if (历史记录.count > 50) {
                历史记录.removeLastObject()
            } else {
                break
            }
        }
        文件管理器.SaveArrayToFile(历史记录, smode: FileManager.saveMode.HISTORY)
        保存数据到输入法()
        var 剪贴板:UIPasteboard = UIPasteboard.generalPasteboard()
        剪贴板.string = 要复制的颜文字 as String
        if (NSUserDefaults.standardUserDefaults().boolForKey("exitaftercopy")) {
            let window:UIWindow? = UIApplication.sharedApplication().delegate?.window!
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
            UIView.animateWithDuration(0.3, animations: {
                window?.alpha = 0
                window?.frame = CGRectMake(window!.center.x, window!.center.x, 0, 0)
                }, completion: {
                    (Bool completion) in
                    if completion {
                        exit(0)
                    }
            })
        }
    }
    
    func 显示自动关闭的提示框方法(notification:NSNotification)
    {
        let 提示文字:NSString = notification.object as! NSString
        显示自动关闭的提示框(提示文字)
    }
    
    func 显示等待提示框方法(notification:NSNotification)
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
    
    func 显示自动关闭的提示框(提示文字:NSString)
    {
        var 提示信息框Y坐标:CGFloat = 74
        if (self.view.frame.size.width > self.view.frame.size.height) {
            提示信息框Y坐标 = 42
        }
        let 单元格高度:CGFloat = heightForString(提示文字, FontSize: 17, andWidth: self.view.frame.size.width - 20)
        var 提示信息框:NotificationView = NotificationView(frame: CGRectMake(10, 提示信息框Y坐标, self.view.frame.size.width - 20, 单元格高度))
        self.view.addSubview(提示信息框)
        提示信息框.显示提示(提示文字)
    }
    
    func alertview(notification:NSNotification)
    {
        let altarr:NSArray = notification.object as! NSArray
        //数组：title，message，btn title
        let alert = UIAlertController(title: altarr.objectAtIndex(0) as! NSString as String, message: altarr.objectAtIndex(1) as! NSString as String, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: altarr.objectAtIndex(2) as! NSString as String, style: .Default) {
            [weak alert] action in
            //print("OK Pressed")
            alert!.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(okAction)
        presentViewController (alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func shouldAutorotate() -> Bool
//    {
//        return true
//    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        let newScreenSize:NSArray = [size.width, size.height]
        NSNotificationCenter.defaultCenter().postNotificationName("transition", object: newScreenSize)
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
