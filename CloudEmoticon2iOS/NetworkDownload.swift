//
//  NetworkDownload.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/11/22.
//  Copyright © 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//
//  使用 YashiNetworkDownload v3 模拟 YashiNetworkDownload v1 的接口

import UIKit

class NetworkDownload: NSObject, YashiNetworkKitDelegate {
    
    //var 接收到的数据: NSMutableData!
    var 当前URL识别数组:NSArray = []
    let 网络类:YashiNetworkKit = YashiNetworkKit()
    
    func 开始异步连接(_ URL识别数组:NSArray) {
        NSLog("%@开始准备下载...")
        let 当前请求网址:URL = URL(string: URL识别数组.object(at: 0) as! String)!
        当前URL识别数组 = URL识别数组
        网络类.传输模式 = 传输模式为.加载数据
        网络类.网址 = 当前请求网址 as AnyObject?
        网络类.请求模式 = 请求模式为.显式
        网络类.代理 = self
        网络类.开始请求()
    }
    
    func YashiNetworkKit实时汇报进度(_ 已下载字节数:Int64, 总计字节数:Int64, 当前进度百分比:Int64) {
        let 信息字符串:NSString = NSString(format: "%d%@/%d%@，%f%%",已下载字节数,lang.uage("字节"),总计字节数,lang.uage("字节"),当前进度百分比)
        NSLog("[刷新颜文字数据]正在下载%@。",信息字符串)
    }
    func YashiNetworkKit下载结束(_ 当前下载类:YashiNetworkKit) {
        
    }
    func YashiNetworkKit网络操作结束(_ 当前下载类:YashiNetworkKit, 发生错误:NSError?) {
        
    }
    func YashiNetworkKit请求结果(_ 当前下载类:YashiNetworkKit, 返回的网址:URL?, 返回的数据:Data?, 返回的文件:String?, 返回的状态码:URLResponse?, 错误信息:NSError?) {
        if (错误信息 != nil) {
            NSLog("[刷新颜文字数据]下载失败！%@",错误信息!.localizedDescription)
            失败处理()
        } else {
            NSLog("[刷新颜文字数据]下载成功。")
            if (当前下载类.数据 != nil) {
                let 数据内容:NSString? = NSString(data: 当前下载类.数据! as Data, encoding: String.Encoding.utf8.rawValue)
                if (数据内容 != nil) {
                    let 解析选择:SwitchCoder = SwitchCoder()
                    解析选择.选择解析器(当前下载类.数据!, URL识别数组: 当前URL识别数组)
                } else {
                    NSLog("[刷新颜文字数据]内容错误！")
                    失败处理()
                }
            } else {
                NSLog("[刷新颜文字数据]没有数据！")
                失败处理()
            }
        }
    }
    func 失败处理() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "网络失败"), object: 当前URL识别数组)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "显示等待提示框通知"), object: NSNumber(value: false as Bool))
        let 下载失败提示:UIAlertView = UIAlertView(title: lang.uage("下载失败"), message: lang.uage("请检查网络后重试"), delegate: nil, cancelButtonTitle: lang.uage("取消"))
        下载失败提示.show()
    }
}
