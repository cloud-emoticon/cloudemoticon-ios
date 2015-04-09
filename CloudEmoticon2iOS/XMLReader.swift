//
//  XMLReader.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/7.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class XMLReader: NSObject {
    enum saveMode:Int
    {
        case NETWORK = 0
        case HISTORY
        case FAVORITE
        case CUSTOM
    }
    func 数据转换为XML(data:NSData, URL识别数组:NSArray) {
        var XML解析类库:XMLDictionaryParser = XMLDictionaryParser()
        var root:AnyObject? = XML解析类库.dictionaryWithData(data)
        if (root == nil) {
            var 提示框内容数组:NSArray = [lang.uage("源解析失败"),lang.uage("源可能有问题"),lang.uage("中止")]
            NSNotificationCenter.defaultCenter().postNotificationName("alertview", object: 提示框内容数组)
        } else {
            let 文件数据结构版本:NSString = "iOSv2" //ok
            var 颜文字库名:NSString = "" //ok
            var 颜文字库介绍:NSMutableString = "" //ok
            var 颜文字存储数组:NSMutableArray = NSMutableArray() //ok
            
            var 根字典:NSDictionary = XML解析类库.dictionaryWithData(data)
            //println(rootDic) //[__name, infoos, category]
            //var name:NSString = rootDic.objectForKey("__name") as NSString
            var infoos:AnyObject = 根字典.objectForKey("infoos")!
            if infoos is NSDictionary {
                var 子字典:NSDictionary = infoos as! NSDictionary
                var 标头信息:NSArray = 子字典.objectForKey("info") as! NSArray
                for 标头对象 in 标头信息
                {
                    if (颜文字库名.isEqualToString("")) {
                        颜文字库名 = 标头对象 as! NSString
                    } else {
                        颜文字库介绍.insertString(标头对象 as! String, atIndex: 颜文字库介绍.length)
                    }
                }
            } else if infoos is NSString {
                var infoos2:NSString = infoos as! NSString
                颜文字库名 = infoos2
            }
            var category:NSArray = 根字典.objectForKey("category") as! NSArray
//            println(category) //输出字典数组，每个字典里的关键字 "_name":NSString，entry:NSArray
            for groupData in category
            {
                var groupDic:NSDictionary = groupData as! NSDictionary
                var g_groupname:NSString = groupDic.objectForKey("_name") as! NSString
//                y_emoarr.addObject(g_groupname)
                var y_emoobj:NSMutableArray = NSMutableArray()
                y_emoobj.addObject(g_groupname)
                var entry:NSArray = groupDic.objectForKey("entry") as! NSArray
                for nowEmoobj in entry
                {
                    var nowEmoobjDic:NSDictionary = nowEmoobj as! NSDictionary
                    var g_emoobj:NSMutableArray = NSMutableArray()
                    var e_emo:NSString = nowEmoobjDic.objectForKey("string") as! NSString
                    g_emoobj.addObject(e_emo)
                    if (nowEmoobjDic.allKeys.count == 2) {
                        var e_name:NSString = nowEmoobjDic.objectForKey("note") as! NSString
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
