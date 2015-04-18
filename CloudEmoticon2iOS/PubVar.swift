//
//  PubVar.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/8.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//
import UIKit

var p_nowurl:NSString = "localhost"
var p_nowUserName:NSString = ""
var p_emodata:NSArray = NSArray()
var p_storeIsOpen:Bool = false
var 全局_网络繁忙:Bool = false
var bgimage:UIImage = UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("basicbg", ofType: "png")!)!
let documentDirectory:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
let documentDirectoryAddress:NSString = documentDirectory[0] as! NSString
let userbgimgname:NSString = NSString.localizedStringWithFormat("%@-bgimage.png", p_nowUserName)
let userbgimgfullpath:NSString = NSString.localizedStringWithFormat("%@/%@",documentDirectoryAddress, userbgimgname)
let appgroup:Bool = true //App-group总开关（未安装证书的情况下请关闭）
let 全局_文件管理:NSFileManager = NSFileManager.defaultManager()

enum NetDownloadTo:Int
{
    case NONE = 0
    case CLOUDEMOTICON = 1
    case SOURCEMANAGER = 2
    case CLOUDEMOTICONREFRESH = 3
}
var p_tempString:NSString = ""

var lang:Language = Language()

func 保存数据到输入法()
{
    var 收藏文件中的数据:NSArray? = FileManager().LoadArrayFromFile(FileManager.saveMode.FAVORITE)
    if (收藏文件中的数据 == nil) {
        收藏文件中的数据 = NSArray()
    }
    var 自定文件中的数据:NSArray? = FileManager().LoadArrayFromFile(FileManager.saveMode.CUSTOM)
    if (自定文件中的数据 == nil) {
        自定文件中的数据 = NSArray()
    }
    var 历史文件中的数据:NSArray? = FileManager().LoadArrayFromFile(FileManager.saveMode.HISTORY)
    if (历史文件中的数据 == nil) {
        历史文件中的数据 = NSArray()
    }
    let 要保存的数据:NSArray = [收藏文件中的数据!,自定文件中的数据!,历史文件中的数据!]
//    let 要保存的数据文本:NSString = ArrayString().array2json(要保存的数据)
    if (appgroup) {
//        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CloudEmoticon")!
//        containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
//        要保存的数据文本.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
//        NSLog("Group写入操作")
        let 组数据读写:AppGroupIO = AppGroupIO()
        组数据读写.写入数据UD模式(要保存的数据)
    }
}

func heightForString(value: NSString, FontSize fontSize:CGFloat, andWidth width:CGFloat) -> CGFloat
{
    var sizeTest:UILabel = UILabel(frame: CGRectMake(0, 0, width, 0))
    sizeTest.font = UIFont.systemFontOfSize(fontSize)
    sizeTest.text = NSString(string: value) as String
    sizeTest.lineBreakMode = NSLineBreakMode.ByCharWrapping
    sizeTest.numberOfLines = 0
    var deSize:CGSize = sizeTest.sizeThatFits(CGSizeMake(width,CGFloat.max))
    deSize.height = ceil(deSize.height)
    return deSize.height
}

/* 隐藏设置：
nowurl 当前选中源
*/