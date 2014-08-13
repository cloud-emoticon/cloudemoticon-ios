//
//  JSONReader.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/6.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class JSONReader: NSObject {
    
    func data2json(data:NSData) {
        var error:NSError?
        var jsondic:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSDictionary
        if (error) {
            var altarr:NSArray = ["JSON源解析失败","因为源可能有问题或不兼容，无法使用这个源。","中止"]
            NSNotificationCenter.defaultCenter().postNotificationName("alertview", object: altarr)
        } else {
            let y_ver:NSString = "iOSv2" //ok
            var y_name:NSString = "" //ok
            var y_info:NSMutableString = "" //ok
            var y_emoarr:NSMutableArray = NSMutableArray.array() //ok
            
            var information:NSArray = jsondic.objectForKey("information") as NSArray
            for informationData in information
            {
                var informationStr:NSString = informationData as NSString
                if (y_name.isEqualToString("")) {
                    y_name = informationStr
                } else {
                    y_info.insertString(informationStr, atIndex: y_info.length)
                }
            }
            var categories:NSArray = jsondic.objectForKey("categories") as NSArray
//            println(categories) //输出字典数组
            for groupDic in categories
            {
//                println(groupDic.allKeys) //[entries, name]
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
                y_emoarr.addObject(y_emoobj)
            }
            var zfile:NSArray = [y_ver,y_name,y_info,y_emoarr]
            //解析完成，输出zfile:NSArray
            let filemgr:FileManager = FileManager()
            filemgr.SaveArrayToFile(zfile, smode: FileManager.saveMode.NETWORK)
        }
    }
}
