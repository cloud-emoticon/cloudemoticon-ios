//
//  YashiNetworkKit.swift
//  雅诗独立类库：网络下载工具 v3.0 Swift中文版 (Xcode7.1/Swift2) | 开发版

//  1.0 Created by 神楽坂雅詩 on 2012/8/8.
//  2.0 Created by 神楽坂雅詩 on 2015/4/19.
//  3.0 Created by 神楽坂雅詩 on 2015/9/24.
//  Copyright (c) 2012-2015 KagurazakaYashi/TerenceChen . All rights reserved.
//
//  依赖：无需其他类库
//  输入：使用修改属性输入
//  输出：代理方法
//

//import Cocoa
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
    case 下载文件 = 2 //异步
    case 断点续传下载文件 = 3
    case 后台下载文件 = 4 //程序级异步
}
enum 请求模式为:Int16 {
    case 显式 = 0
    //GET - 从指定的资源请求数据。
    case 隐式 = 1
    //POST - 向指定的资源提交要被处理的数据。
}

protocol YashiNetworkKitDelegate {
    func YashiNetworkKit实时汇报进度(已下载字节数:Int64, 总计字节数:Int64, 当前进度百分比:Int64)
    func YashiNetworkKit下载结束(当前下载类:YashiNetworkKit)
    func YashiNetworkKit网络操作结束(当前下载类:YashiNetworkKit, 发生错误:NSError?)
    func YashiNetworkKit请求结果(当前下载类:YashiNetworkKit, 返回的网址:NSURL?, 返回的数据:NSData?, 返回的文件:String?, 返回的状态码:NSURLResponse?, 错误信息:NSError?)
    //func YashiNetworkKit开始断点续传(已下载字节数:Int64, 总计字节数:Int64);
}

class YashiNetworkKit: NSObject,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate {
    //可以修改的属性
    var 会话模式:会话模式为 = 会话模式为.默认
    var 请求模式:请求模式为 = 请求模式为.显式
    var 传输模式:传输模式为 = 传输模式为.加载数据
    var 网址:AnyObject? = nil //支持 NSURL, NSString, String
    var 数据:NSData? = nil //上传操作前输入，下载操作时输出
    var 下载到文件:String? = nil //下载到本地文件的绝对路径,不填写则下载到临时文件
    var 缓存策略:NSURLRequestCachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
    var 超时时间:NSTimeInterval = 60
    var 要提交的参数:NSDictionary? //.php?key=value&key=value
    //外部只读的属性
    var 网络会话:NSURLSession? = nil
    var 网络会话任务加载数据:NSURLSessionDataTask? = nil
    var 网络会话任务上载数据:NSURLSessionUploadTask? = nil
    var 网络会话任务下载数据:NSURLSessionDownloadTask? = nil
    var 续传数据:NSData? = nil
    var 代理:YashiNetworkKitDelegate? = nil
    var 临时文件:String? = nil
    var 错误:NSError? = nil
    var 下载文件总大小:Int64 = 0
    var 下载文件完成大小:Int64 = 0
    var 下载文件完成百分比:Int64 = 0
    //方法
    func 开始请求() {
        //菊花.startAnimating()
        var 网址串:NSURL = NSURL()
        if ((网址 as? NSURL) != nil) {
            网址串 = 网址 as! NSURL
        } else if ((网址 as? NSString) != nil) {
            网址串 = NSURL(string: 网址 as! String)!
        } else if ((网址 as? String) != nil) {
            网址串 = NSURL(string: 网址 as! String)!
        }
        let 网络请求:NSMutableURLRequest = NSMutableURLRequest(URL: 网址串, cachePolicy: 缓存策略, timeoutInterval: 超时时间)
        if (要提交的参数 != nil) {
            let 要提交的字符串:String = 参数字典转换为字符串(要提交的参数!)
            网络请求.HTTPBody = 要提交的字符串.dataUsingEncoding(NSUTF8StringEncoding)
        }
        if (请求模式 == 请求模式为.显式) {
            网络请求.HTTPMethod = "GET";
        } else {
            网络请求.HTTPMethod = "POST";
        }
        if (传输模式 == 传输模式为.加载数据) {
            创建网络会话()
            网络会话任务加载数据 = 网络会话!.dataTaskWithRequest(网络请求)
            { (返回的数据:NSData?, 返回的状态码:NSURLResponse?, 错误信息:NSError?) -> Void in
                self.请求结果(nil, 返回的数据: 返回的数据, 返回的文件: nil, 返回的状态码: 返回的状态码, 错误信息: 错误信息)
            }
            网络会话任务加载数据!.resume() //启动
        }
        else if (传输模式 == 传输模式为.上载文件) {
            创建网络会话()
            if (数据 == nil) {
                NSLog("[YashiNetworkKit]错误：没有要上传的数据。")
            }
            网络会话任务上载数据 = 网络会话!.uploadTaskWithRequest(网络请求, fromData: 数据, completionHandler: { (返回的数据:NSData?, 返回的状态码:NSURLResponse?, 错误信息:NSError?) -> Void in
                self.请求结果(nil, 返回的数据: 返回的数据, 返回的文件: nil, 返回的状态码: 返回的状态码, 错误信息: 错误信息)
            })
            //网络会话任务上载数据 = 网络会话!.uploadTaskWithRequest(网络请求, fromData: 数据!)
            网络会话任务上载数据!.resume() //启动
        }
        else if (传输模式 == 传输模式为.下载文件) {
            if (网络会话任务下载数据 != nil) {
                网络会话任务下载数据 = nil
            }
            if (网络会话 != nil) {
                网络会话 = nil
            }
            创建网络会话()
            网络会话任务下载数据 = 网络会话!.downloadTaskWithRequest(网络请求, completionHandler: { (返回的网址:NSURL?, 返回的状态码:NSURLResponse?, 错误信息:NSError?) -> Void in
                self.将下载的临时文件移动到目标(返回的网址, 返回的状态码: 返回的状态码, 错误信息: 错误信息)
            })
            网络会话任务下载数据!.resume()
        }
        else if (传输模式 == 传输模式为.断点续传下载文件) {
            if (网络会话任务下载数据 != nil) {
                网络会话任务下载数据 = nil
            }
            if (网络会话 == nil) {
                创建网络会话()
            }
            if (数据 != nil) { //继续下载
                网络会话任务下载数据 = 网络会话!.downloadTaskWithResumeData(数据!, completionHandler: { (返回的网址:NSURL?, 返回的状态码:NSURLResponse?, 错误信息:NSError?) -> Void in
                    self.将下载的临时文件移动到目标(返回的网址, 返回的状态码: 返回的状态码, 错误信息: 错误信息)
                })
            } else { //新建下载
                网络会话任务下载数据 = 网络会话!.downloadTaskWithRequest(网络请求, completionHandler: { (返回的网址:NSURL?, 返回的状态码:NSURLResponse?, 错误信息:NSError?) -> Void in
                    self.将下载的临时文件移动到目标(返回的网址, 返回的状态码: 返回的状态码, 错误信息: 错误信息)
                })
            }
            网络会话任务下载数据!.resume()
        }
        else if (传输模式 == 传输模式为.后台下载文件) {
            网络会话任务下载数据 = 网络会话!.downloadTaskWithRequest(网络请求, completionHandler: { (返回的网址:NSURL?, 返回的状态码:NSURLResponse?, 错误信息:NSError?) -> Void in
                self.将下载的临时文件移动到目标(返回的网址, 返回的状态码: 返回的状态码, 错误信息: 错误信息)
            })
            网络会话任务下载数据!.resume()
        }
    }
    
