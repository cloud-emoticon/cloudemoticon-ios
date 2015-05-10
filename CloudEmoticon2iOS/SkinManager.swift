//
//  SkinManager.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/5/10.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class SkinManager: NSObject {
    let 文件管理器:NSFileManager = NSFileManager.defaultManager()
    
    func 取skin文件夹路径() -> String { //不存在则创建
        let skin文件夹路径:String = "\(全局_文档文件夹)/skin"
        if (文件管理器.fileExistsAtPath(skin文件夹路径) == false) {
            文件管理器.createDirectoryAtPath(skin文件夹路径, withIntermediateDirectories: false, attributes: nil, error: nil)
        }
        return skin文件夹路径
    }
}
