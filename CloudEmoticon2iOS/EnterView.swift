//
//  EnterView.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/5/3.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class EnterView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let 背景渐变起始色:UIColor = UIColor(red: 1.00, green: 0.75, blue: 0.84, alpha: 1.0)
        let 背景渐变结束色:UIColor = UIColor(red: 0.99, green: 0.55, blue: 0.71, alpha: 1.0)
        self.backgroundColor = 背景渐变起始色
        var 渐变层:CAGradientLayer = CAGradientLayer()
        渐变层.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        渐变层.colors = [背景渐变起始色.CGColor,背景渐变结束色.CGColor]
        self.layer.insertSublayer(渐变层, atIndex: 1)
        
        //QAQ
//        var context:CGContextRef = UIGraphicsGetCurrentContext();
//        // 创建色彩空间对象
//        var colorSpaceRef:CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
//        // 创建起点颜色
//        var beginColor:CGColorRef = CGColorCreate(colorSpaceRef, [1.00,0.75,0.84,1.0])
//        // 创建终点颜色
//        var endColor:CGColorRef = CGColorCreate(colorSpaceRef, [0.99,0.55,0.71,1.0])
//        // 创建颜色数组
////var colorArray:CFArrayRef = CFArrayCreate(kCFAllocatorDefault, values: [beginColor,endColor], numValues: 2, callBacks: nil)
//        // 创建渐变对象
//        var gradientRef:CGGradientRef = CGGradientCreateWithColors(colorSpaceRef, [beginColor,endColor], [0.0,1.0])
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
