//
//  INIReader.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/5/30.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class INIReader: NSObject {
    
    var INI文件内容字典:NSMutableDictionary?
    var INI文件内容字符串:String?
   
    func 载入INI文件(INI文件路径:String) -> Int {
        let 文件管理器:NSFileManager = NSFileManager.defaultManager()
        if (文件管理器.fileExistsAtPath(INI文件路径)) {
            let INI文件内容:String? = String(contentsOfFile: INI文件路径, encoding: NSUTF8StringEncoding, error: nil)
            if (INI文件内容 == nil || INI文件内容! == "") {
                NSLog("[INIReader]密码或编码不正确")
                return 2
            } else {
                let INI字典:NSMutableDictionary? = 解析INI文件(INI文件内容!)
                if (INI字典 != nil) {
                    if (检查数据条目(INI字典!)) {
                        INI文件内容字典 = INI字典
                        INI文件内容字符串 = INI文件内容
                        return 0
                    } else {
                        return 4
                    }
                } else {
                    NSLog("[INIReader]解析皮肤配置文件失败")
                    return 3
                }
            }
        } else {
            NSLog("[INIReader]找不到配置文件")
            return 1
        }
    }
    
    func 快速查询头信息(INI文件路径:String) -> NSMutableDictionary { //不进行任何有效性检查
        let 文件管理器:NSFileManager = NSFileManager.defaultManager()
        let INI文件内容:String = String(contentsOfFile: INI文件路径, encoding: NSUTF8StringEncoding, error: nil)!
        let INI字典:NSMutableDictionary = 解析INI文件(INI文件内容)!
        var 头信息字典:NSMutableDictionary = NSMutableDictionary()
        头信息字典.setObject(INI字典.objectForKey("theme_author")!, forKey: "theme_author")
        头信息字典.setObject(INI字典.objectForKey("theme_name")!, forKey: "theme_name")
        头信息字典.setObject(INI字典.objectForKey("theme_picture")!, forKey: "theme_picture")
        return 头信息字典
    }
    
    func INI文件存入内存() {
        全局_皮肤设置 = NSDictionary(dictionary: INI文件内容字典!)
    }
    
    func INI文件存入AppGroup() {
        let 组数据读写:AppGroupIO = AppGroupIO()
        var 数据数组:NSArray? = 组数据读写.读取设置UD模式()
        if (数据数组 != nil) {
            let 全部收藏数组:NSArray = 数据数组!.objectAtIndex(0) as! NSArray
            let 全部自定数组:NSArray = 数据数组!.objectAtIndex(1) as! NSArray
            let 全部历史数组:NSArray = 数据数组!.objectAtIndex(2) as! NSArray
            let 全部皮肤数组:NSArray = [INI文件内容字典!]
            let 要保存的数据:NSArray = [全部收藏数组,全部自定数组,全部历史数组,全部皮肤数组]
            组数据读写.写入设置UD模式(要保存的数据)
        } else {
            NSLog("[INIReader]AppGroup没有数据：\(数据数组)。")
        }
    }
    
    func 解析INI文件(INI文件内容:String) -> NSMutableDictionary? {
        let INI文件内容已转换换行符 = INI文件内容.stringByReplacingOccurrencesOfString("\r\n", withString: "\n", options: NSStringCompareOptions.allZeros, range: nil)
        let 行数组:NSArray = INI文件内容已转换换行符.componentsSeparatedByString("\n")
        var INI字典:NSMutableDictionary = NSMutableDictionary()
        for (var i = 0; i < 行数组.count; i++) {
            let 当前行:NSString = 行数组.objectAtIndex(i) as! NSString
            if (当前行 == "") {
                continue
            }
            //NSLog("[INIReader]解析当前行=%@",当前行)
            let 当前行前置字符:String = 当前行.substringToIndex(1)
            let 当前行前置双字符:String = 当前行.substringToIndex(2)
            if (当前行前置字符 != "[" && 当前行前置双字符 != "//") {
                let 当前行数据条目:NSArray = 当前行.componentsSeparatedByString("=")
                if (当前行数据条目.count == 2) {
                    let 键:String = 当前行数据条目.objectAtIndex(0) as! String
                    let 值:String = 当前行数据条目.objectAtIndex(1) as! String
                    INI字典.setObject(值, forKey: 键)
                } else {
                    NSLog("[INIReader]解析出现错误，行格式不匹配。%@",当前行)
                    return nil
                }
            }
        }
        if (INI字典.count > 0) {
            return INI字典
        }
        return nil
    }
    
    func 检查数据条目(INI字典:NSMutableDictionary) -> Bool {
        let 键模板文件路径:String = NSBundle.mainBundle().pathForResource("themekeys", ofType: "txt")!
        let 模板文件内容:String = String(contentsOfFile: 键模板文件路径, encoding: NSUTF8StringEncoding, error: nil)!
        let 模板行数组:NSArray = 模板文件内容.componentsSeparatedByString("\n")
        let INI字典键:NSArray = INI字典.allKeys
        for 当前模板键对象 in 模板行数组 {
            let 当前模板键:String = 当前模板键对象 as! String
            var 有相同值:Bool = false
            for 当前INI键对象 in INI字典键 {
                let 当前INI键:String = 当前INI键对象 as! String
                if (当前模板键 == 当前INI键) {
                    有相同值 = true
                }
            }
            if (有相同值 == false) {
                NSLog("[INIReader]找不到条目%@",当前模板键)
                return false
            }
        }
        return true
    }
}
