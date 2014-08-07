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
        
        
    }
    
    func scoder(dataStr:NSString) -> Coder
    {
        var isOK:Int = 2
        let xmlv1Keys:NSArray = ["<emoji>","<infoos>","<category name=","<entry>","<string>"]
        let jsonv1Keys:NSArray = ["information","categories","entries","emoticon"]
        
        NSLog("%@使用XML校验数据格式...",className)
        for nowkeyobj in xmlv1Keys
        {
            var nowkey:NSString = nowkeyobj as NSString
            var dl:Int = dataStr.rangeOfString(nowkey).location
            if (dl == 0)
            {
                isOK--
            }
        }
        
        return Coder.ERROR
    }
}