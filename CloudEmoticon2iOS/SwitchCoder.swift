//
//  SwitchCoder.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/7.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class SwitchCoder: NSObject {
    
    enum Coder {
        case ERROR
        case JSON
        case XML
    }
    
    func scoder(data:NSData) -> Coder
    {
        var str:NSString
        str = NSString(data: data, encoding: NSUTF8StringEncoding)
        println(str)
        return Coder.ERROR
    }
}