//
//  NetworkDownload.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/5.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

//这个类已经过时并弃用，代码仅作为纪念。

/*

import UIKit
import Foundation
class NetworkDownload: NSObject, NSURLConnectionDelegate, NSObjectProtocol {
    let 类名称:NSString = "[网络操作器]"
    var 接收到的数据: NSMutableData!
    var 当前URL识别数组:NSArray = []
    
    func 开始异步连接(URL识别数组:NSArray)
    {
        NSLog("%@开始准备下载...",类名称)
        let 当前请求网址:NSURL = NSURL(string: URL识别数组.objectAtIndex(0) as! String)!
        当前URL识别数组 = URL识别数组
        var URL请求: NSURLRequest
        URL请求 = NSURLRequest(URL: 当前请求网址, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
//        request.URL = urla
//        request.HTTPMethod = "POST"
        NSURLConnection(request: URL请求, delegate: self)
    }

    
    //服务器响应
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!)
    {
        NSLog("%@服务器已响应，正在下载...",类名称)
    }
    //接收数据
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!)
    {
        NSLog("%@数据接收中...",类名称)
        if (self.接收到的数据 == nil)
        {
            self.接收到的数据 = NSMutableData()
        }
        self.接收到的数据.appendData(data)

    }

    //成功接收
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        NSLog("%@数据接收完毕。",类名称)
        if (self.接收到的数据 != nil)
        {
//            var 数据:NSString? = NSString(data: self.接收到的数据, encoding: NSUTF8StringEncoding)
//            if (数据 != nil) {
                let 解析选择:SwitchCoder = SwitchCoder()
                解析选择.选择解析器(self.接收到的数据, URL识别数组: 当前URL识别数组)
//            } else {
//                println("数据NULL!!!")
//            }
        } else {
            print("没有收到数据")
        }
    }
    
    //接受失败
    func connection(connection: NSURLConnection, didFailWithError error: NSError)
    {
        NSLog("%@网络接收失败！",类名称)
        NSNotificationCenter.defaultCenter().postNotificationName("网络失败", object: 当前URL识别数组)
        NSNotificationCenter.defaultCenter().postNotificationName("显示等待提示框通知", object: NSNumber(bool: false))
        let 下载失败提示:UIAlertView = UIAlertView(title: lang.uage("下载失败"), message: lang.uage("请检查网络后重试"), delegate: nil, cancelButtonTitle: lang.uage("取消"))
        下载失败提示.show()
    }
}
*/