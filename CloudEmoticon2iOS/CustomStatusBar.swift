//
//  CustomStatusBar.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫喵 on 14/8/6.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class CustomStatusBar: UIWindow {
    
    var messageLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.messageLabel = UILabel()
        self.messageLabel.textAlignment = NSTextAlignment.Right
        self.messageLabel.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1)
        self.messageLabel.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        self.messageLabel.font = UIFont.systemFontOfSize(13.0)
        self.windowLevel = UIWindowLevelStatusBar + 1.0
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(self.messageLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showMsg(message: NSString)
    {
//        if (self.messageLabel == nil) { }
        self.hidden = false
        self.alpha = 1.0
        messageLabel.text = message as String
    }
    
    func hideMsg()
    {
        self.alpha = 1.0
        UIView.animateWithDuration(0.5,
            animations:{
                self.alpha = 0.0
            }, completion: {
                (Bool completion) in
            if completion {
                self.messageLabel.text = ""
                self.hidden = true
            }
        })
        
//        UIView.animateWithDuration(0.5, animations: {
//
//            }, completion: {
//                self.messageLabel.text = ""
//            })
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
