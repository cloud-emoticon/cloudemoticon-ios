//
//  PubVar.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/8.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//
import UIKit
//class PubVar: NSObject {
//
//}


var p_nowurl:NSString = "localhost"
var p_nowUserName:NSString = ""
var p_emodata:NSArray = NSArray()
var p_storeIsOpen:Bool = false
var 全局_网络繁忙:Bool = false
var bgimage:UIImage = UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("basicbg", ofType: "png"))
let documentDirectory:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
let documentDirectoryAddress:NSString = documentDirectory[0] as NSString

enum NetDownloadTo:Int
{
    case NONE = 0
    case CLOUDEMOTICON = 1
    case SOURCEMANAGER = 2
    case CLOUDEMOTICONONLINE = 3
}
var p_tempString:NSString = ""

/* 隐藏设置：
nowurl 当前选中源
*/