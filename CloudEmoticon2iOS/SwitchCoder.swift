//
//  SwitchCoder.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/7.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class SwitchCoder: NSObject {
    let className:NSString = "[源数据解析器]"
    
    enum Coder {
        case ERROR
        case XMLv1
        case JSONv1
    }
    
    func startScoder(data:NSData)
    {
        NSLog("%@将数据转换为文本...",className)
        var cmode:Coder = scoder(NSString(data: data, encoding: NSUTF8StringEncoding))
        switch (cmode) {
        case Coder.XMLv1:
            var reader:XMLReader = XMLReader()
            reader.data2xml(data)
            break;
        case Coder.JSONv1:
            var reader:JSONReader = JSONReader()
            reader.data2json(data)
            break;
        default:
            var altarr:NSArray = ["源解析失败","因为源可能有问题或不兼容，无法使用这个源。","中止"]
            NSNotificationCenter.defaultCenter().postNotificationName("alertview", object: altarr)
            break;
        }
    }
    
    func scoder(dataStr:NSString) -> Coder
    {
        var isOK:Int = 2
        let xmlv1Keys:NSArray = ["<emoji>","<infoos>","<category name=","<entry>","<string>"]
        let jsonv1Keys:NSArray = ["information","categories","entries","emoticon"]
        var tmode:Coder = Coder.ERROR
        var tmpIsOK:Bool = true
        NSLog("%@使用XML校验数据格式...",className)
        for nowkeyobj in xmlv1Keys
        {
            var nowkey:NSString = nowkeyobj as NSString
            var dl:Int = dataStr.rangeOfString(nowkey).location
            if (dl == Int.max)
            {
                NSLog("%@使用XML校验数据格式失败。",className)
                tmpIsOK = false
                isOK--
                break
            }
        }
        if (tmpIsOK) {
            tmode = Coder.XMLv1
            NSLog("%@使用XML校验数据格式成功。",className)
        }
        tmpIsOK = true
        NSLog("%@使用JSON校验数据格式...",className)
        for nowkeyobj in jsonv1Keys
        {
            var nowkey:NSString = nowkeyobj as NSString
            var dl:Int = dataStr.rangeOfString(nowkey).location
            if (dl == Int.max)
            {
                NSLog("%@使用JSON校验数据格式失败。",className)
                tmpIsOK = false
                isOK--
                break
            }
        }
        if (tmpIsOK) {
            tmode = Coder.JSONv1
            NSLog("%@使用JSON校验数据格式成功。",className)
        }
        tmpIsOK = true
        if (isOK == 1)
        {
            NSLog("%@数据验证成功。",className)
        } else {
            tmode = Coder.ERROR
            NSLog("%@数据验证失败。",className)
        }
        return tmode
    }
}