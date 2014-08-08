//
//  XMLReader.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/7.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class XMLReader: NSObject {
   
    func data2xml(data:NSData) {
        var xmld:XMLDictionaryParser = XMLDictionaryParser()
        var root:AnyObject? = xmld.dictionaryWithData(data)
        if (!root) {
            var altarr:NSArray = ["XML源解析失败","因为源可能有问题或不兼容，无法使用这个源。","中止"]
            NSNotificationCenter.defaultCenter().postNotificationName("alertview", object: altarr)
        } else {
            let y_ver:NSString = "iOSv2" //ok
            var y_name:NSString = "" //ok
            var y_info:NSMutableString = "" //ok
            var y_emoarr:NSMutableArray = NSMutableArray.array() //ok
            
            var rootDic:NSDictionary = xmld.dictionaryWithData(data)
            //println(rootDic) //[__name, infoos, category]
            //var name:NSString = rootDic.objectForKey("__name") as NSString
            var infoos:AnyObject = rootDic.objectForKey("infoos")
            if infoos is NSDictionary {
                var infoos2:NSDictionary = infoos as NSDictionary
                var infoos3:NSArray = infoos2.objectForKey("info") as NSArray
                for nowstr in infoos3
                {
                    if (y_name.isEqualToString("")) {
                        y_name = nowstr as NSString
                    } else {
                        y_info.insertString(nowstr as NSString, atIndex: y_info.length)
                    }
                }
            } else if infoos is NSString {
                //未验证代码
                var infoos2:NSString = infoos as NSString
                y_name = infoos2
            }
            var category:NSArray = rootDic.objectForKey("category") as NSArray
//            println(category) //输出字典数组，每个字典里的关键字 "_name":NSString，entry:NSArray
            for groupData in category
            {
                var groupDic:NSDictionary = groupData as NSDictionary
                var g_groupname:NSString = groupDic.objectForKey("_name") as NSString
                y_emoarr.addObject(g_groupname)
                var entry:NSArray = groupDic.objectForKey("entry") as NSArray
                for nowEmoobj in entry
                {
                    var nowEmoobjDic:NSDictionary = nowEmoobj as NSDictionary
                    var g_emoobj:NSMutableArray = NSMutableArray.array()
                    var e_emo:NSString = nowEmoobjDic.objectForKey("string") as NSString
                    g_emoobj.addObject(e_emo)
                    if (nowEmoobjDic.allKeys.count == 2) {
                        var e_name:NSString = nowEmoobjDic.objectForKey("note") as NSString
                        g_emoobj.addObject(e_name)
                    }
                    y_emoarr.addObject(g_emoobj)
                }
            }
            
            var zfile:NSArray = [y_ver,y_name,y_info,y_emoarr]
            //解析完成，输出zfile:NSArray
            let filemgr:FileManager = FileManager()
            filemgr.SaveArrayToFile(zfile, smode: FileManager.saveMode.NETWORK)
        }
        
    }
    
}
