//
//  EnterView.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/5/3.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class EnterView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        let 背景渐变起始色:UIColor = UIColor(red: 1.00, green: 0.75, blue: 0.84, alpha: 1.0)
        let 背景渐变结束色:UIColor = UIColor(red: 0.99, green: 0.55, blue: 0.71, alpha: 1.0)
        self.backgroundColor = 背景渐变起始色
        let 渐变层:CAGradientLayer = CAGradientLayer()
        let 屏幕长:CGFloat = (self.frame.width > self.frame.height) ? self.frame.width : self.frame.height
        渐变层.frame = CGRect(x: 0, y: 0, width: 屏幕长, height: 屏幕长)
        渐变层.colors = [背景渐变起始色.cgColor,背景渐变结束色.cgColor]
        self.layer.insertSublayer(渐变层, at: 1)
        
        //这是一次失败的尝试
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
        
        let 剪影图片路径:String = Bundle.main.path(forResource: "cestart", ofType: "png")!
        let 剪影图片:UIImage = UIImage(contentsOfFile: 剪影图片路径)!
        
        //这里仅仅用于记录遮罩使用方法
//        var 遮罩层:CALayer = CALayer()
//        遮罩层.frame = frame
//        遮罩层.contents = 遮罩图片.CGImage
//        self.layer.mask = 遮罩层
        
        let 剪影图片视图:UIImageView = UIImageView(image: 剪影图片)
        let 屏幕短:CGFloat = (self.frame.width < self.frame.height) ? self.frame.width : self.frame.height
        let 剪影图片尺寸:CGFloat = 屏幕短 * 0.5
        剪影图片视图.frame = CGRect(x: self.frame.size.width * 0.5 - 剪影图片尺寸 * 0.5, y: self.frame.size.height * 0.5 - 剪影图片尺寸 * 0.5, width: 剪影图片尺寸, height: 剪影图片尺寸)
        剪影图片视图.center = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5)
        self.addSubview(剪影图片视图)
        
        //等待后面的UI渲染
        Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(EnterView.开始动画(_:)), userInfo: 剪影图片视图, repeats: false)
//        NSTimer(timeInterval: 5.0, target: self, selector: "开始动画:", userInfo: 剪影图片视图, repeats: false)
        
    }
    
    func 开始动画(_ sender:Timer) {
        self.frame = UIScreen.main.bounds
        let 剪影图片视图:UIImageView = sender.userInfo as! UIImageView
        let 屏幕短:CGFloat = (self.frame.width < self.frame.height) ? self.frame.width : self.frame.height
        let 剪影图片尺寸:CGFloat = 屏幕短 * 0.5
        剪影图片视图.frame = CGRect(x: self.frame.size.width * 0.5 - 剪影图片尺寸 * 0.5, y: self.frame.size.height * 0.5 - 剪影图片尺寸 * 0.5, width: 剪影图片尺寸, height: 剪影图片尺寸)
        剪影图片视图.center = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5)
        self.addSubview(剪影图片视图)
        UIView.animate(withDuration: 0.7, animations: { () -> Void in
            剪影图片视图.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }, completion: { (动画完成:Bool) -> Void in
                UIView.animate(withDuration: 0.45, animations: { () -> Void in
                    剪影图片视图.transform = CGAffineTransform(scaleX: 20, y: 20)
                    self.alpha = 0
                    }, completion: { (动画完成:Bool) -> Void in
                        self.removeFromSuperview()
                }) 
        }) 
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
