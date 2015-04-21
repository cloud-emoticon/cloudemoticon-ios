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
    let 程序组对象名称:String = "o"
    let 空白设置模型:String = "[[],[],[]]"
    
    func 新建设置() -> NSArray {
        let 新建设置模型:NSArray = [NSArray(),NSArray(),NSArray()]
        return 新建设置模型
    }
    
    func 组设置URL() -> NSURL {
        var 组设置URL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(程序组名称)!
        组设置URL = 组设置URL.URLByAppendingPathComponent(程序组设置路径)
        return 组设置URL
    }
    
    func 组设置存储() -> NSUserDefaults? {
        let 设置存储:NSUserDefaults? = NSUserDefaults(suiteName: 程序组名称)
        return 设置存储
    }
    
    func 设置有效性校验(设置值:NSString?) -> Bool {
        if(设置值 == nil || 设置值!.isEqualToString("") || 设置值!.isEqualToString(空白设置模型)) {
            return false
        }
        return true
    }
    
    func 读取设置URL模式() -> NSArray? {
        var 设置值:NSString? = NSString(contentsOfURL: 组设置URL(), encoding: NSUTF8StringEncoding, error: nil)
        if(设置有效性校验(设置值)) {
            let 设置数组:NSArray = ArrayString().JSON字符串转数组(设置值!)
            NSLog("Group-URL读取操作")
            return 设置数组
        }
        return nil
    }
    
    func 写入设置URL模式(设置数组:NSArray) {
        let 设置值:NSString = ArrayString().数组转JSON字符串(设置数组)
        设置值.writeToURL(组设置URL(), atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        NSLog("Group-URL写入操作")
    }
    
    func 检查设置URL模式() -> Bool {
        var 设置值:NSString? = NSString(contentsOfURL: 组设置URL(), encoding: NSUTF8StringEncoding, error: nil)
        if(设置有效性校验(设置值)) {
            return true
        }
        return false
    }
    
    func 清除设置URL模式() {
        let 设置值:NSString = NSString()
        设置值.writeToURL(组设置URL(), atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        NSLog("Group-URL清除操作")
    }
    
    func 读取设置UD模式() -> NSArray? {
        let 设置存储:NSUserDefaults? = 组设置存储()
        if (设置存储 != nil) {
            var 设置值:NSString? = 设置存储?.stringForKey(程序组设置名称)
            if(设置有效性校验(设置值)) {
                let 设置数组:NSArray = ArrayString().JSON字符串转数组(设置值!)
                NSLog("Group-UD读取操作")
                return 设置数组
            }
        } else {
            NSLog("Group-UD读取UD初始化失败")
        }
        return nil
    }
    
    func 写入设置UD模式(设置数组:NSArray) {
        let 设置存储:NSUserDefaults? = 组设置存储()
        if (设置存储 != nil) {
            let 设置值:NSString = ArrayString().数组转JSON字符串(设置数组)
            设置存储?.setObject(设置值, forKey: 程序组设置名称)
            NSLog("Group-UD写入操作")
            设置存储?.synchronize()
        } else {
            NSLog("Group-UD写入UD初始化失败")
        }
    }
    
    func 检查设置UD模式() -> Bool {
        let 设置存储:NSUserDefaults? = 组设置存储()
        if (设置存储 != nil) {
            var 设置值:NSString? = 设置存储?.stringForKey(程序组设置名称)
            if(设置有效性校验(设置值)) {
                return true
            }
        }
        return false
    }
    
    func 清除设置和对象UD模式() {
        let 设置存储:NSUserDefaults? = 组设置存储()
        if (设置存储 != nil) {
            let 应用ID:String? = NSBundle.mainBundle().bundleIdentifier
            if (应用ID != nil) {
                设置存储?.removePersistentDomainForName(应用ID! as String)
            }
            let 设置字典:NSDictionary = 设置存储?.dictionaryRepresentation() as NSDictionary!
            let 设置字典设置项:NSArray = 设置字典.allKeys as NSArray
            for 当前设置项 in 设置字典设置项 {
                let 当前设置项字符串:String = 当前设置项 as! String
                设置存储?.removeObjectForKey(当前设置项字符串)
            }
            NSLog("Group-UD清除操作")
            设置存储?.synchronize()
        } else {
            NSLog("Group-UD清除UD初始化失败")
        }
    }
    
    func 读取对象UD模式() -> NSArray? {
        let 设置存储:NSUserDefaults? = 组设置存储()
        if (设置存储 != nil) {
            let 对象:AnyObject? = 设置存储?.objectForKey(程序组对象名称)
            if (对象 != nil && 对象 is NSArray) {
                let 对象数组:NSArray = 对象 as! NSArray
                NSLog("Group-UD对象数组读取操作")
                return 对象数组
            }
        } else {
            NSLog("Group-UD对象数组读取UD初始化失败")
        }
        return nil
    }
    
    func 写入对象UD模式(对象数组:NSArray) {
        let 设置存储:NSUserDefaults? = 组设置存储()
        if (设置存储 != nil) {
            设置存储?.setObject(对象数组, forKey: 程序组对象名称)
            NSLog("Group-UD对象数组写入操作")
            设置存储?.synchronize()
        } else {
            NSLog("Group-UD对象数组写入UD初始化失败")
        }
    }
    
    func 检查对象UD模式() -> Bool {
        let 设置存储:NSUserDefaults? = 组设置存储()
        if (设置存储 != nil) {
            let 对象:AnyObject? = 设置存储?.objectForKey(程序组对象名称)
            if (对象 != nil && 对象 is NSArray) {
                return true
            }
        }
        return false
    }
    
    func 从pliat创建设置数组(文件名称:NSString) -> NSArray? {
        let 文档文件夹数组:NSArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let 文档文件夹路径:NSString = 文档文件夹数组[0] as! NSString
        let 设置列表文件路径:String = "\(文档文件夹路径)/\(文件名称)"
        let 文件管理器:NSFileManager = NSFileManager.defaultManager()
        if (文件管理器.isExecutableFileAtPath(设置列表文件路径)) {
            let 初始设置数组:NSArray? = NSArray(contentsOfFile: 设置列表文件路径 as String)
            if (初始设置数组 != nil) {
                return 初始设置数组!
            } else {
                NSLog("plist读取失败。")
            }
        } else {
            NSLog("找不到plist文件。")
        }
        return nil
    }
}
