//
//  FileManager.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫喵 on 14/8/5.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class FileManager: NSObject {
    
    let fileMgr:Foundation.FileManager = Foundation.FileManager.default
    let className:NSString = "[文件管理器]"
    var nowURLarr:NSArray = [""]
    
    enum saveMode:Int
    {
        case network = 0
        case history
        case favorite
        case custom
        case online
        case skin
    }
    
   
    //本地文件操作
    func SaveArrayToFile(_ arr:NSArray, smode:saveMode)
    {
        let fileName:NSString = FileName(smode)
        let fulladd:NSString = FileNameToFullAddress(fileName)
        let isDop:Bool = ChkDupFile(fileName)
        if (isDop) {
            do {
                try fileMgr.removeItem(atPath: fulladd as String)
            } catch _ {
            }
        }

        arr.write(toFile: fulladd as String, atomically: false)
        if (smode == saveMode.network || smode == saveMode.online) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "loaddataok"), object: nowURLarr)
        }
    }
    
    func LoadArrayFromFile(_ smode:saveMode) -> NSArray?
    {
        let fileName:NSString = FileName(smode)
        let fulladd:NSString = FileNameToFullAddress(fileName)
        let isDop:Bool = ChkDupFile(fileName)
        if (isDop) {
            NSLog("%@本地加载中...",className)
            let arr:NSArray = NSArray(contentsOfFile: fulladd  as String)!
            return arr
        }
        if (smode == saveMode.network || smode == saveMode.online) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "loaddataoks"), object: nowURLarr)
        }
        return nil
    }
    
    func deleteFile(_ urlStr:NSString, smode:saveMode)
    {
        let fileName:NSString = NSString(format: "cache-%@.plist", md5(urlStr as String))
        let fulladd:NSString = FileNameToFullAddress(fileName)
        let isDop:Bool = ChkDupFile(fileName)
        if (isDop) {
            do {
                try fileMgr.removeItem(atPath: fulladd as String)
            } catch _ {
            }
        }
    }
    
    func FileName(_ smode:saveMode) -> NSString
    {
        switch (smode) {
        case saveMode.network:
            var md5vol:NSString = md5(p_nowurl as String) as NSString
            let nowURLstr:NSString = nowURLarr.object(at: 0) as! NSString
            if (!nowURLstr.isEqual(to: "")) {
                md5vol = md5(nowURLstr as String) as NSString
            }
            return NSString.localizedStringWithFormat("cache-%@.plist",md5vol)
        case saveMode.history:
            return NSString.localizedStringWithFormat("%@-history.plist",全局_当前用户名)
        case saveMode.favorite:
            return NSString.localizedStringWithFormat("%@-favorite.plist",全局_当前用户名)
        case saveMode.custom:
            return NSString.localizedStringWithFormat("%@-custom.plist",全局_当前用户名)
        case saveMode.skin:
            return NSString.localizedStringWithFormat("%@-skin.plist",全局_当前用户名)
        default:
            return NSString()
        }
    }
    
    func ChkDupFile(_ filename:NSString) -> Bool
    {
        let filelist:NSArray = try! fileMgr.contentsOfDirectory(atPath: DocumentDirectoryAddress() as String) as NSArray
        for nowfilenameObj in filelist
        {
            let nowfilename:NSString = nowfilenameObj as! NSString
            if (filename.isEqual(to: nowfilename as String))
            {
                return true
            }
        }
        return false
    }
    
    func DocumentDirectoryAddress() -> NSString
    {
        let documentDirectory:NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentDirectoryAddress:NSString = documentDirectory[0] as! NSString
        return NSString.localizedStringWithFormat("%@/",documentDirectoryAddress)
    }
    
    func FileNameToFullAddress(_ filename:NSString) -> NSString
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
    func saveSources(_ sarr:NSArray)
    {
        sarr.write(toFile: FileNameToFullAddress("SourcesList.plist") as String, atomically: false)
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
