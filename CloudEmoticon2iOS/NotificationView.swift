//
//  NotificationView.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/20.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class NotificationView: UIView {
    
    var 显示文本:UILabel = UILabel()
    let 动画速度:NSTimeInterval = 0.8
    let 背景颜色:UIView = UIView()

    override init(frame: CGRect) {
        super.init(frame: CGRectMake(frame.origin.x, frame.origin.y - 4, frame.size.width, frame.size.height + 8))
        self.backgroundColor = UIColor.clearColor()
        self.alpha = 0
        self.layer.shadowOffset = CGSizeMake(0, 0)
        self.layer.shadowOpacity = 1.0
        
        let 子元素坐标:CGRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        背景颜色.frame = 子元素坐标
        背景颜色.alpha = 1
        self.addSubview(背景颜色)
        显示文本.frame = 子元素坐标
        显示文本.textAlignment = NSTextAlignment.Center
        显示文本.lineBreakMode = NSLineBreakMode.ByCharWrapping
        显示文本.numberOfLines = 0
        self.addSubview(显示文本)
        
        切换主题()
    }
    
    func 切换主题() {
        NSLog("[Skin]->NotificationView")
        //初始设置
        self.layer.shadowColor = UIColor.blackColor().CGColor
        背景颜色.backgroundColor = UIColor.whiteColor()
        显示文本.textColor = UIColor.blackColor()
        
        if (全局_皮肤设置.count > 0 && 全局_皮肤设置.objectForKey("md5") != nil) {
            let 主题参数转对象:Skin2Object = Skin2Object()
            
            //RGBA色值：提示框背景颜色
            let messagebox_bgcolor_S:String = 全局_皮肤设置.objectForKey("messagebox_bgcolor") as! String
            NSLog("[Skin]messagebox_bgcolor_S=%@",messagebox_bgcolor_S)
            if (messagebox_bgcolor_S != "null") {
                let messagebox_bgcolor:UIColor? = 主题参数转对象.color(messagebox_bgcolor_S)
                if (messagebox_bgcolor != nil) {
                    背景颜色.backgroundColor = messagebox_bgcolor
                }
            }
            
            //RGBA色值：提示框文字颜色
            let messagebox_textcolor_S:String = 全局_皮肤设置.objectForKey("messagebox_textcolor") as! String
            NSLog("[Skin]messagebox_textcolor_S=%@",messagebox_textcolor_S)
            if (messagebox_textcolor_S != "null") {
                let messagebox_textcolor:UIColor? = 主题参数转对象.color(messagebox_textcolor_S)
                if (messagebox_textcolor != nil) {
                    显示文本.textColor = messagebox_textcolor
                }
            }
            
            //RGBA色值：提示框阴影颜色
            let messagebox_shadowcolor_S:String = 全局_皮肤设置.objectForKey("messagebox_shadowcolor") as! String
            NSLog("[Skin]messagebox_shadowcolor_S=%@",messagebox_shadowcolor_S)
            if (messagebox_shadowcolor_S != "null") {
                let messagebox_shadowcolor:UIColor? = 主题参数转对象.color(messagebox_shadowcolor_S)
                if (messagebox_shadowcolor != nil) {
                    self.layer.shadowColor = messagebox_shadowcolor!.CGColor
                }
            }
            
        }
    }
    
    func 显示提示(提示文本:NSString)
    {
        显示文本.text = 提示文本 as String
        执行动画()
    }
    
//    func 显示颜文字复制到剪贴板提示(颜文字:NSString)
//    {
//        显示文本.text = NSString(format: "“ %@ ” 已复制到剪贴板", 颜文字)
//        执行动画()
//    }
//    func 显示颜文字添加到收藏夹提示(颜文字:NSString)
//    {
//        显示文本.text = NSString(format: "“ %@ ” 添加到收藏夹成功", 颜文字)
//        执行动画()
//    }
//    func 显示颜文字收藏已存在提示(颜文字:NSString)
//    {
//        显示文本.text = NSString(format: "你已经收藏了 “ %@ ”", 颜文字)
//        执行动画()
//    }
    
    func 执行动画()
    {
        UIView.animateWithDuration(动画速度,
            animations:{
                self.alpha = 1.0
            }, completion: {
                (Bool completion) in
                if completion {
                    NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "关闭窗口:", userInfo: nil, repeats: false).fire()
                }
        })
    }
    
    func 关闭窗口(sender:NSTimer)
    {
        UIView.animateWithDuration(动画速度,
            animations:{
                self.alpha = 0.0
            }, completion: {
                (Bool completion) in
                if completion {
                    self.removeFromSuperview()
                }
        })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
