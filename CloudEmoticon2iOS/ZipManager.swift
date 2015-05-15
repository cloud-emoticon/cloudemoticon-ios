//
//  ZipManager.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/5/16.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class ZipManager: NSObject {
    
    let 内置解压缩密码:String = "test"
    var 文件序号:CGFloat = 0
    var 解压缩线程:NSThread? = nil
    var 压缩工作中:Bool = false
    var 压缩文件:NSString = ""
    var 解压缩文件:NSString = ""
    
    func 解压缩文件(压缩文件路径:String,解压缩文件路径:String) {
        压缩文件 = 压缩文件路径
        解压缩文件 = 解压缩文件路径
        
    }
}
