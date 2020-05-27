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
    let 动画速度:TimeInterval = 0.8
    let 背景颜色:UIView = UIView()

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y - 4, width: frame.size.width, height: frame.size.height + 8))
        self.backgroundColor = UIColor.clear
        self.alpha = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1.0
        
        let 子元素坐标:CGRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        背景颜色.frame = 子元素坐标
        背景颜色.alpha = 1
        self.addSubview(背景颜色)
        显示文本.frame = 子元素坐标
        显示文本.textAlignment = NSTextAlignment.center
        显示文本.lineBreakMode = NSLineBreakMode.byCharWrapping
        显示文本.numberOfLines = 0
        self.addSubview(显示文本)
        
        切换主题()
    }
    
    func 切换主题() {
        NSLog("[Skin]->NotificationView")
        //初始设置
        self.layer.shadowColor = UIColor.black.cgColor
        背景颜色.backgroundColor = UIColor.white
        显示文本.textColor = UIColor.black
        
        if (全局_皮肤设置.count > 0 && 全局_皮肤设置.object(forKey: "md5") != nil) {
            let 主题参数转对象:Skin2Object = Skin2Object()
            
            //RGBA色值：提示框背景颜色
            let messagebox_bgcolor_S:String = 全局_皮肤设置.object(forKey: "messagebox_bgcolor") as! String
            NSLog("[Skin]messagebox_bgcolor_S=%@",messagebox_bgcolor_S)
            if (messagebox_bgcolor_S != "null") {
                let messagebox_bgcolor:UIColor? = 主题参数转对象.color(messagebox_bgcolor_S)
                if (messagebox_bgcolor != nil) {
                    背景颜色.backgroundColor = messagebox_bgcolor
                }
            }
            
            //RGBA色值：提示框文字颜色
            let messagebox_textcolor_S:String = 全局_皮肤设置.object(forKey: "messagebox_textcolor") as! String
            NSLog("[Skin]messagebox_textcolor_S=%@",messagebox_textcolor_S)
            if (messagebox_textcolor_S != "null") {
                let messagebox_textcolor:UIColor? = 主题参数转对象.color(messagebox_textcolor_S)
                if (messagebox_textcolor != nil) {
                    显示文本.textColor = messagebox_textcolor
                }
            }
            
            //RGBA色值：提示框阴影颜色
            let messagebox_shadowcolor_S:String = 全局_皮肤设置.object(forKey: "messagebox_shadowcolor") as! String
            NSLog("[Skin]messagebox_shadowcolor_S=%@",messagebox_shadowcolor_S)
            if (messagebox_shadowcolor_S != "null") {
                let messagebox_shadowcolor:UIColor? = 主题参数转对象.color(messagebox_shadowcolor_S)
                if (messagebox_shadowcolor != nil) {
                    self.layer.shadowColor = messagebox_shadowcolor!.cgColor
                }
            }
            
        }
    }
    
    func 显示提示(_ 提示文本:NSString)
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
        UIView.animate(withDuration: 动画速度,
            animations:{
                self.alpha = 1.0
            }, completion: {
                (completion) in
                if completion {
                    Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(NotificationView.关闭窗口(_:)), userInfo: nil, repeats: false).fire()
                }
        })
    }
    
    @objc func 关闭窗口(_ sender:Timer)
    {
        UIView.animate(withDuration: 动画速度,
            animations:{
                self.alpha = 0.0
            }, completion: {
                (completion) in
                if completion {
                    self.removeFromSuperview()
                }
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
