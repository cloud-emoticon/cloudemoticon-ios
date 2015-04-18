//
//  AppGroupIO.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/4/18.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class AppGroupIO: NSObject {
    
    let 程序组名称:String = "group.CloudEmoticon"
    let 程序组设置路径:String = "Library/caches/CE2"
    let 程序组设置名称:String = "s"
    
    func 组数据URL() -> NSURL {
        var 组数据URL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(程序组名称)!
        组数据URL = 组数据URL.URLByAppendingPathComponent(程序组设置路径)
        return 组数据URL
    }
    
    func 组数据设置存储() -> NSUserDefaults? {
        let 设置存储:NSUserDefaults? = NSUserDefaults(suiteName: 程序组名称)
        return 设置存储
    }
    
    func 数据有效性校验(数据值:NSString?) -> Bool {
        if(数据值 == nil || 数据值 == "" || 数据值 == "[[],[],[]]") {
            return false
        }
        return true
    }
    
    func 读取数据URL模式() -> NSArray? {
        var 数据值:NSString? = NSString(contentsOfURL: 组数据URL(), encoding: NSUTF8StringEncoding, error: nil)
        if(数据有效性校验(数据值)) {
            let 数据数组:NSArray = ArrayString().json2array(数据值!)
            NSLog("Group-URL读取操作")
            return 数据数组
        }
        return nil
    }
    
    func 写入数据URL模式(数据数组:NSArray) {
        let 数据值:NSString = ArrayString().array2json(数据数组)
        数据值.writeToURL(组数据URL(), atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        NSLog("Group-URL写入操作")
    }
    
    func 读取数据UD模式() -> NSArray? {
        let 设置存储:NSUserDefaults? = 组数据设置存储()
        if (设置存储 != nil) {
            var 数据值:NSString? = 设置存储?.stringForKey(程序组设置名称)
            if(数据有效性校验(数据值)) {
                let 数据数组:NSArray = ArrayString().json2array(数据值!)
                NSLog("Group-UD读取操作")
                return 数据数组
            }
        } else {
            NSLog("UD初始化失败")
        }
        return nil
    }
    
    func 写入数据UD模式(数据数组:NSArray) {
        let 设置存储:NSUserDefaults? = 组数据设置存储()
        if (设置存储 != nil) {
            let 数据值:NSString = ArrayString().array2json(数据数组)
            设置存储?.setObject(数据值, forKey: 程序组设置名称)
            NSLog("Group-UD写入操作")
        } else {
            NSLog("UD初始化失败")
        }
    }
    
    func 新建数据() -> NSArray {
        let 新建数据模型:NSArray = [NSArray(),NSArray(),NSArray()]
        return 新建数据模型
    }
    
}
