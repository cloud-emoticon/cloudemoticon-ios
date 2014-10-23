//
//  SwitchCoder.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/7.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class SwitchCoder: NSObject {
    let 类名称:NSString = "[源数据解析器]"
//    var nowURLstr:NSString = ""
    
    enum Coder {
        case ERROR
        case XMLv1
        case JSONv1
    }
    
    func 选择解析器(源数据:NSData, URL识别数组:NSArray)
    {
        NSLog("%@将数据转换为文本...",类名称)
        
        var 当前数据格式:Coder = scoder(NSString(data: 源数据, encoding: NSUTF8StringEncoding)!)
        switch (当前数据格式) {
        case Coder.XMLv1:
            var XML解析器:XMLReader = XMLReader()
            XML解析器.数据转换为XML(源数据, URL识别数组: URL识别数组)
            break
        case Coder.JSONv1:
            var JSON解析器:JSONReader = JSONReader()
            JSON解析器.数据转换为JSON(源数据, URL识别数组: URL识别数组)
            break
        default:
            var altarr:NSArray = [lang.uage("源解析失败"),lang.uage("源可能有问题"),lang.uage("中止")]
            NSNotificationCenter.defaultCenter().postNotificationName("alertview", object: altarr)
            break
        }
    }
    
    func scoder(dataStr:NSString) -> Coder
    {
        var isOK:Int = 2
        let xmlv1Keys:NSArray = ["<emoji>","<infoos>","<category name=","<entry>","<string>"]
        let jsonv1Keys:NSArray = ["information","categories","entries","emoticon"]
        var tmode:Coder = Coder.ERROR
        var tmpIsOK:Bool = true
        NSLog("%@使用XML校验数据格式...",类名称)
        for nowkeyobj in xmlv1Keys
        {
            var nowkey:NSString = nowkeyobj as NSString
            var dl:Int = dataStr.rangeOfString(nowkey).location
            if (dl == Int.max)
            {
                NSLog("%@使用XML校验数据格式失败。",类名称)
                tmpIsOK = false
                isOK--
                break
            }
        }
        if (tmpIsOK) {
            tmode = Coder.XMLv1
            NSLog("%@使用XML校验数据格式成功。",类名称)
        }
        tmpIsOK = true
        NSLog("%@使用JSON校验数据格式...",类名称)
        for nowkeyobj in jsonv1Keys
        {
            var nowkey:NSString = nowkeyobj as NSString
            var dl:Int = dataStr.rangeOfString(nowkey).location
            if (dl == Int.max)
            {
                NSLog("%@使用JSON校验数据格式失败。",类名称)
                tmpIsOK = false
                isOK--
                break
            }
        }
        if (tmpIsOK) {
            tmode = Coder.JSONv1
            NSLog("%@使用JSON校验数据格式成功。",类名称)
        }
        tmpIsOK = true
        if (isOK == 1)
        {
            NSLog("%@数据验证成功。",类名称)
            
        } else {
            tmode = Coder.ERROR
            NSLog("%@数据验证失败。",类名称)
        }
        return tmode
    }
}