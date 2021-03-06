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
   
    func 载入INI文件(_ INI文件路径:String) -> Int {
        let 文件管理器:Foundation.FileManager = Foundation.FileManager.default
        if (文件管理器.fileExists(atPath: INI文件路径)) {
            let INI文件内容:String? = try? String(contentsOfFile: INI文件路径, encoding: String.Encoding.utf8)
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
    
    func 快速查询头信息(_ INI文件路径:String) -> NSMutableDictionary { //不进行任何有效性检查
        let 文件管理器:Foundation.FileManager = Foundation.FileManager.default
        let INI文件内容:String = try! String(contentsOfFile: INI文件路径, encoding: String.Encoding.utf8)
        let INI字典:NSMutableDictionary = 解析INI文件(INI文件内容)!
        let 头信息字典:NSMutableDictionary = NSMutableDictionary()
        头信息字典.setObject(INI字典.object(forKey: "theme_author")!, forKey: "theme_author" as NSCopying)
        头信息字典.setObject(INI字典.object(forKey: "theme_name")!, forKey: "theme_name" as NSCopying)
        头信息字典.setObject(INI字典.object(forKey: "theme_picture")!, forKey: "theme_picture" as NSCopying)
        return 头信息字典
    }
    
    func INI文件存入内存() {
        全局_皮肤设置 = NSDictionary(dictionary: INI文件内容字典!)
    }
    
    func INI文件存入AppGroup() {
        let 组数据读写:AppGroupIO = AppGroupIO()
        let 数据数组:NSArray? = 组数据读写.读取设置UD模式()
        if (数据数组 != nil) {
            let 全部收藏数组:NSArray = 数据数组!.object(at: 0) as! NSArray
            let 全部自定数组:NSArray = 数据数组!.object(at: 1) as! NSArray
            let 全部历史数组:NSArray = 数据数组!.object(at: 2) as! NSArray
            let 全部皮肤数组:NSArray = [INI文件内容字典!]
            let 要保存的数据:NSArray = [全部收藏数组,全部自定数组,全部历史数组,全部皮肤数组]
            组数据读写.写入设置UD模式(要保存的数据)
        } else {
            NSLog("[INIReader]AppGroup没有数据：\(数据数组)。")
        }
    }
    
    func 解析INI文件(_ INI文件内容:String) -> NSMutableDictionary? {
        let INI文件内容已转换换行符 = INI文件内容.replacingOccurrences(of: "\r\n", with: "\n", options: NSString.CompareOptions(), range: nil)
        let 行数组:NSArray = INI文件内容已转换换行符.components(separatedBy: "\n") as NSArray
        let INI字典:NSMutableDictionary = NSMutableDictionary()
        for i in 0 ..< 行数组.count {
//        for (var i = 0; i < 行数组.count; i += 1) {
            let 当前行 = 行数组.object(at: i) as! NSString
            if (当前行 == "") {
                continue
            }
            //NSLog("[INIReader]解析当前行=%@",当前行)
            let 当前行前置字符:String = 当前行.substring(to: 1)
            let 当前行前置双字符:String = 当前行.substring(to: 2)
            if (当前行前置字符 != "[" && 当前行前置双字符 != "//") {
                let 当前行数据条目:NSArray = 当前行.components(separatedBy: "=") as NSArray
                if (当前行数据条目.count == 2) {
                    let 键 = 当前行数据条目.object(at: 0) as! String
                    let 值 = 当前行数据条目.object(at: 1) as! String
                    INI字典.setObject(值, forKey: 键 as NSCopying)
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
    
    func 检查数据条目(_ INI字典:NSMutableDictionary) -> Bool {
        return true // MARK: - INI检查器开关，此处不注释则跳过检查器
        let 键模板文件路径:String = Bundle.main.path(forResource: "themekeys", ofType: "txt")!
        let 模板文件内容:String = try! String(contentsOfFile: 键模板文件路径, encoding: String.Encoding.utf8)
        let 模板行数组 = 模板文件内容.components(separatedBy: "\n")
        let INI字典键:NSArray = INI字典.allKeys as NSArray
        for 当前模板键对象 in 模板行数组 {
            let 当前模板键:String = 当前模板键对象 
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
