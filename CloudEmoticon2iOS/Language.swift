//
//  Language.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/9/2.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class Language: NSObject {
    
    let 系统支持的语言:NSArray = Locale.preferredLanguages as NSArray
    var 当前设置的语言:NSString = ""
    var 翻译缓存:NSMutableDictionary = NSMutableDictionary()
   
    func 当前系统语言() -> NSString
    {
        let languages:NSArray = Locale.preferredLanguages as NSArray
        return languages.object(at: 0) as! NSString
    }
    
    func 系统支持的所有语言() -> NSString
    {
        let 系统支持的语言t:NSArray = Locale.preferredLanguages as NSArray
        return 系统支持的语言t.componentsJoined(by: ", ") as NSString
    }
    
    func 载入语言(_ 要载入的语言:NSString)
    {
        var 当前语言存在:Bool = false
        for 当前语言对象 in 系统支持的语言 {
            let 当前语言:NSString = 当前语言对象 as! NSString
            if (当前语言.isEqual(to: 要载入的语言 as String)) {
                当前语言存在 = true
                break
            }
        }
        var 载入语言 = 要载入的语言
        if (当前语言存在) {
            for i in 0...2 {
                let 文件管理:Foundation.FileManager = Foundation.FileManager.default
                let 文件名:NSString = NSString(format: "language-%@",载入语言)
                let 文件路径:NSString? = Bundle.main.path(forResource: 文件名 as String, ofType: "plist") as NSString?
                if (文件路径 != nil) {
                    翻译缓存 = NSMutableDictionary(contentsOfFile: 文件路径! as String)!
                    当前设置的语言 = 载入语言
                    NSLog("[Language]语言读取成功")
                    break
                } else {
                    if (i == 0) {
                        NSLog("[Language]当前语言的文件不存在，尝试 en ...")
                        载入语言 = "en"
                    } else if (i == 1) {
                        NSLog("[Language]当前语言的文件不存在，尝试 zh-Hans ...")
                        载入语言 = "zh-Hans"
                    } else if (i == 2) {
                        NSLog("[Language]当前语言的文件不存在！")
                    }
                }
            }
            
        } else {
            NSLog("[Language]当前语言不受系统支持")
        }
    }
    
    func uage(_ 要翻译的文字:NSString) -> String
    {
        let 可翻译的文字:NSArray = 翻译缓存.allKeys as NSArray
        var 可翻译:Bool = false
        for 当前可翻译文字对象 in 可翻译的文字 {
            let 当前可翻译文字:NSString = 当前可翻译文字对象 as! NSString
            if (当前可翻译文字.isEqual(to: 要翻译的文字 as String)) {
                可翻译 = true
                break
            }
        }
        var 翻译后的文字:String = 要翻译的文字 as String
        if (可翻译) {
            let 翻译后的字符串:NSString = 翻译缓存.object(forKey: 要翻译的文字) as! NSString
            翻译后的文字 = 翻译后的字符串 as String
        } else {
            NSLog("[Language]无法翻译这个条目：“\(要翻译的文字)”")
        }
        return 翻译后的文字
    }
}
