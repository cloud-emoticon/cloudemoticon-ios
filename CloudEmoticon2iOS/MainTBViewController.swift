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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        //NSNotificationCenter.defaultCenter().postNotificationName("loadwebdata", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "alertview:", name: "alertview", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "复制到剪贴板方法:", name: "复制到剪贴板通知", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "显示自动关闭的提示框方法:", name: "显示自动关闭的提示框通知", object: nil)
        
        
        self.language()
    }
    
    func language()
    {
        let tbitemtitle:NSArray = [lang.uage("自定表情"),lang.uage("云颜文字"),lang.uage("附加工具"),lang.uage("设置")]
        let items:NSArray = self.tabBar.items
        for i in 0...items.count - 1 {
            let nowVC:UITabBarItem = items.objectAtIndex(i) as UITabBarItem
            nowVC.title = tbitemtitle.objectAtIndex(i) as NSString
        }
    }
    
    func 复制到剪贴板方法(notification:NSNotification)
    {
        let 要复制的颜文字数组:NSArray = notification.object as NSArray
        let 要复制的颜文字:NSString = 要复制的颜文字数组.objectAtIndex(0) as NSString
        
        显示自动关闭的提示框(NSString(format: "“ %@ ” %@", 要复制的颜文字, lang.uage("已复制到剪贴板")))
        
        var 历史记录:NSMutableArray = NSMutableArray.array()
        var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.HISTORY)
        历史记录.addObject(要复制的颜文字数组)
        if (文件中的数据 != nil) {
            历史记录.addObjectsFromArray(文件中的数据!)
        }
        if (历史记录.count > 100) {
            历史记录.removeLastObject()
        }
        文件管理器.SaveArrayToFile(历史记录, smode: FileManager.saveMode.HISTORY)
        var 剪贴板:UIPasteboard = UIPasteboard.generalPasteboard()
        剪贴板.string = 要复制的颜文字
        if (NSUserDefaults.standardUserDefaults().boolForKey("exitaftercopy")) {
            let window:UIWindow? = UIApplication.sharedApplication().delegate.window?
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
            UIView.animateWithDuration(0.35, animations: {
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
        let 提示文字:NSString = notification.object as NSString
        显示自动关闭的提示框(提示文字)
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
    
    func heightForString(value: NSString, FontSize fontSize:CGFloat, andWidth width:CGFloat) -> CGFloat
    {
        var detailTextView:UITextView = UITextView(frame: CGRectMake(0, 0, width, 0))
        detailTextView.font = UIFont.systemFontOfSize(fontSize)
        detailTextView.text = value
        var deSize:CGSize = detailTextView.sizeThatFits(CGSizeMake(width,CGFloat.max))
        return deSize.height
    }
    
    func alertview(notification:NSNotification)
    {
        let altarr:NSArray = notification.object as NSArray
        //数组：title，message，btn title
        let alert = UIAlertController(title: altarr.objectAtIndex(0) as NSString, message: altarr.objectAtIndex(1) as NSString, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: altarr.objectAtIndex(2) as NSString, style: .Default) {
            [weak alert] action in
//            print("OK Pressed")
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
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator!)
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
