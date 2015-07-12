//
//  M_SyncInfo.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/7/12.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit
import Parse

//数据模型：用户同步信息模型
class M_SyncInfo: NSObject {
    var owner:PFUser = PFUser() //用户
    var lastUploadTime:NSDate = NSDate() //上次上传时间
    var lastDownloadTime:NSDate = NSDate() //上次下载时间
    var lastUploadDevice:String = NSString(format: "%@/%@", UIDevice.currentDevice().name,UIDevice.currentDevice().model) as String //上次上传设备
    var lastUploadOS:String = NSString(format: "%@/%@", UIDevice.currentDevice().systemName,UIDevice.currentDevice().systemVersion) as String //上次上传系统
    var lastUploadAPP:String = NSString(format: "Cloud Emoticon for iOS 2/%@", NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String) as String //上次上传应用
    
    func show() {
        if (owner.username != nil) {
            NSLog("[M_SyncInfo]owner=%@",owner.username!)
        } else {
            NSLog("[M_SyncInfo]owner=<nil>")
        }
        NSLog("[M_SyncInfo]lastUploadTime=%@",lastUploadTime)
        NSLog("[M_SyncInfo]lastDownloadTime=%@",lastDownloadTime)
        NSLog("[M_SyncInfo]lastUploadDevice=%@",lastUploadDevice)
        NSLog("[M_SyncInfo]lastUploadOS=%@",lastUploadOS)
        NSLog("[M_SyncInfo]lastUploadAPP=%@",lastUploadAPP)
    }
}
