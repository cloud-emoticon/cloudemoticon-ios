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
        self.messageLabel.textAlignment = NSTextAlignment.right
        self.messageLabel.backgroundColor = UIColor.clear
       
//MARK - 主题
        
        self.messageLabel.textColor = UIColor.white
        
        self.messageLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.messageLabel.font = UIFont.systemFont(ofSize: 13.0)
        self.windowLevel = UIWindow.Level.statusBar + 1.0
        self.backgroundColor = UIColor.clear
        self.addSubview(self.messageLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showMsg(_ message: NSString)
    {
//        if (self.messageLabel == nil) { }
        self.isHidden = false
        self.alpha = 1.0
        messageLabel.text = message as String
    }
    
    func hideMsg()
    {
        self.alpha = 1.0
        UIView.animate(withDuration: 0.5,
            animations:{
                self.alpha = 0.0
            }, completion: {
                (completion) in
            if completion {
                self.messageLabel.text = ""
                self.isHidden = true
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
