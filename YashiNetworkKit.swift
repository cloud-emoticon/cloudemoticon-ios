//
//  YashiNetworkKit.swift
//  YashiNetworkKit 3.0

//  1.0 Created by 神楽坂雅詩 on 2012/8/8.
//  2.0 Created by 神楽坂雅詩 on 2015/4/19.
//  3.0 Created by 神楽坂雅詩 on 2015/9/24.
//  Copyright (c) 2012-2015 KagurazakaYashi/TerenceChen . All rights reserved.
//
//  依赖：MD5.h/MD5.m
//  输入：init方法
//  输出：代理方法调用
//

import UIKit

enum 会话模式为:Int16 {
    case 默认 = 0
    //默认会话模式（default）：工作模式类似于原来的NSURLConnection，使用的是基于磁盘缓存的持久化策略，使用用户keychain中保存的证书进行认证授权。
    case 瞬时 = 1
    //瞬时会话模式（ephemeral）：该模式不使用磁盘保存任何数据。所有和会话相关的caches，证书，cookies等都被保存在RAM中，因此当程序使会话无效，这些缓存的数据就会被自动清空。
    case 后台 = 2
    //后台会话模式（background）：该模式在后台完成上传和下载，在创建Configuration对象的时候需要提供一个NSString类型的ID用于标识完成工作的后台会话。
}
enum 传输模式为:Int16 {
    case 加载数据 = 0
    case 上载文件 = 1
    case 下载文件 = 2
}
enum 请求模式为:Int16 {
    case 显式 = 0
    //GET - 从指定的资源请求数据。
    case 隐式 = 1
    //POST - 向指定的资源提交要被处理的数据。
}

class YashiNetworkKit: NSObject {
    //可以修改的属性
    var 会话模式:会话模式为 = 会话模式为.默认
    var 请求模式:请求模式为 = 请求模式为.显式
    var 传输模式:传输模式为 = 传输模式为.加载数据
    var 网址:String = ""
    var 数据:NSData? = nil //上传操作前输入，下载操作时输出
    var 下载到文件:String = "" //下载到本地文件的绝对路径
    //不可修改的属性
    
    //方法
    func 开始请求() {
        //菊花.startAnimating()
        let 网址串:NSURL = NSURL(string: 网址)!
        let 网络请求:NSURLRequest = NSURLRequest(URL: 网址串)
        let 网络会话:NSURLSession = NSURLSession.sharedSession()
        if (传输模式 == 传输模式为.加载数据) {
            let 网络会话任务加载数据:NSURLSessionDataTask = 网络会话.dataTaskWithRequest(网络请求) { (返回的数据:NSData?, 返回的状态码:NSURLResponse?, 错误信息:NSError?) -> Void in
                self.请求结果(返回的数据, 返回的文件: nil, 返回的状态码: 返回的状态码, 错误信息: 错误信息)
            }
            网络会话任务加载数据.resume() //启动
        } else if (传输模式 == 传输模式为.上载文件) {
            let 网络会话任务上载数据:NSURLSessionUploadTask = 网络会话.uploadTaskWithRequest(网络请求, fromData: 数据, completionHandler: { (返回的数据:NSData?, 返回的状态码:NSURLResponse?, 错误信息:NSError?) -> Void in
                self.请求结果(返回的数据, 返回的文件: nil, 返回的状态码: 返回的状态码, 错误信息: 错误信息)
            })
            网络会话任务上载数据.resume() //启动
        } else if (传输模式 == 传输模式为.下载文件) {
            let 网络会话任务下载数据:NSURLSessionDownloadTask = 网络会话.downloadTaskWithRequest(网络请求, completionHandler: { (临时文件URL:NSURL?, 返回的状态码:NSURLResponse?, 错误信息:NSError?) -> Void in
                if (临时文件URL != nil) {
                    NSLog("临时文件存放位置：%@", 临时文件URL!);
                    let 文件管理器:NSFileManager = NSFileManager.defaultManager()
                    let 下载到 = self.下载到文件
                    if (文件管理器.fileExistsAtPath(下载到)) {
                        do {
                            try 文件管理器.removeItemAtPath(下载到)
                        } catch _ {
                            NSLog("[YashiNetworkKit]删除已存在的目标文件失败。")
                        }
                    }
                    do {
                        try 文件管理器.moveItemAtPath(临时文件URL!.absoluteString, toPath: 下载到)
                    } catch _ {
                        NSLog("[YashiNetworkKit]将临时文件夹中的文件%@移动到%@失败。",临时文件URL!.absoluteString,下载到)
                    }
                    
                }
            })
            网络会话任务下载数据.resume() //启动
        }
        
    }
    
    func 请求结果(返回的数据:NSData?, 返回的文件:String?, 返回的状态码:NSURLResponse?, 错误信息:NSError?) {
        if (返回的状态码 != nil) {
            let 状态对象:NSHTTPURLResponse = 返回的状态码! as! NSHTTPURLResponse
            let 状态码:Int = 状态对象.statusCode
            NSLog("%d", 状态码)
        }
        if (返回的数据 != nil) {
            //let 在浏览器中打开示例:UIWebView = UIWebView()
            //在浏览器中打开示例.loadData(返回的数据!, MIMEType: "text/html", textEncodingName: "utf-8", baseURL: NSURL())
        }
        if (返回的文件 != nil) {
            
        }
        //菊花.startAnimating()
    }
}
