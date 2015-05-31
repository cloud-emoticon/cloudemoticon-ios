//
//  SkinManager.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/5/10.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class SkinManager: NSObject {
    let 文件管理器:NSFileManager = NSFileManager.defaultManager()
    
    func 取skin文件夹路径() -> String { //不存在则创建
        let skin文件夹路径:String = "\(全局_文档文件夹)/skin"
        if (文件管理器.fileExistsAtPath(skin文件夹路径) == false) {
            文件管理器.createDirectoryAtPath(skin文件夹路径, withIntermediateDirectories: false, attributes: nil, error: nil)
        }
        return skin文件夹路径
    }
    
    func 读取皮肤列表() -> NSArray {
        let skin文件夹路径:String = 取skin文件夹路径()
        let 文件管理器:NSFileManager = NSFileManager.defaultManager()
        let skin文件夹列表:NSArray? = 文件管理器.contentsOfDirectoryAtPath(skin文件夹路径, error: nil)
        if (skin文件夹列表 != nil) {
            let INI读取器:INIReader = INIReader()
            let 主题信息列表:NSMutableArray = NSMutableArray()
            for(var i:Int = 0; i < skin文件夹列表!.count; i++) {
                let 当前md5文件夹:NSString = skin文件夹列表?.objectAtIndex(i) as! NSString
                if (当前md5文件夹.length != 32) {
                    continue
                }
                let 当前文件夹路径:String = String(format: "%@/%@", skin文件夹路径, 当前md5文件夹)
                let 当前INI文件:String = String(format: "%@/index.ini", 当前文件夹路径)
                var 头信息字典:NSMutableDictionary = INI读取器.快速查询头信息(当前INI文件)
                //转换图片路径为完整路径
                let 当前预览图名称:String = 头信息字典.objectForKey("theme_picture") as! String
                let 当前预览图路径:String = String(format: "%@/%@", 当前文件夹路径, 当前预览图名称)
                头信息字典.setObject(当前预览图路径, forKey: "theme_picture")
                //添加文件夹完整路径
                头信息字典.setObject(当前文件夹路径, forKey: "dir")
                主题信息列表.addObject(头信息字典)
            }
            return 主题信息列表
        } else {
            NSLog("[SkinManager]列skin文件夹列表失败。")
        }
        return NSArray()
    }
}
