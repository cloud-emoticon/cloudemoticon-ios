//
//  Md5Coder.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/8.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit
import Darwin

class Md5Coder: NSObject {
    
    func md5(str:NSString) -> NSString
    {
        var md5o:MD5 = MD5()
        var rstr:NSString = md5o.md5(str as String)
        return rstr
    }
}