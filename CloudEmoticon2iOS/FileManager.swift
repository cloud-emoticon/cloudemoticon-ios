//
//  FileManager.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫喵 on 14/8/5.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class FileManager: NSObject {
    
    let fileMgr:NSFileManager = NSFileManager.defaultManager()
    let className:NSString = "[文件管理器]"
    var nowURLarr:NSArray = [""]
    
    enum saveMode:Int
    {
        case NETWORK = 0
        case HISTORY
        case FAVORITE
        case CUSTOM
        case ONLINE
        case SKIN
    }
    
   
    //本地文件操作
    func SaveArrayToFile(arr:NSArray, smode:saveMode)
    {
        let fileName:NSString = FileName(smode)
        let fulladd:NSString = FileNameToFullAddress(fileName)
        let isDop:Bool = ChkDupFile(fileName)
        if (isDop) {
            fileMgr.removeItemAtPath(fulladd as String, error: nil)
        }

        arr.writeToFile(fulladd as String, atomically: false)
        if (smode == saveMode.NETWORK || smode == saveMode.ONLINE) {
            NSNotificationCenter.defaultCenter().postNotificationName("loaddataok", object: nowURLarr)
        }
    }
    
    func LoadArrayFromFile(smode:saveMode) -> NSArray?
    {
        let fileName:NSString = FileName(smode)
        let fulladd:NSString = FileNameToFullAddress(fileName)
        let isDop:Bool = ChkDupFile(fileName)
        if (isDop) {
            NSLog("%@本地加载中...",className)
            let arr:NSArray = NSArray(contentsOfFile: fulladd  as String)!
            return arr
        }
        if (smode == saveMode.NETWORK || smode == saveMode.ONLINE) {
            NSNotificationCenter.defaultCenter().postNotificationName("loaddataoks", object: nowURLarr)
        }
        return nil
    }
    
    func deleteFile(urlStr:NSString, smode:saveMode)
    {
        let fileName:NSString = NSString(format: "cache-%@.plist", md5(urlStr as String))
        let fulladd:NSString = FileNameToFullAddress(fileName)
        let isDop:Bool = ChkDupFile(fileName)
        if (isDop) {
            fileMgr.removeItemAtPath(fulladd as String, error: nil)
        }
    }
    
    func FileName(smode:saveMode) -> NSString
    {
        switch (smode) {
        case saveMode.NETWORK:
            var md5vol:NSString = md5(p_nowurl as String)
            let nowURLstr:NSString = nowURLarr.objectAtIndex(0) as! NSString
            if (!nowURLstr.isEqualToString("")) {
                md5vol = md5(nowURLstr as String)
            }
            return NSString.localizedStringWithFormat("cache-%@.plist",md5vol)
        case saveMode.HISTORY:
            return NSString.localizedStringWithFormat("%@-history.plist",p_nowUserName)
        case saveMode.FAVORITE:
            return NSString.localizedStringWithFormat("%@-favorite.plist",p_nowUserName)
        case saveMode.CUSTOM:
            return NSString.localizedStringWithFormat("%@-custom.plist",p_nowUserName)
        case saveMode.SKIN:
            return NSString.localizedStringWithFormat("%@-skin.plist",p_nowUserName)
        default:
            return NSString()
        }
    }
    
    func ChkDupFile(filename:NSString) -> Bool
    {
        let filelist:NSArray = fileMgr.contentsOfDirectoryAtPath(DocumentDirectoryAddress() as String, error: nil)!
        for nowfilenameObj in filelist
        {
            let nowfilename:NSString = nowfilenameObj as! NSString
            if (filename.isEqualToString(nowfilename as String))
            {
                return true
            }
        }
        return false
    }
    
    func DocumentDirectoryAddress() -> NSString
    {
        let documentDirectory:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryAddress:NSString = documentDirectory[0] as! NSString
        return NSString.localizedStringWithFormat("%@/",documentDirectoryAddress)
    }
    
    func FileNameToFullAddress(filename:NSString) -> NSString
    {
        return NSString.localizedStringWithFormat("%@%@",DocumentDirectoryAddress(),filename)
    }
    
    //源管理
    func loadSources() -> NSArray
    {
        let fulladd:NSString = FileNameToFullAddress("SourcesList.plist")
        
        let isDup:Bool = ChkDupFile("SourcesList.plist")
        if (!isDup) {
            return NSArray()
        }
        let sarr:NSArray = NSArray(contentsOfFile: fulladd as String)!
        return sarr
    }
    func saveSources(sarr:NSArray)
    {
        sarr.writeToFile(FileNameToFullAddress("SourcesList.plist") as String, atomically: false)
    }
    
    func 补充空白数据()
    {
//        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CloudEmoticon")!
//        var value:NSString
//        containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
//        var emolist:NSString? = NSString(contentsOfURL: containerURL, encoding: NSUTF8StringEncoding, error: nil)
//        if(emolist == nil || emolist == "") {
//            var 新建数据模型:NSArray = [NSArray(),NSArray(),NSArray()]
//            value = ArrayString().array2json(新建数据模型)
//            value.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
//            NSLog("Group写入操作")
//        }
        let 组数据读写:AppGroupIO = AppGroupIO()
        if (组数据读写.读取设置UD模式() == nil) {
            组数据读写.写入设置UD模式(组数据读写.新建设置())
        }
    }
}
