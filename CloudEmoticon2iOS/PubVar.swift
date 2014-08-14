//
//  PubVar.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/8.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//
//import UIKit
//class PubVar: NSObject {
//
//}


var p_nowurl:NSString = ""
var p_nowUserName:NSString = ""
var p_emodata:NSArray = NSArray()
var p_storeIsOpen:Bool = false

enum NetDownloadTo:Int
{
    case NONE = 0
    case CLOUDEMOTICON = 1
    case SOURCEMANAGER = 2
}
var p_tempString:NSString = ""