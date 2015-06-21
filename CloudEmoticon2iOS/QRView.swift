//
//  QRView.swift
//  
//
//  Created by 神楽坂雅詩 on 15/6/21.
//
//

import UIKit

class QRView: UIView {

    func 显示二维码(二维码:UIImage) {
        let 屏幕尺寸:CGRect = UIScreen.mainScreen().bounds
        let 屏幕中心点:CGPoint = CGPointMake(屏幕尺寸.size.width * 0.5, 屏幕尺寸.size.height * 0.5)
        let 图片尺寸:CGSize = 二维码.size
        self.frame = CGRectMake(0, 0, 图片尺寸.width, 图片尺寸.height)
        self.center = 屏幕中心点
        self.backgroundColor = UIColor.whiteColor()
//        self.image = 二维码
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0, 0)
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 20
        let 图片退出按钮:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        图片退出按钮.frame = CGRectMake(0, 0, 图片尺寸.width, 图片尺寸.height)
        图片退出按钮.setImage(二维码, forState: UIControlState.Normal)
        图片退出按钮.addTarget(self, action: "点击", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(图片退出按钮)
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }) { (isok:Bool) -> Void in
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            })
        }
    }
    
    func 点击() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(0.1, 0.1);
            }) { (isok:Bool) -> Void in
            self.removeFromSuperview()
        }
    }

}
