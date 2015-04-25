//
//  YashiAppGroupIO.swift
//  雅诗独立类库：AppGroup共享设置读写工具 v2.0 Swift中文版 (Xcode6.3) | beta
//
//  封装AppGroup的读写方法，支持对AppGroup的增删改查，URL和NSUserDefaults两种调用方式，JsonString和对象两种存储方式。
//
//  Created by 神楽坂雅詩 on 15/4/18.
//  Copyright (c) 2015 KagurazakaYashi/TerenceChen . All rights reserved.
//
//  依赖：Json2Array/Array2Json
//  输入：每个方法均可作为输入点
//  输出：每个方法均可作为输出点
//

import UIKit

class AppGroupIO: NSObject {

    let 程序组名称:String = "group.CloudEmoticon" //AppGroup的名称
    let 程序组设置路径:String = "Library/caches/CE2" //URL方式读写路径
    let 程序组设置名称:String = "s" //字符串类型值存储Key
    let 程序组对象名称:String = "o" //对象类型值存储Key
    let 空白设置模型:String = "[[],[],[],[]]" //用于校验的空白Json模型
    
    //新的数据模型生成方法（根据需要修改）
    func 新建设置() -> NSArray {
        let 新建设置模型:NSArray = [NSArray(),NSArray(),NSArray(),NSArray()]
        return 新建设置模型
    }
    
    //获取此程序保存设置用的URL地址
    func 组设置URL() -> NSURL {
        var 组设置URL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(程序组名称)!
        组设置URL = 组设置URL.URLByAppendingPathComponent(程序组设置路径)
        return 组设置URL
    }
    
    //获取此程序保存设置用的NSUserDefaults
    func 组设置存储() -> NSUserDefaults? {
        let 设置存储:NSUserDefaults? = NSUserDefaults(suiteName: 程序组名称)
        return 设置存储
    }
    
    //检查是否保存过设置（输入可能为空的设置字符串检查有效性）
    func 设置有效性校验(设置值:NSString?) -> Bool {
        if(设置值 == nil || 设置值!.isEqualToString("") || 设置值!.isEqualToString(空白设置模型)) {
            return false
        }
        return true
    }
    
    //使用URL调用方式提取保存的字符串数组
    func 读取设置URL模式() -> NSArray? {
        var 设置值:NSString? = NSString(contentsOfURL: 组设置URL(), encoding: NSUTF8StringEncoding, error: nil)
        if(设置有效性校验(设置值)) {
            let 设置数组:NSArray = ArrayString().JSON字符串转数组(设置值!)
            NSLog("Group-URL读取操作")
            return 设置数组
        }
        return nil
    }
    
    //使用URL调用方式写入字符串数组
    func 写入设置URL模式(设置数组:NSArray) {
        let 设置值:NSString = ArrayString().数组转JSON字符串(设置数组)
        设置值.writeToURL(组设置URL(), atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        NSLog("Group-URL写入操作")
    }
    
    //检查URL调用方式得到的内容是否有效
    func 检查设置URL模式() -> Bool {
        var 设置值:NSString? = NSString(contentsOfURL: 组设置URL(), encoding: NSUTF8StringEncoding, error: nil)
        if(设置有效性校验(设置值)) {
            return true
        }
        return false
    }
    
    //清除URL调用方式保存的全部内容
    func 清除设置URL模式() {
        let 设置值:NSString = NSString()
        设置值.writeToURL(组设置URL(), atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        NSLog("Group-URL清除操作")
    }
    
    //使用NSUserDefaults提取保存的字符串数组
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
    
    //使用NSUserDefaults写入字符串数组
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
    
    //检查NSUserDefaults调用方式得到的字符串是否有效
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
    
    //清除NSUserDefaults的全部内容（设置和对象都有效）
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
    
    //使用NSUserDefaults提取保存的对象
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
    
    //使用NSUserDefaults写入对象
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
    
    //检查NSUserDefaults调用方式得到的对象是否有效
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
    
    //可以在程序中内置一个plist文件，在第一次运行时用这个文件创建数据模型
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
    
    //清除标准程序设置
    func 清除标准程序设置() {
        let 设置存储:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let 应用ID:String? = NSBundle.mainBundle().bundleIdentifier
        if (应用ID != nil) {
            设置存储.removePersistentDomainForName(应用ID! as String)
        }
        let 设置字典:NSDictionary = 设置存储.dictionaryRepresentation() as NSDictionary!
        let 设置字典设置项:NSArray = 设置字典.allKeys as NSArray
        for 当前设置项 in 设置字典设置项 {
            let 当前设置项字符串:String = 当前设置项 as! String
            设置存储.removeObjectForKey(当前设置项字符串)
        }
        NSLog("Group-UD清除操作")
        设置存储.synchronize()
    }
}
