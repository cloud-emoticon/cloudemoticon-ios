//
//  WaitView.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/9/11.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class WaitView: UIView {
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        let 半透明遮罩:UIView = UIView(frame: frame)
        半透明遮罩.backgroundColor = UIColor.blackColor()
        半透明遮罩.alpha = 0.5
        self.addSubview(半透明遮罩)
        let 提示框窗口:UIView = UIView(frame: CGRectMake(frame.size.width*0.5-100, frame.size.height*0.5-50, 200,100))
        提示框窗口.backgroundColor = UIColor.whiteColor()
        提示框窗口.layer.cornerRadius = 10
        self.addSubview(提示框窗口)
        let 提示文字:UILabel = UILabel(frame: CGRectMake(0,12, 提示框窗口.frame.size.width, 30))
        提示文字.textAlignment = NSTextAlignment.Center
        提示文字.font = UIFont(name: "STHeitiSC-Medium", size: 18)
        提示文字.text = lang.uage("加载中")
        提示框窗口.addSubview(提示文字)
        let 等待提示:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        等待提示.center = CGPointMake(提示框窗口.bounds.size.width/2.0, 提示框窗口.bounds.size.height/2.0+20);
        提示框窗口.addSubview(等待提示)
        等待提示.startAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

//    func 初始化()
//    {
//        self.backgroundColor = UIColor.clearColor()
//        let 半透明遮罩:UIView =
//    }

}
