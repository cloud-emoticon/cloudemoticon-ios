//
//  Skin2Object.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/5/30.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class Skin2Object: NSObject {
    
    func color(_ value:String?) -> UIColor? {
        if (value == nil) {
            return UIColor.red
        }
        let RGBA色值数组:NSArray = value!.components(separatedBy: ",") as NSArray
        if (RGBA色值数组.count != 4) {
            return nil
        }
        let rr:NSString = RGBA色值数组.object(at: 0) as! NSString
        let gg:NSString = RGBA色值数组.object(at: 1) as! NSString
        let bb:NSString = RGBA色值数组.object(at: 2) as! NSString
        let aa:NSString = RGBA色值数组.object(at: 3) as! NSString
        let r:CGFloat = CGFloat(rr.floatValue) / 255.0
        let g:CGFloat = CGFloat(gg.floatValue) / 255.0
        let b:CGFloat = CGFloat(bb.floatValue) / 255.0
        let a:CGFloat = CGFloat(aa.floatValue) / 255.0
        if (r > 1 || g > 1 || b > 1 || a > 1 || r < 0 || g < 0 || b < 0 || a < 0) {
            return nil
        }
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func image(_ value:String?) -> UIImage? {
        if (value == nil) {
            return UIImage(contentsOfFile: Bundle.main.path(forResource: "test", ofType: "jpg")!)!
        }
        let 主题管理器:SkinManager = SkinManager()
        let skin文件夹 = 主题管理器.取skin文件夹路径()
        let 皮肤md5:String = 全局_皮肤设置.object(forKey: "md5") as! String
        let 目标文件夹路径:String = NSString(format: "%@/%@/%@", skin文件夹, 皮肤md5, value!) as String
        let 返回图片:UIImage? = UIImage(contentsOfFile: 目标文件夹路径)
        if (返回图片 == nil) {
            NSLog("[Skin2Object]无法加载图片文件%@", 目标文件夹路径)
        }
        return 返回图片
    }
    
    func 判断应该显示的背景图() -> String {
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
            if (UIDevice.current.orientation.isPortrait) {
                return "background_image_iphone_h"
            } else {
                return "background_image_iphone_w"
            }
        } else {
            if (UIDevice.current.orientation.isPortrait) {
                return "background_image_ipad_h"
            } else {
                return "background_image_ipad_w"
            }
        }
    }
    
}