    func 将下载的临时文件移动到目标(返回的网址:NSURL?, 返回的状态码:NSURLResponse?, 错误信息:NSError?) {
        let 文件管理器:NSFileManager = NSFileManager.defaultManager()
        let 临时文件URL:NSURL = 返回的网址!
        let 下载到:String? = self.下载到文件
        if (返回的网址 == nil || 错误信息 != nil) {
            NSLog("[YashiNetworkKit]下载返回了错误。")
            self.请求结果(返回的网址, 返回的数据: nil, 返回的文件: nil, 返回的状态码: 返回的状态码, 错误信息: 错误信息)
            return
        }
        self.临时文件 = 临时文件URL.absoluteString
        if (下载到 != nil) {
            if (文件管理器.fileExistsAtPath(下载到!)) {
                do {
                    try 文件管理器.removeItemAtPath(下载到!)
                } catch let 捕获的错误 as NSError {
                    NSLog("[YashiNetworkKit]删除已存在的目标文件失败。")
                    self.请求结果(返回的网址, 返回的数据: nil, 返回的文件: 下载到, 返回的状态码: 返回的状态码, 错误信息: 捕获的错误)
                    return
                }
            }
            do {
                try 文件管理器.moveItemAtPath(self.临时文件!, toPath: 下载到!)
                self.请求结果(返回的网址, 返回的数据: nil, 返回的文件: 下载到!, 返回的状态码: 返回的状态码, 错误信息: 错误信息)
            } catch let 捕获的错误 as NSError {
                NSLog("[YashiNetworkKit]将临时文件夹中的文件%@移动到%@失败。",临时文件URL.absoluteString,下载到!)
                self.请求结果(返回的网址, 返回的数据: nil, 返回的文件: 下载到!, 返回的状态码: 返回的状态码, 错误信息: 捕获的错误)
            }
        } else {
            self.请求结果(返回的网址, 返回的数据: nil, 返回的文件: self.临时文件, 返回的状态码: 返回的状态码, 错误信息: 错误信息)
        }
    }
    
