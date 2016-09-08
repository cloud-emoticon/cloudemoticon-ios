//
//  QRView.swift
//  
//
//  Created by 神楽坂雅詩 on 15/6/21.
//
//

import UIKit

class QRView: UIView {

    func 显示二维码(_ 二维码:UIImage) {
        let 屏幕尺寸:CGRect = UIScreen.main.bounds
        let 屏幕中心点:CGPoint = CGPoint(x: 屏幕尺寸.size.width * 0.5, y: 屏幕尺寸.size.height * 0.5)
        let 图片尺寸:CGSize = 二维码.size
        self.frame = CGRect(x: 0, y: 0, width: 图片尺寸.width, height: 图片尺寸.height)
        self.center = 屏幕中心点
        self.backgroundColor = UIColor.white
//        self.image = 二维码
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 20
        let 图片退出按钮:UIButton = UIButton(type: UIButtonType.custom)
        图片退出按钮.frame = CGRect(x: 0, y: 0, width: 图片尺寸.width, height: 图片尺寸.height)
        图片退出按钮.setImage(二维码, for: UIControlState())
        图片退出按钮.addTarget(self, action: #selector(QRView.点击), for: UIControlEvents.touchUpInside)
        self.addSubview(图片退出按钮)
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5);
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2);
        }, completion: { (isok:Bool) -> Void in
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            })
        }) 
    }
    
    func 点击() {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1);
            }, completion: { (isok:Bool) -> Void in
            self.removeFromSuperview()
        }) 
    }

}
