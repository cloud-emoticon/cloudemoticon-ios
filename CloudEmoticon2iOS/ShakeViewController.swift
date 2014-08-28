//
//  ShakeViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫 on 14/8/26.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit
import CoreMotion

class ShakeViewController: UIViewController, UIAlertViewDelegate {

    var emolist:NSMutableArray = NSMutableArray.array()
    let 文件管理器:FileManager = FileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "alertviewShake:", name: "alertviewShake", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "摇一摇复制到剪贴板方法:", name: "摇一摇复制到剪贴板通知", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "显示自动关闭的提示框方法:", name: "显示自动关闭的提示框通知", object: nil)

    loaddata()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.becomeFirstResponder()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.resignFirstResponder()
        super.viewDidDisappear(true)
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent!) {
        if(motion == UIEventSubtype.MotionShake){
        shake()
        }
    }
    
    func loaddata()
    {
        let 内置源路径:NSString = NSBundle.mainBundle().pathForResource("default", ofType: "plist")!
        var p_emo:NSArray! = NSArray(contentsOfFile: 内置源路径)
        var y_emoarr:NSArray = NSArray.array()
        var p_emoweb:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.NETWORK)
        if(p_emoweb != nil)
        {
            let p_emoary:NSArray = p_emoweb!
            y_emoarr = p_emoary.objectAtIndex(3) as NSArray
        } else {
            y_emoarr = p_emo.objectAtIndex(3) as NSArray
        }
        
        for g_emoobj in y_emoarr
        {
            var g_emoarr:NSArray = g_emoobj as NSArray
            for e_emo  in g_emoarr
            {
                if ((e_emo as? NSArray) != nil){
                    emolist.addObject(e_emo.objectAtIndex(0))
                }
            }
        }
    }
    
    func shake()
    {
        let emocount:Float = Float(emolist.count)
        let emonum:Int = Int((Float(arc4random_uniform(100)) * emocount) * 0.01)
        println(emolist.objectAtIndex(emonum))
        var alert:NSArray = ["发现了颜文字！",emolist.objectAtIndex(emonum),"添加到剪切板","取消"]
        NSNotificationCenter.defaultCenter().postNotificationName("alertviewShake", object: alert)
        
    }
    
    func alertviewShake(notification:NSNotification)
    {
        let altarr:NSArray = notification.object as NSArray
        //数组：title，message，btn title
        let alert = UIAlertController(title: altarr.objectAtIndex(0) as NSString, message: altarr.objectAtIndex(1) as NSString, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: altarr.objectAtIndex(3) as NSString, style: .Default) {
            [weak alert] action in
            alert!.dismissViewControllerAnimated(true, completion: nil)
        }
        let okAction = UIAlertAction(title: altarr.objectAtIndex(2) as NSString, style: .Default) {
            [weak alert] action in
            NSNotificationCenter.defaultCenter().postNotificationName("摇一摇复制到剪贴板通知", object: [altarr.objectAtIndex(1)],userInfo: nil)
            alert!.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        presentViewController (alert, animated: true, completion: nil)
    }
    
    func 摇一摇复制到剪贴板方法(notification:NSNotification)
    {
        let 要复制的颜文字数组:NSArray = notification.object as NSArray
        let 要复制的颜文字:NSString = 要复制的颜文字数组.objectAtIndex(0) as NSString
        
        显示自动关闭的提示框(NSString(format: "“ %@ ” 已复制到剪贴板", 要复制的颜文字))
        
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
        var 提示信息框:NotificationView = NotificationView(frame: CGRectMake(10, 提示信息框Y坐标, self.view.frame.size.width - 20, 40))
        self.view.addSubview(提示信息框)
        提示信息框.显示提示(提示文字)
    }


     /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
