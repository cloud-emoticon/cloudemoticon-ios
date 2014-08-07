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
            var y_name:NSString = ""
            var y_info:NSMutableString = ""
            
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
            println(category) //输出字典数组，每个字典里的关键字 "_name":NSString，entry:NSArray
        }
        
    }
    
}
