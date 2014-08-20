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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NSNotificationCenter.defaultCenter().postNotificationName("loadwebdata", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "alertview:", name: "alertview", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "复制到剪贴板方法:", name: "复制到剪贴板通知", object: nil)
    }
    
    func 复制到剪贴板方法(notification:NSNotification)
    {
        let 要复制的文本:NSString = notification.object as NSString
        var 提示信息框Y坐标:CGFloat = 74
        if (self.view.frame.size.width > self.view.frame.size.height) {
            提示信息框Y坐标 = 42
        }
        var 提示信息框:NotificationView = NotificationView(frame: CGRectMake(10, 提示信息框Y坐标, self.view.frame.size.width - 20, 40))
        self.view.addSubview(提示信息框)
        提示信息框.显示颜文字复制到剪贴板提示(要复制的文本)
        var 剪贴板:UIPasteboard = UIPasteboard.generalPasteboard()
        剪贴板.string = 要复制的文本
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
