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
    var nowURLarr:NSArray = []
    
    enum saveMode:Int
    {
        case NETWORK = 0
        case HISTORY
        case FAVORITE
        case CUSTOM
    }
    
   
    //本地文件操作
    func SaveArrayToFile(arr:NSArray, smode:saveMode)
    {
        let fileName:NSString = FileName(smode)
        let fulladd:NSString = FileNameToFullAddress(fileName)
        let isDop:Bool = ChkDupFile(fileName)
        if (isDop) {
            fileMgr.removeItemAtPath(fulladd, error: nil)
        }

        arr.writeToFile(fulladd, atomically: false)
    }
    
    func LoadArrayFromFile(smode:saveMode) -> NSArray?
    {
        let fileName:NSString = FileName(smode)
        let fulladd:NSString = FileNameToFullAddress(fileName)
        let isDop:Bool = ChkDupFile(fileName)
        if (isDop) {
            NSLog("%@从本地加载源...",className)
            let arr:NSArray = NSArray(contentsOfFile: fulladd)
            return arr
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("loaddataok2", object: nowURLarr)
        return nil
    }
    
    func deleteFile(urlStr:NSString, smode:saveMode)
    {
        let md5coder:MD5 = MD5()
        let fileName:NSString = NSString(format: "%@.plist", md5coder.md5(urlStr))
        let fulladd:NSString = FileNameToFullAddress(fileName)
        let isDop:Bool = ChkDupFile(fileName)
        if (isDop) {
            fileMgr.removeItemAtPath(fulladd, error: nil)
        }
    }
    
    func FileName(smode:saveMode) -> NSString
    {
        switch (smode) {
        case saveMode.NETWORK:
            let md5coder:MD5 = MD5()
            var md5vol:NSString = md5coder.md5(p_nowurl)
            let nowURLstr:NSString = nowURLarr.objectAtIndex(0) as NSString
            if (!nowURLstr.isEqualToString("")) {
                md5vol = md5coder.md5(nowURLstr)
            }
            return NSString.localizedStringWithFormat("%@.plist",md5vol)
        case saveMode.HISTORY:
            return NSString.localizedStringWithFormat("%@-history.plist",p_nowUserName)
        case saveMode.FAVORITE:
            return NSString.localizedStringWithFormat("%@-favorite.plist",p_nowUserName)
        case saveMode.CUSTOM:
            return NSString.localizedStringWithFormat("%@-custom.plist",p_nowUserName)
        default:
            break;
        }
    }
    
    func ChkDupFile(filename:NSString) -> Bool
    {
        let filelist:NSArray = fileMgr.contentsOfDirectoryAtPath(DocumentDirectoryAddress(), error: nil)
        for nowfilenameObj in filelist
        {
            let nowfilename:NSString = nowfilenameObj as NSString
            if (filename.isEqualToString(nowfilename))
            {
                return true
            }
        }
        return false
    }
    
    func DocumentDirectoryAddress() -> NSString
    {
        let documentDirectory:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryAddress:NSString = documentDirectory[0] as NSString
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
        let sarr:NSArray = NSArray(contentsOfFile: fulladd)
        return sarr;
    }
    func saveSources(sarr:NSArray)
    {
        sarr.writeToFile(FileNameToFullAddress("SourcesList.plist"), atomically: false)
    }
}
