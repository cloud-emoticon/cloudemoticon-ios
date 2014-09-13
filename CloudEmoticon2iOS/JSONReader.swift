//
//  JSONReader.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/6.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class JSONReader: NSObject {
    
    func 数据转换为JSON(源数据:NSData, URL识别数组:NSArray) {
        var 错误记录:NSError?
        var JSON解析后字典:NSDictionary = NSJSONSerialization.JSONObjectWithData(源数据, options: NSJSONReadingOptions.AllowFragments, error: &错误记录) as NSDictionary
        if ((错误记录) != nil) {
            var 提示框内容数组:NSArray = [lang.uage("源解析失败"),lang.uage("源可能有问题"),lang.uage("中止")]
            NSNotificationCenter.defaultCenter().postNotificationName("alertview", object: 提示框内容数组)
        } else {
            let 文件数据结构版本:NSString = "iOSv2" //ok
            var 颜文字库名:NSString = "" //ok
            var 颜文字库介绍:NSMutableString = "" //ok
            var 颜文字存储数组:NSMutableArray = NSMutableArray.array() //ok
            
            var 根信息:NSArray = JSON解析后字典.objectForKey("information") as NSArray
            for 根数据 in 根信息
            {
                var 根字符:NSString = 根数据 as NSString
                if (颜文字库名.isEqualToString("")) {
                    颜文字库名 = 根字符
                } else {
                    颜文字库介绍.insertString(根字符, atIndex: 颜文字库介绍.length)
                }
            }
            var categories:NSArray = JSON解析后字典.objectForKey("categories") as NSArray

            for groupDic in categories
            {
                var entries:NSArray = groupDic.objectForKey("entries") as NSArray
                var groupname:NSString = groupDic.objectForKey("name") as NSString
//                var entriesData:NSDictionary = groupDic.objectForKey("entries") as NSDictionary
//                y_emoarr.addObject(groupname)
                var y_emoobj:NSMutableArray = NSMutableArray.array()
                y_emoobj.addObject(groupname)
                for entriesData in entries
                {
                    var entriesDataDic:NSDictionary = entriesData as NSDictionary
                    var entriesDataDicKeys:NSArray = entriesDataDic.allKeys
                    var g_emoobj:NSMutableArray = NSMutableArray.array()
                    var e_emo:NSString = entriesDataDic.objectForKey("emoticon") as NSString
                    g_emoobj.addObject(e_emo)
                    if (entriesDataDicKeys.count == 2) {
                        var e_name:NSString = entriesDataDic.objectForKey("description") as NSString
                        g_emoobj.addObject(e_name)
                    }
                    y_emoobj.addObject(g_emoobj)
                }
                颜文字存储数组.addObject(y_emoobj)
            }
            var zfile:NSArray = [文件数据结构版本,颜文字库名,颜文字库介绍,颜文字存储数组]
            let 介绍文字:NSString = NSString(format: "%@\n%@", lang.uage("刷新完成"), 颜文字库介绍)
            NSNotificationCenter.defaultCenter().postNotificationName("显示自动关闭的提示框通知", object: 介绍文字)
            //解析完成，输出zfile:NSArray
            let filemgr:FileManager = FileManager()
            filemgr.nowURLarr = URL识别数组
            p_tempString = 颜文字库名
            filemgr.SaveArrayToFile(zfile, smode: FileManager.saveMode.NETWORK)
        }
    }
}
