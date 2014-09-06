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
var bgimage:UIImage = UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("basicbg", ofType: "png")!)
let documentDirectory:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
let documentDirectoryAddress:NSString = documentDirectory[0] as NSString
let userbgimgname:NSString = NSString.localizedStringWithFormat("%@-bgimage.png", p_nowUserName)
let userbgimgfullpath:NSString = NSString.localizedStringWithFormat("%@/%@",documentDirectoryAddress, userbgimgname)
let appgroup:Bool = false //App-group总开关（未安装证书的情况下请关闭）

enum NetDownloadTo:Int
{
    case NONE = 0
    case CLOUDEMOTICON = 1
    case SOURCEMANAGER = 2
    case CLOUDEMOTICONONLINE = 3
}
var p_tempString:NSString = ""

var lang:Language = Language()

func 保存数据到输入法()
{
    var 收藏文件中的数据:NSArray? = FileManager().LoadArrayFromFile(FileManager.saveMode.FAVORITE)
    if (收藏文件中的数据 == nil) {
        收藏文件中的数据 = NSArray.array()
    }
    var 自定文件中的数据:NSArray? = FileManager().LoadArrayFromFile(FileManager.saveMode.CUSTOM)
    if (自定文件中的数据 == nil) {
        自定文件中的数据 = NSArray.array()
    }
    var 历史文件中的数据:NSArray? = FileManager().LoadArrayFromFile(FileManager.saveMode.HISTORY)
    if (历史文件中的数据 == nil) {
        历史文件中的数据 = NSArray.array()
    }
    let 要保存的数据:NSArray = [收藏文件中的数据!,自定文件中的数据!,历史文件中的数据!]
    let 要保存的数据文本:NSString = ArrayString().array2json(要保存的数据)
    if (appgroup) {
        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CE2Keyboard")!
        containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
        要保存的数据文本.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
    }
}

/* 隐藏设置：
nowurl 当前选中源
*/