    func 参数字典转换为字符串(提交的参数:NSDictionary) -> String {
        if (提交的参数.count <= 0) {
            return ""
        }
        let 参数字符串:NSMutableString = NSMutableString()
        let 所有的键:NSArray = (提交的参数.allKeys)
        for (var 当前第几个键:Int = 0; 当前第几个键 < 所有的键.count; 当前第几个键++) {
            let 当前键:NSString = 所有的键.objectAtIndex(当前第几个键) as! NSString
            let 当前值:NSString = (提交的参数.objectForKey(当前键))! as! NSString
            let 要添加的字符串:NSString = NSString(format: "%@=%@&", 当前键,当前值)
            参数字符串.appendString(要添加的字符串 as String)
        }
        return 参数字符串.substringToIndex(参数字符串.length-1)
    }
    
    func 创建网络会话() {
        let 会话配置:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        //会话配置.HTTPAdditionalHeaders = ["key":"val"] //HTTP头
        网络会话 = NSURLSession(configuration: 会话配置, delegate: self, delegateQueue: nil)
        网络会话!.sessionDescription = "Current Session"
    }
    
    func 中止请求() {
        if (网络会话任务加载数据 != nil) {
            网络会话任务加载数据!.cancel()
            网络会话任务加载数据 = nil
        }
        if (网络会话任务上载数据 != nil) {
            网络会话任务上载数据!.cancel()
            网络会话任务上载数据 = nil
        }
        
        if (网络会话任务下载数据 != nil) {
            if (传输模式 == 传输模式为.断点续传下载文件) {
                网络会话任务下载数据?.cancelByProducingResumeData({ (断点数据) -> Void in
                    self.续传数据 = 断点数据
                    self.网络会话任务下载数据 = nil
                })
            } else {
                网络会话任务下载数据!.cancel()
                网络会话任务下载数据 = nil
            }
        }
    }
    //发送下载任务时已完成下载。代表应复制或移动该文件在给定位置到一个新的位置，因为它将删除委托消息返回时。
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        NSLog("[YashiNetworkKit]下载:%@", location)
        if (代理 != nil) {
            代理?.YashiNetworkKit下载结束(self)
        }
    }
    //定期发送通知的代表下载进度。
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        下载文件总大小 = totalBytesExpectedToWrite
        下载文件完成大小 = totalBytesWritten
        下载文件完成百分比 = (Int64(下载文件完成大小) / Int64(下载文件总大小))*100
        NSLog("[YashiNetworkKit]已下载%d/%d(%f%%)...", 下载文件完成大小,下载文件总大小,下载文件完成百分比)
        
        if (代理 != nil) {
            代理?.YashiNetworkKit实时汇报进度(下载文件完成大小, 总计字节数: 下载文件总大小, 当前进度百分比: 下载文件完成百分比)
        }
    }
    //发送时已恢复下载。如果下载失败错误，错误的用户信息的字典包含一个nsurlsessiondownloadtaskresumedata关键，其价值是简历数据。
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        NSLog("[YashiNetworkKit]开始从%lld/%lld字节续传...", fileOffset,expectedTotalBytes)
//        if (代理 != nil) {
//            代理?.YashiNetworkKit开始断点续传(fileOffset, 总计字节数: expectedTotalBytes)
//        }
    }
    //无论成败都调用
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if (error != nil) {
            NSLog("[YashiNetworkKit]网络操作失败，%@",error!.localizedDescription)
        } else {
            NSLog("[YashiNetworkKit]网络操作成功");
        }
        if (代理 != nil) {
            代理?.YashiNetworkKit网络操作结束(self, 发生错误: error)
        }
    }
    
    func 请求结果(返回的网址:NSURL?, 返回的数据:NSData?, 返回的文件:String?, 返回的状态码:NSURLResponse?, 错误信息:NSError?) {
        if (返回的状态码 != nil) {
            let 状态对象:NSHTTPURLResponse = 返回的状态码! as! NSHTTPURLResponse
            let 状态码:Int = 状态对象.statusCode
            NSLog("[YashiNetworkKit]返回状态(%d):", 状态码, NSHTTPURLResponse.localizedStringForStatusCode(状态码))
        }
//        if (返回的数据 != nil) {
//            //let b:UIWebView = UIWebView()
//            //b.loadData(返回的数据!, MIMEType: "text/html", textEncodingName: "utf-8", baseURL: NSURL())
//        }
//        if (返回的文件 != nil) {
//            
//        }
        self.代理?.YashiNetworkKit请求结果(self, 返回的网址:返回的网址, 返回的数据: 返回的数据, 返回的文件: 返回的文件, 返回的状态码: 返回的状态码, 错误信息: 错误信息)
        //返回后应判断是否有错误
    }
}
