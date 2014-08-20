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

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.alpha = 0.0
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0, 0)
        self.layer.shadowOpacity = 1.0;
        
        let 子元素坐标:CGRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        let 背景颜色:UIView = UIView(frame: 子元素坐标)
        背景颜色.backgroundColor = UIColor.blackColor()
        背景颜色.alpha = 0.7
        self.addSubview(背景颜色)
        显示文本.frame = 子元素坐标
        显示文本.textAlignment = NSTextAlignment.Center
        显示文本.textColor = UIColor.whiteColor()
        self.addSubview(显示文本)
    }
    
    func 显示颜文字复制到剪贴板提示(颜文字:NSString)
    {
        显示文本.text = NSString(format: "“ %@ ” 已复制到剪贴板", 颜文字)
        
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
