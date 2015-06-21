//
//  UserTableHeaderView.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/6/13.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class UserTableHeaderView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    let 头像图标:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    let 设置图标:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    let 主标题:UILabel = UILabel()
    let 副标题:UILabel = UILabel()
    let 背景图片:UIImageView = UIImageView()
    var 默认前景色:UIColor? = nil
    let 按钮:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    
    func 载入内容() {
        let 头像大小:CGFloat = 32
        let 设置按钮大小:CGFloat = 16
        let 边界距离:CGFloat = 5
        self.backgroundColor = 全局_默认当前选中行颜色
        默认前景色 = 头像图标.tintColor
        背景图片.backgroundColor = UIColor.clearColor()
        背景图片.contentMode = UIViewContentMode.ScaleAspectFill
        背景图片.clipsToBounds = true
        背景图片.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.addSubview(背景图片)
        头像图标.frame = CGRectMake(边界距离, self.frame.size.height - 头像大小 - 边界距离, 头像大小, 头像大小)
        头像图标.backgroundColor = UIColor.clearColor()
        self.addSubview(头像图标)
        主标题.frame = CGRectMake(边界距离 * 2 + 头像大小, 头像图标.frame.origin.y, self.frame.size.width - 边界距离 * 3 - 头像大小, 20)
        主标题.text = "神楽坂雅詩"
        主标题.font = UIFont.systemFontOfSize(12)
        self.addSubview(主标题)
        副标题.frame = CGRectMake(边界距离 * 2 + 头像大小, 主标题.frame.origin.y + 主标题.frame.size.height, self.frame.size.width - 边界距离 * 3 - 头像大小, 12)
        副标题.text = "cxchope@163.com"
        副标题.font = UIFont.systemFontOfSize(9)
        self.addSubview(副标题)
        设置图标.frame = CGRectMake(self.frame.size.width - 边界距离 - 设置按钮大小, 边界距离, 设置按钮大小, 设置按钮大小)
        self.addSubview(设置图标)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "切换主题", name: "切换主题通知", object: nil)
        按钮.frame = 背景图片.frame
        按钮.addTarget(self, action: "点击", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(按钮)
        切换主题()
    }
    
    func 切换主题() {
        NSLog("[Skin]->UserTableHeaderView")
        //初始设置
        self.backgroundColor = 全局_默认当前选中行颜色
        背景图片.image = nil
        let 头像图标图片:UIImage = UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("shared-vector@2x", ofType: "png")!)!
        头像图标.setImage(头像图标图片, forState: UIControlState.Normal)
        let 设置图标图片:UIImage = UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("settings-vector", ofType: "png")!)!
        设置图标.setImage(设置图标图片, forState: UIControlState.Normal)
        设置图标.tintColor = 默认前景色
        头像图标.tintColor = 默认前景色
        主标题.textColor = 默认前景色
        副标题.textColor = 默认前景色
        
        if (全局_皮肤设置.count > 0 && 全局_皮肤设置.objectForKey("md5") != nil) {
            let 主题参数转对象:Skin2Object = Skin2Object()
            
            //RGBA色值：用户登录状态框底色
            let loginstat_bgcolor_S:String = 全局_皮肤设置.objectForKey("loginstat_bgcolor") as! String
            NSLog("[Skin]loginstat_bgcolor_S=%@",loginstat_bgcolor_S)
            if (loginstat_bgcolor_S != "null") {
                let loginstat_bgcolor:UIColor? = 主题参数转对象.color(loginstat_bgcolor_S) //loginstat_bgcolor_S
                if (loginstat_bgcolor != nil) {
                    self.backgroundColor = loginstat_bgcolor
                }
            }
            
            //图片文件名：用户登录状态框背景图片
            let loginstat_bgimage_S:String = 全局_皮肤设置.objectForKey("loginstat_bgimage") as! String
            NSLog("[Skin]loginstat_bgimage_S=%@",loginstat_bgimage_S)
            if (loginstat_bgimage_S != "null") {
                let loginstat_bgimage:UIImage? = 主题参数转对象.image(loginstat_bgimage_S) //loginstat_bgimage_S
                if (loginstat_bgimage != nil) {
                    背景图片.image = loginstat_bgimage
                }
            }
            
            //图片文件名：默认头像图片
            let loginstat_faceimg_S:String = 全局_皮肤设置.objectForKey("loginstat_faceimg") as! String
            NSLog("[Skin]loginstat_faceimg_S=%@",loginstat_faceimg_S)
            if (loginstat_faceimg_S != "null") {
                let loginstat_faceimg:UIImage? = 主题参数转对象.image(loginstat_faceimg_S) //loginstat_faceimg_S
                if (loginstat_faceimg != nil) {
                    头像图标.setImage(loginstat_faceimg, forState: UIControlState.Normal)
                }
            }
            
            //图片文件名：默认设置按钮图片
            let loginstat_settbtn_S:String = 全局_皮肤设置.objectForKey("loginstat_settbtn") as! String
            NSLog("[Skin]loginstat_settbtn_S=%@",loginstat_settbtn_S)
            if (loginstat_faceimg_S != "null") {
                let loginstat_settbtn:UIImage? = 主题参数转对象.image(loginstat_settbtn_S) //loginstat_settbtn_S
                if (loginstat_settbtn != nil) {
                    设置图标.setImage(loginstat_settbtn, forState: UIControlState.Normal)
                }
            }
            
            //RGBA色值：前景色
            let loginstat_tintColor_S:String = 全局_皮肤设置.objectForKey("loginstat_tintColor") as! String
            NSLog("[Skin]loginstat_tintColor_S=%@",loginstat_tintColor_S)
            if (loginstat_tintColor_S != "null") {
                let loginstat_tintColor:UIColor? = 主题参数转对象.color(loginstat_tintColor_S) //loginstat_tintColor_S
                if (loginstat_tintColor != nil) {
                    设置图标.tintColor = loginstat_tintColor
                    头像图标.tintColor = loginstat_tintColor
                    主标题.textColor = loginstat_tintColor
                    副标题.textColor = loginstat_tintColor
                }
            }
            
            
        }
    }
    
    func 点击() {
        let 用户已登录:Bool = false //此处还没写
        if (用户已登录) {
            let 用户登录菜单:UIAlertView = UIAlertView(title: "<用户名>", message: "", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: lang.uage("立即同步"),lang.uage("上传覆盖网络"),lang.uage("下载覆盖本地"),lang.uage("修改密码"),lang.uage("切换用户/登出")) //此处功能未确定暂不翻译
            用户登录菜单.show()
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("重新启动通知", object: nil)
        }
    }
}
