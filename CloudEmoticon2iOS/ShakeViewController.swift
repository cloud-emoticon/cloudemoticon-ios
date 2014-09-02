//
//  ShakeViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫喵 on 14/8/26.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit
import CoreMotion

class ShakeViewController: UIViewController, UIAlertViewDelegate {

    var emolist:NSMutableArray = NSMutableArray.array()
    var emoNamelist:NSMutableArray = NSMutableArray.array()
    let 文件管理器:FileManager = FileManager()
    let className:NSString = "[摇一摇]"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = lang.uage("摇一摇")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "alertviewShake:", name: "alertviewShake", object: nil)

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
    
    func loadarray() -> NSArray?
    {
        let fileName:NSString = 文件管理器.FileName(FileManager.saveMode.NETWORK)
        let fulladd:NSString = 文件管理器.FileNameToFullAddress(fileName)
        let isDop:Bool = 文件管理器.ChkDupFile(fileName)
        if (isDop) {
            NSLog("%@加载正在使用的源...",className)
            let arr:NSArray = NSArray(contentsOfFile: fulladd)
            return arr
        }
        NSLog("%@加载默认源...",className)
        return nil
    }
    
    func loaddata()
    {
        var y_emoarr:NSArray = NSArray.array()
        var p_emoweb:NSArray? = loadarray()
        if(p_emoweb != nil)
        {
            let p_emoary:NSArray = p_emoweb!
            y_emoarr = p_emoary.objectAtIndex(3) as NSArray
        } else {
            let 内置源路径:NSString = NSBundle.mainBundle().pathForResource("default", ofType: "plist")!
            var p_emo:NSArray! = NSArray(contentsOfFile: 内置源路径)
            y_emoarr = p_emo.objectAtIndex(3) as NSArray
        }
        
        for g_emoobj in y_emoarr
        {
            var g_emoarr:NSArray = g_emoobj as NSArray
            for e_emo  in g_emoarr
            {
                if ((e_emo as? NSArray) != nil){
                    emolist.addObject(e_emo.objectAtIndex(0))
                    if (e_emo.count > 1) {
                        emoNamelist.addObject(e_emo.objectAtIndex(1))
                    } else {
                        emoNamelist.addObject("")
                    }
                }
            }
        }
    }
    
    func shake()
    {
        let emocount:Float = Float(emolist.count)
        let emonum:Int = Int((Float(arc4random_uniform(100)) * emocount) * 0.01)
        var alert:NSArray = [lang.uage("发现了颜文字"),emolist.objectAtIndex(emonum),lang.uage("添加到剪切板"),lang.uage("取消"),emoNamelist.objectAtIndex(emonum)]
        self.alertviewShake(alert)
    }
    
    func alertviewShake(altarr:NSArray)
    {
//        let altarr:NSArray = notification.object as NSArray
        let alert = UIAlertController(title: altarr.objectAtIndex(0) as NSString, message: altarr.objectAtIndex(1) as NSString, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: altarr.objectAtIndex(3) as NSString, style: .Default) {
            [weak alert] action in
            alert!.dismissViewControllerAnimated(true, completion: nil)
        }
        let okAction = UIAlertAction(title: altarr.objectAtIndex(2) as NSString, style: .Default) {
            [weak alert] action in
            let 要复制的颜文字:NSString = altarr.objectAtIndex(1) as NSString
            let 要复制的颜文字名称:NSString = altarr.objectAtIndex(4) as NSString
            self.摇一摇复制到剪贴板方法(要复制的颜文字,颜文字名称:要复制的颜文字名称)
            alert!.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        presentViewController (alert, animated: true, completion: nil)
    }
    
    func 摇一摇复制到剪贴板方法(要复制的颜文字:NSString, 颜文字名称 要复制的颜文字名称:NSString)
    {
        var 颜文字数组:NSMutableArray = [要复制的颜文字]
        if (!要复制的颜文字名称.isEqualToString("")) {
            颜文字数组.addObject(要复制的颜文字名称)
        }
        NSNotificationCenter.defaultCenter().postNotificationName("复制到剪贴板通知", object: 颜文字数组, userInfo: nil)
    }
}
