//
//  QRActivity.swift
//  
//
//  Created by 神楽坂雅詩 on 15/6/21.
//
//

import UIKit

protocol QRViewDelegate:NSObjectProtocol{
    func 显示二维码()
}

class QRActivity: UIActivity {
    var 二维码图片:UIImage? = nil
    var 代理:QRViewDelegate?
    
    override func activityType() -> String? {
        return "ceqrcode"
    }
    override func activityTitle() -> String? {
        return lang.uage("二维码")
    }
    override func activityImage() -> UIImage? {
        return 二维码图片
//        return 调整图片大小(二维码图片!,目标尺寸: CGSizeMake(64, 64))
    }
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        
    }
    override func activityViewController() -> UIViewController? {
        return nil
    }
    override func performActivity() {
        代理?.显示二维码()
    }
    func 调整图片大小(源图片:UIImage,目标尺寸:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(CGSizeMake(目标尺寸.width, 目标尺寸.height))
        源图片.drawInRect(CGRectMake(0, 0, 目标尺寸.width, 目标尺寸.height))
        let 调整后图片:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return 调整后图片
    }
    func 设置二维码图片(二维码图:UIImage) {
        二维码图片 = 调整图片大小(二维码图,目标尺寸: CGSizeMake(64, 64))
    }
}
