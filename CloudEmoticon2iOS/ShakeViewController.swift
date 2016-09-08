//
//  ShakeViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫喵 on 14/8/26.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit
import CoreMotion
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class ShakeViewController: UIViewController, UIAlertViewDelegate {

    var emolist:NSMutableArray = NSMutableArray()
    var emoNamelist:NSMutableArray = NSMutableArray()
    let 文件管理器:FileManager = FileManager()
    let className:NSString = "[摇一摇]"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = lang.uage("摇一摇")
        NotificationCenter.default.addObserver(self, selector: #selector(ShakeViewController.alertviewShake(_:)), name: NSNotification.Name(rawValue: "alertviewShake"), object: nil)
        if(p_emodata.count < 3){
            NSLog("%@没有数据，加载数据",className)
            CEViewController().载入数据(NetDownloadTo.cloudemoticon)
        }
        loaddata()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.resignFirstResponder()
        super.viewDidDisappear(true)
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(motion == UIEventSubtype.motionShake){
        shake()
        }
    }
    
    func loadarray() -> NSArray?
    {
        let fileName:NSString = 文件管理器.FileName(FileManager.saveMode.network)
        let fulladd:NSString = 文件管理器.FileNameToFullAddress(fileName)
        let arr:NSArray? = p_emodata
        if(arr != nil && arr?.count >= 3){
            NSLog("%@加载正在使用的源...",className)
            return arr
        } else {
        NSLog("%@加载默认源...",className)
        return nil
        }
    }
    
    func loaddata()
    {
        var y_emoarr:NSArray = NSArray()
        let p_emoweb:NSArray? = loadarray()
        if(p_emoweb != nil)
        {
            let p_emoary:NSArray = p_emoweb!
            y_emoarr = p_emoary.object(at: 3) as! NSArray
        } else {
            let 内置源路径:NSString = Bundle.main.path(forResource: "default", ofType: "plist")! as NSString
            let p_emo:NSArray! = NSArray(contentsOfFile: 内置源路径 as String)
            y_emoarr = p_emo.object(at: 3) as! NSArray
        }
        emolist.removeAllObjects()
        emoNamelist.removeAllObjects()
        for g_emoobj in y_emoarr
        {
            let g_emoarr:NSArray = g_emoobj as! NSArray
            for e_emo  in g_emoarr
            {
                if ((e_emo as? NSArray) != nil){
                    emolist.add((e_emo as AnyObject).object!(at: 0))
                    if ((e_emo as AnyObject).count > 1) {
                        emoNamelist.add((e_emo as AnyObject).object!(at: 1))
                    } else {
                        emoNamelist.add("")
                    }
                }
            }
        }
    }
    
    func shake()
    {
        let emocount:Float = Float(emolist.count)
        let emonum:Int = Int((Float(arc4random_uniform(100)) * emocount) * 0.01)
        let alert:NSArray = [lang.uage("发现了颜文字"),emolist.object(at: emonum),lang.uage("添加到剪切板"),lang.uage("取消"),emoNamelist.object(at: emonum)]
        self.alertviewShake(alert)
    }
    
    func alertviewShake(_ altarr:NSArray)
    {
//        let altarr:NSArray = notification.object as NSArray
        let alert = UIAlertController(title: altarr.object(at: 0) as? String, message: altarr.object(at: 1) as? String, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: (altarr.object(at: 3) as? String)!, style: .default) {
            [weak alert] action in
            alert!.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: altarr.object(at: 2)as? String, style: .default) {
            [weak alert] action in
            let 要复制的颜文字:NSString = altarr.object(at: 1) as! NSString
            let 要复制的颜文字名称:NSString = altarr.object(at: 4) as! NSString
            self.摇一摇复制到剪贴板方法(要复制的颜文字,颜文字名称:要复制的颜文字名称)
            alert!.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present (alert, animated: true, completion: nil)
    }
    
    func 摇一摇复制到剪贴板方法(_ 要复制的颜文字:NSString, 颜文字名称 要复制的颜文字名称:NSString)
    {
        let 颜文字数组:NSMutableArray = [要复制的颜文字]
        if (!要复制的颜文字名称.isEqual(to: "")) {
            颜文字数组.add(要复制的颜文字名称)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "复制到剪贴板通知"), object: 颜文字数组, userInfo: nil)
    }
}
