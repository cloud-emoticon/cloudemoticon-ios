//
//  M_SyncInfo.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/7/12.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit
//import Parse

//数据模型：用户同步信息模型
class M_SyncInfo: NSObject {
//    var owner:PFUser = PFUser() //用户
    var lastUploadTime:Date = Date() //上次上传时间
    var lastDownloadTime:Date = Date() //上次下载时间
    var lastUploadDevice:String = NSString(format: "%@/%@", UIDevice.current.name,UIDevice.current.model) as String //上次上传设备
    var lastUploadOS:String = NSString(format: "%@/%@", UIDevice.current.systemName,UIDevice.current.systemVersion) as String //上次上传系统
    var lastUploadAPP:String = NSString(format: "Cloud Emoticon for iOS 2/%@", Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String) as String //上次上传应用
    
    func show() {
//        if (owner.username != nil) {
//            NSLog("[M_SyncInfo]owner=%@",owner.username!)
//        } else {
//            NSLog("[M_SyncInfo]owner=<nil>")
//        }
        print("[M_SyncInfo]lastUploadTime=%@",lastUploadTime)
        print("[M_SyncInfo]lastDownloadTime=%@",lastDownloadTime)
        print("[M_SyncInfo]lastUploadDevice=%@",lastUploadDevice)
        print("[M_SyncInfo]lastUploadOS=%@",lastUploadOS)
        print("[M_SyncInfo]lastUploadAPP=%@",lastUploadAPP)
    }
}
