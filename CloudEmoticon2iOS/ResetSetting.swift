//
//  ResetSetting.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/4/25.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class ResetSetting: NSObject {
    
    func 清除Document文件夹() {
        let 文件管理器:Foundation.FileManager = Foundation.FileManager.default
        let 沙盒文件夹字典:NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let 文档文件夹路径:String = 沙盒文件夹字典[0] as! String
        var error:NSError? = nil
        let 文件列表对象:AnyObject?
        do {
            文件列表对象 = try 文件管理器.subpathsOfDirectory(atPath: 文档文件夹路径) as AnyObject?
        } catch let error1 as NSError {
            error = error1
            文件列表对象 = nil
        }
        if (error == nil && 文件列表对象 != nil) {
            let 文件列表:NSArray = 文件列表对象! as! NSArray
            for 文件名对象 in 文件列表 {
                let 文件名:String = 文件名对象 as! String
                let 要删除文件的完整路径:String = "\(文档文件夹路径)/\(文件名)"
                do {
                    try 文件管理器.removeItem(atPath: 要删除文件的完整路径)
                } catch let error1 as NSError {
                    error = error1
                }
                if (error != nil) {
                    NSLog("[重置]文件“%@”失败：%@",文件名,error!.localizedDescription)
                }
            }
        } else {
            NSLog("[重置]文件列表获得失败")
        }
    }
    
    func 清除应用设置() {
        let 组设置读写:AppGroupIO = AppGroupIO()
        组设置读写.清除标准程序设置()
    }
    
    func 清除AppGroup设置() {
        let 组设置读写:AppGroupIO = AppGroupIO()
        组设置读写.清除设置和对象UD模式()
        组设置读写.清除设置URL模式()
    }
}
