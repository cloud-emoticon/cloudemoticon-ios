//
//  Language.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/9/2.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class Language: NSObject {
    
    let 系统支持的语言:NSArray = NSLocale.preferredLanguages()
    var 当前设置的语言:NSString = ""
    var 翻译缓存:NSMutableDictionary = NSMutableDictionary.dictionary()
   
//    override init()
//    {
//        super.init()
//    }
    
    func 当前系统语言() -> NSString
    {
        let languages:NSArray = NSLocale.preferredLanguages()
        return languages.objectAtIndex(0) as NSString
    }
    
    func 系统支持的所有语言() -> NSString
    {
        let 系统支持的语言t:NSArray = NSLocale.preferredLanguages()
        return 系统支持的语言t.componentsJoinedByString(", ")
    }
    
    func 载入语言(要载入的语言:NSString)
    {
        var 当前语言存在:Bool = false
        for 当前语言对象 in 系统支持的语言 {
            let 当前语言:NSString = 当前语言对象 as NSString
            if (当前语言.isEqualToString(要载入的语言)) {
                当前语言存在 = true
                break
            }
        }
        var 载入语言 = 要载入的语言
        if (当前语言存在) {
            for i in 0...2 {
                let 文件管理:NSFileManager = NSFileManager.defaultManager()
                let 文件名:NSString = NSString(format: "language-%@",载入语言)
                let 文件路径:NSString? = NSBundle.mainBundle().pathForResource(文件名, ofType: "plist")
                if (文件路径 != nil) {
                    翻译缓存 = NSMutableDictionary(contentsOfFile: 文件路径!)
                    当前设置的语言 = 载入语言
                    println("[语言管理器]语言读取成功")
                    break
                } else {
                    if (i == 0) {
                        println("[语言管理器错误]当前语言的文件不存在，尝试 en ...")
                        载入语言 = "en"
                    } else if (i == 1) {
                        println("[语言管理器错误]当前语言的文件不存在，尝试 zh-Hans ...")
                        载入语言 = "zh-Hans"
                    } else if (i == 2) {
                        println("[语言管理器错误]当前语言的文件不存在！")
                    }
                }
            }
            
        } else {
            println("[语言管理器错误]当前语言不受系统支持")
        }
    }
    
    func uage(要翻译的文字:NSString) -> NSString
    {
        let 可翻译的文字:NSArray = 翻译缓存.allKeys as NSArray
        var 可翻译:Bool = false
        for 当前可翻译文字对象 in 可翻译的文字 {
            let 当前可翻译文字:NSString = 当前可翻译文字对象 as NSString
            if (当前可翻译文字.isEqualToString(要翻译的文字)) {
                可翻译 = true
                break
            }
        }
        if (可翻译) {
            return 翻译缓存.objectForKey(要翻译的文字) as NSString
        } else {
            println("无法翻译这个条目：\(要翻译的文字)")
        }
        return ""
    }
}
