//
//  XMLReader.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/6.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//


import UIKit

class XMLReader: NSObject { //,NSXMLParserDelegate
    
    func data2json(data:NSData) {
        
        var allstr:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)
        /*
        序列1 ＝＝＝＝＝
        层级1：寻找<emoji>
        序列2 ＝＝＝＝＝
        层级2：--寻找<infoos>
        层级3：----寻找<info>(可能存在)
        序列3 ＝＝＝＝＝
        层级2：--寻找<category>
        层级3：----寻找<entry>
        层级4：------寻找<note>(可能存在)
        层级4：------寻找<string>
        */
        
        //层级1：寻找<emoji>
        var emoji_start:NSRange = allstr.rangeOfString("<emoji>")
        var emoji_end:NSRange = allstr.rangeOfString("</emoji>")
        //startrange = emoji_start.location
        //length = emoji_end.location - emoji_start.location + 1
        var emoji:NSString = allstr.substringWithRange(NSMakeRange(emoji_start.length, (emoji_end.location - emoji_start.length)))
        //层级2：--寻找<infoos>
        var infoos_start:NSRange = emoji.rangeOfString("<infoos>")
        var infoos_end:NSRange = emoji.rangeOfString("</infoos>")
        var infoos:NSString = emoji.substringWithRange(NSMakeRange(infoos_start.length, (infoos_end.location - infoos_start.length)))
        
        //层级2：--寻找<category>
//        var category_i:NSRange = emoji.rangeOfString("<category>")
        var tmpStr:NSMutableString = NSMutableString.stringWithString(emoji)
        var categoryArr:NSMutableArray = NSMutableArray.array()
        do {
            var category_start:NSRange = tmpStr.rangeOfString("<category>")
            var category_end:NSRange = tmpStr.rangeOfString("</category>")
            var category:NSString = tmpStr.substringWithRange(NSMakeRange(category_start.length, (category_end.location - category_start.length)))
            categoryArr.addObject(category)
            println(category_start.location)
            println(category_end.location + category_end.length - category_start.location)
            tmpStr.deleteCharactersInRange(NSMakeRange(category_start.location, category_end.location + category_end.length - category_start.location))
//            var category_start:NSRange = category_i
//            var category_end:NSRange = emoji.rangeOfString("</category>")
//            var category:NSString = emoji.substringWithRange(NSMakeRange(category_i.length ,(category_end.location - category_i.length)))
//            category_i.location = category.length + category_i.length
//            
//            println(category)
//            if (emoji_end.location - category_end.location < 21)
//            {
//                break
//            }
        } while (true)
        
    }
}
