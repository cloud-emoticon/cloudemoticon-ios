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
        case network = 0
        case history
        case favorite
        case custom
    }
    func 数据转换为XML(_ data:Data, URL识别数组:NSArray) {
        let XML解析类库:XMLDictionaryParser = XMLDictionaryParser()
        let root:Any? = XML解析类库.dictionary(with: data)
        if (root == nil) {
            let 提示框内容数组:NSArray = [lang.uage("源解析失败"),lang.uage("源可能有问题"),lang.uage("中止")]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "alertview"), object: 提示框内容数组)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "显示等待提示框通知"), object: NSNumber(value: false as Bool))
        } else {
            let 文件数据结构版本:NSString = "iOSv2" //ok
            var 颜文字库名:NSString = "" //ok
            let 颜文字库介绍:NSMutableString = "" //ok
            let 颜文字存储数组:NSMutableArray = NSMutableArray() //ok
            
            let 根字典:NSDictionary = XML解析类库.dictionary(with: data) as NSDictionary
            //println(rootDic) //[__name, infoos, category]
            //var name:NSString = rootDic.objectForKey("__name") as NSString
            let infoos:AnyObject = 根字典.object(forKey: "infoos")! as AnyObject
            if infoos is NSDictionary {
                let 子字典:NSDictionary = infoos as! NSDictionary
                let 标头信息:NSArray = 子字典.object(forKey: "info") as! NSArray
                for 标头对象 in 标头信息
                {
                    if (颜文字库名.isEqual(to: "")) {
                        颜文字库名 = 标头对象 as! NSString
                    } else {
                        颜文字库介绍.insert(标头对象 as! String, at: 颜文字库介绍.length)
                    }
                }
            } else if infoos is NSString {
                let infoos2:NSString = infoos as! NSString
                颜文字库名 = infoos2
            }
            let category:NSArray = 根字典.object(forKey: "category") as! NSArray
//            println(category) //输出字典数组，每个字典里的关键字 "_name":NSString，entry:NSArray
            for groupData in category
            {
                let groupDic:NSDictionary = groupData as! NSDictionary
                let g_groupname:NSString = groupDic.object(forKey: "_name") as! NSString
//                y_emoarr.addObject(g_groupname)
                let y_emoobj:NSMutableArray = NSMutableArray()
                y_emoobj.add(g_groupname)
                let entry:NSArray = groupDic.object(forKey: "entry") as! NSArray
                for nowEmoobj in entry
                {
                    let nowEmoobjDic:NSDictionary = nowEmoobj as! NSDictionary
                    let g_emoobj:NSMutableArray = NSMutableArray()
                    let e_emo:NSString = nowEmoobjDic.object(forKey: "string") as! NSString
                    g_emoobj.add(e_emo)
                    if (nowEmoobjDic.allKeys.count == 2) {
                        let e_name:NSString = nowEmoobjDic.object(forKey: "note") as! NSString
                        g_emoobj.add(e_name)
                    }
                    y_emoobj.add(g_emoobj)
                }
                颜文字存储数组.add(y_emoobj)
            }
            
            let zfile:NSArray = [文件数据结构版本,颜文字库名,颜文字库介绍,颜文字存储数组]
            let 介绍文字:NSString = NSString(format: "%@\n%@", lang.uage("刷新完成"), 颜文字库介绍)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "显示自动关闭的提示框通知"), object: 介绍文字)
            //解析完成，输出zfile:NSArray
            let filemgr:FileManager = FileManager()
            filemgr.nowURLarr = URL识别数组
            p_tempString = 颜文字库名
            filemgr.SaveArrayToFile(zfile, smode: FileManager.saveMode.network)
        }
    }
    
}
