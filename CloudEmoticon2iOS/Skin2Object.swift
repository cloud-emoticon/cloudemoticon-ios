//
//  Skin2Object.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/5/30.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class Skin2Object: NSObject {
    
    func color(value:String) -> UIColor? {
        let RGBA色值数组:NSArray = value.componentsSeparatedByString(",")
        if (RGBA色值数组.count != 4) {
            return nil
        }
        let rr:NSString = RGBA色值数组.objectAtIndex(0) as! NSString
        let gg:NSString = RGBA色值数组.objectAtIndex(1) as! NSString
        let bb:NSString = RGBA色值数组.objectAtIndex(2) as! NSString
        let aa:NSString = RGBA色值数组.objectAtIndex(3) as! NSString
        var r:CGFloat = CGFloat(rr.floatValue) / 255.0
        var g:CGFloat = CGFloat(gg.floatValue) / 255.0
        var b:CGFloat = CGFloat(bb.floatValue) / 255.0
        var a:CGFloat = CGFloat(aa.floatValue) / 255.0
        if (r > 1 || g > 1 || b > 1 || a > 1 || r < 0 || g < 0 || b < 0 || a < 0) {
            return nil
        }
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func image(value:String) -> UIImage? {
        let 主题管理器:SkinManager = SkinManager()
        let skin文件夹 = 主题管理器.取skin文件夹路径()
        let 皮肤md5:String = 全局_皮肤设置.objectForKey("md5") as! String
        let 目标文件夹路径:String = NSString(format: "%@/%@/%@", skin文件夹, 皮肤md5, value) as String
        return UIImage(contentsOfFile: 目标文件夹路径)
    }
    
}
