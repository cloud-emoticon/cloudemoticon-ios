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
let defaultimage:UIImage = UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("basicbg", ofType: "png")!)!

let documentDirectory:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
let 全局_文档文件夹:NSString = documentDirectory[0] as! NSString
let userbgimgname:NSString = NSString.localizedStringWithFormat("%@-bgimage.png", p_nowUserName)
let userbgimgfullpath:NSString = NSString.localizedStringWithFormat("%@/%@",全局_文档文件夹, userbgimgname)
let appgroup:Bool = true //App-group总开关（未安装证书的情况下请关闭）
let 全局_文件管理:NSFileManager = NSFileManager.defaultManager()
var 全局_皮肤设置:NSDictionary = NSDictionary()
let 全局_默认当前选中行颜色:UIColor = UIColor(red: 66/255.0, green: 165/255.0, blue: 244/255.0, alpha: 0.3)


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
//    var 主题文件中的数据:NSArray? = FileManager().LoadArrayFromFile(FileManager.saveMode.SKIN)
//    if (主题文件中的数据 == nil) {
//        主题文件中的数据 = NSArray()
//    }
    let 组数据读写:AppGroupIO = AppGroupIO()
    var 当前主题数据:NSArray = NSArray()
    var 组数据:NSArray?
    if (组数据读写.检查设置UD模式()) {
        组数据 = 组数据读写.读取设置UD模式()!
        if (组数据?.count != 4) {
            NSLog("[致命错误]数据模型被损坏，崩崩崩！")
        }
        var 当前主题数据:NSArray = 组数据!.objectAtIndex(3) as! NSArray
    }
    let 要保存的数据:NSArray = [收藏文件中的数据!,自定文件中的数据!,历史文件中的数据!,当前主题数据]
//    let 要保存的数据文本:NSString = ArrayString().array2json(要保存的数据)
    if (appgroup) {
//        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CloudEmoticon")!
//        containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
//        要保存的数据文本.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
//        NSLog("Group写入操作")
        
        组数据读写.写入设置UD模式(要保存的数据)
    }
}

func loadbg() -> UIImage {
    let bg:UIImage? = UIImage(contentsOfFile: userbgimgfullpath as String)
    if(bg != nil){
        bgimage = bg!
        } else {
        bgimage = defaultimage
    }
    return bgimage
}

func loadopc() -> CGFloat
{
    var bgopacity:Float? = NSUserDefaults.standardUserDefaults().valueForKey("bgopacity") as? Float
    return NSNumber(float: ((100 - bgopacity! / 2) / 100)) as CGFloat

}

func 计算单元格高度(要显示的文字:NSString, 字体大小:CGFloat, 单元格宽度:CGFloat) -> CGFloat
{
    var 高度测试虚拟标签:UILabel = UILabel(frame: CGRectMake(0, 0, 单元格宽度, 0))
    高度测试虚拟标签.font = UIFont.systemFontOfSize(字体大小)
    高度测试虚拟标签.text = NSString(string: 要显示的文字) as String
    高度测试虚拟标签.lineBreakMode = NSLineBreakMode.ByCharWrapping
    高度测试虚拟标签.numberOfLines = 0
    var 计算后尺寸:CGSize = 高度测试虚拟标签.sizeThatFits(CGSizeMake(单元格宽度,CGFloat.max))
    计算后尺寸.height = ceil(计算后尺寸.height)
    return 计算后尺寸.height
}

/* 隐藏设置：
nowurl 当前选中源
*/