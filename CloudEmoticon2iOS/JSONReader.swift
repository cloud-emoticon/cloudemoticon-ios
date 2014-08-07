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
            let y_ver:NSString = "iOSv2"
            var y_name:NSString = ""
            var y_info:NSMutableString = ""
            var y_emoarr:NSMutableArray = NSMutableArray.array()
            
            var information:NSArray = jsondic.objectForKey("information") as NSArray
            for informationStr in information
            {
                if (y_name.isEqualToString("")) {
                    y_name = informationStr as NSString
                } else {
                    y_info.insertString(informationStr as NSString, atIndex: y_info.length)
                }
            }
            var categories:NSArray = jsondic.objectForKey("categories") as NSArray
//            println(categories) //输出字典数组
            for groupDic in categories
            {
//                println(groupDic.allKeys) //[entries, name]
                var entries:NSArray = groupDic.objectForKey("entries") as NSArray
                var name:NSString = groupDic.objectForKey("Huge") as NSString
                println(entries)
                println(name)
            }
        }
        
    }
    
}
