//
//  YashiNetworkDownload.swift
//  雅诗独立类库：网络下载工具 v2.2 Swift中文版 (Xcode6.3/Swift1) | beta
//
//  使用官方库实现网络交互，实时显示进度和数据量，请求参数，断点续传，异步下载，大文件下载，自定义超时和缓存。
//
//  Created by 神楽坂雅詩 on 2012/8/8.
//  Created by 神楽坂雅詩 on 2015/4/19.
//  Copyright (c) 2012-2015 KagurazakaYashi/TerenceChen . All rights reserved.
//
//  依赖：MD5.h/MD5.m
//  输入：init方法
//  输出：代理方法调用
//

import UIKit

enum NetworkHTTPMethod:Int {
    case GET = 0
    case POST = 1
}

protocol YashiDownloadDelegate{
    //下载完成后会返回self，可以通过查阅属性来获得需要的下载结果信息。
    func 网络下载收到数据(网络下载器对象:YashiNetworkDownload)
    func 网络下载数据接收完毕(网络下载器对象:YashiNetworkDownload)
    func 网络下载遇到错误(网络下载器对象:YashiNetworkDownload)
}

class YashiNetworkDownload: NSObject, NSURLConnectionDelegate {
    let 关键字:NSString = "Default" //可自定义该常量
    let 临时文件扩展名:NSString = "tmp" //可自定义该常量
    var 信息字符串:NSString = NSString() //搭配代理方法可实时获得下载进度
    var 信息数组:NSMutableArray = NSMutableArray() //同上
    var 网络错误描述:NSString = NSString() //失败后从该属性获得错误描述
    var 下载地址:String = String()
    var 请求参数:NSData? = nil
    var 超时时间:NSTimeInterval = 10.0
    var 系统缓存模式:NSURLRequestCachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
    var 代理:YashiDownloadDelegate?
    var 下载的数据:NSMutableData = NSMutableData()
    var 临时文件路径:String = String()
    var 配置文件地址:NSString = NSString() //（未制作）
    var 文件流:NSOutputStream?
    var 网络连接对象:NSURLConnection = NSURLConnection()
    var 总文件大小:Int64 = 0
    var 当前文件大小:Int64 = 0
    var 开始时已下载文件大小:Int64 = 0
    var 开始任务时间戳:NSTimeInterval = 0
    var 网络请求模式:NetworkHTTPMethod = NetworkHTTPMethod.GET
    var 要用文件缓存:Bool = false
    var 要异步:Bool = false
    var 要断点续传:Bool = false
    var tag值:UInt = 0
    var 处于下载中:Bool = false
    let 文件管理器:NSFileManager = NSFileManager.defaultManager()
    
    //步骤1：使用此方法初始化
    //异步：在单独的线程中进行下载操作。（需要代理）
    //文件缓存：文件会下载到存储器而不是内存，适用于大文件。（需要异步）
    //断点续传：如果文件下载到一半中止，尝试继续下载。（如果服务器支持，需要文件缓存）
    //系统缓存模式：参考NSURLRequestCachePolicy，输入nil则默认为ReloadIgnoringLocalCacheData
    init(输入下载地址:String,输入网络请求模式:NetworkHTTPMethod,输入请求参数:NSDictionary?,是否要用文件缓存:Bool,是否要异步:Bool,是否要断点续传:Bool,输入超时时间:NSTimeInterval,输入系统缓存模式:NSURLRequestCachePolicy?,输入代理:YashiDownloadDelegate?) {
        super.init()
        处于下载中 = false
        if (是否要异步 == false && 是否要用文件缓存 == true) {
            NSLog("[NetWork Class]设置有冲突: 异步:OFF & 用文件缓存:ON")
            要用文件缓存 = false
        } else {
            要用文件缓存 = 是否要用文件缓存
        }
        if (是否要异步 == false && 是否要断点续传 == true) {
            NSLog("[NetWork Class]设置有冲突: 异步:OFF & 断点续传:ON")
            要断点续传 = false
        } else {
            要断点续传 = 是否要断点续传
        }
        if (输入系统缓存模式 != nil) {
            系统缓存模式 = 输入系统缓存模式!
        }
        下载地址 = 输入下载地址
        网络请求模式 = 输入网络请求模式
        要异步 = 是否要异步
        超时时间 = 输入超时时间
        代理 = 输入代理
        请求参数 = nil
        if (输入请求参数 != nil) {
            let 请求参数Key列表:NSArray = 输入请求参数!.allKeys
            let 请求体:NSMutableString = NSMutableString()
            for (var i = 0; i < 请求参数Key列表.count; i++) {
                let 当前参数key:String = 请求参数Key列表.objectAtIndex(i) as! String
                let 当前参数值:String = 输入请求参数?.objectForKey(当前参数key) as! String
                if (i == 0) {
                    请求体.appendString("&")
                }
                let 当前参数字符串:String = String(format: "%@=%@", 当前参数key,当前参数值)
                请求体.appendString(当前参数字符串)
            }
            请求参数 = 请求体.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        }
        临时文件路径 = 从网址生成临时文件路径和名称(输入下载地址, 文件扩展名: 临时文件扩展名) as String
        NSLog("[NetWork Class]缓存文件路径: \(临时文件路径)")
        if (要用文件缓存) {
            if (要断点续传) {
                if (文件管理器.fileExistsAtPath(临时文件路径)) {
                    开始时已下载文件大小 = 计算文件大小(临时文件路径)
                } else {
                    文件管理器.createFileAtPath(临时文件路径, contents: nil, attributes: nil)
                    开始时已下载文件大小 = 0
                }
            } else {
                if (文件管理器.fileExistsAtPath(临时文件路径)) {
                    do {
                        try 文件管理器.removeItemAtPath(临时文件路径)
                    } catch _ {
                    }
                    开始时已下载文件大小 = 0
                }
            }
            文件流 = NSOutputStream(toFileAtPath: 临时文件路径, append: true)!
            文件流!.open()
        } else {
            下载的数据 = NSMutableData()
        }
        NSLog("[NetWork Class]初始化。")
    }
    
    //步骤2：执行此方法启动
    func 启动连接() {
        处于下载中 = true
        if (要异步) {
            启动异步连接()
        } else {
            启动同步连接()
        }
    }
    
    //步骤3A：成功接收，若使用文件缓存请在接收后利用并删除临时文件
    //内存缓存请读取[NSData下载的数据]，文件缓存请读取[NSString临时文件路径]
    func connectionDidFinishLoading(connection: NSURLConnection) {
        NSLog("[NetWork Class]成功接收了数据。");
        中止连接()
        if (要用文件缓存) {
            if (要断点续传 && 文件管理器.fileExistsAtPath(临时文件路径)) {
                NSLog("[NetWork Class]已下载\(计算文件大小(临时文件路径))字节数据。")
            }
        }
        if (代理 != nil) {
            代理!.网络下载数据接收完毕(self)
        }
    }
    
    //步骤3B：接收过程中出错，请查看网络错误描述属性
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        网络错误描述 = error.localizedDescription
        NSLog("[NetWork Class]发生错误: \(网络错误描述)")
        中止连接()
        处于下载中 = false
        if (代理 != nil) {
            代理!.网络下载遇到错误(self)
        }
    }
    
    //可选：你可以用此方法手工清除缓存文件
    func 删除一个缓存文件(源网址:String) {
        let 要删除的文件路径:String = 从网址生成临时文件路径和名称(源网址, 文件扩展名: 临时文件扩展名) as String
        if (文件管理器.fileExistsAtPath(要删除的文件路径)) {
            do {
                try 文件管理器.removeItemAtPath(要删除的文件路径)
            } catch _ {
            }
        }
    }
    func 删除当前缓存文件() {
        if (文件管理器.fileExistsAtPath(临时文件路径)) {
            do {
                try 文件管理器.removeItemAtPath(临时文件路径)
            } catch _ {
            }
        }
    }
    func 清除所有缓存文件() {
        let 缓存文件夹路径:String = 获得缓存文件夹路径() as String
        if (文件管理器.fileExistsAtPath(缓存文件夹路径)) {
            do {
                try 文件管理器.removeItemAtPath(缓存文件夹路径)
            } catch _ {
            }
        }
    }
    
    //可选：你可以用此方法中止连接（不建议中止连接可能导致意外错误）
    func 中止连接() {
        网络连接对象.cancel()
        //下载的数据 = NSMutableData()
        文件流!.close()
        文件流 = nil
    }
    
    //============
    
    func 启动同步连接() {
        let 网址:NSURL = NSURL(string: 下载地址)!
        let 网络请求:NSMutableURLRequest = NSMutableURLRequest(URL: 网址, cachePolicy: 系统缓存模式, timeoutInterval: 超时时间)
        if (请求参数 != nil) {
            网络请求.HTTPBody = 请求参数
        }
        网络请求.HTTPMethod = 网络请求描述(网络请求模式)
        NSLog("[NetWork Class]准备下载: \(网络请求)");
        var 网络响应:NSURLResponse? = nil
        var 网络错误:NSError? = nil
        var 收到数据: NSData?
        do {
            收到数据 = try NSURLConnection.sendSynchronousRequest(网络请求, returningResponse: &网络响应)
        } catch let error as NSError {
            网络错误 = error
            收到数据 = nil
        }
        if (网络错误 != nil) {
            //[self connection:nil didFailWithError:error];
        } else {
            下载的数据 = NSMutableData(data: 收到数据!)
        }
    }
    
    func 启动异步连接() {
        let 网址:NSURL = NSURL(string: 下载地址)!
        let 网络请求:NSMutableURLRequest = NSMutableURLRequest(URL: 网址, cachePolicy: 系统缓存模式, timeoutInterval: 超时时间)
        if (请求参数 != nil) {
            网络请求.HTTPBody = 请求参数
        }
        if (要断点续传 && 开始时已下载文件大小 > 0) {
            NSLog("[NetWork Class]从该字节开始断点续传: \(开始时已下载文件大小)");
            let 断点续传网络参数:String = "bytes=\(开始时已下载文件大小)-"
            网络请求.addValue(断点续传网络参数, forHTTPHeaderField: "Range")
        }
        网络请求.HTTPMethod = 网络请求描述(网络请求模式)
        NSLog("[NetWork Class]准备下载: \(网络请求)");
        网络连接对象 = NSURLConnection(request: 网络请求, delegate: self)!
    }
    
    //服务器响应
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        总文件大小 = response.expectedContentLength
        当前文件大小 = 0
        NSLog("[NetWork Class]已连接，准备下载\(总文件大小)字节文件。");
        if (要断点续传) {
            总文件大小 += 开始时已下载文件大小
            当前文件大小 += 开始时已下载文件大小
            NSLog("[NetWork Class]文件实际大小\(总文件大小)字节，其中本地已经下载\(开始时已下载文件大小)字节。");
        }
        配置文件地址 = 从网址生成临时文件路径和名称(下载地址, 文件扩展名: "inf")
        开始任务时间戳 = NSDate().timeIntervalSince1970
    }
    
    //收到数据
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        let 接收到的数据长度:Int = data.length
        当前文件大小 += 接收到的数据长度
        let 当前时间戳:NSTimeInterval = NSDate().timeIntervalSince1970
        let 当前文件大小描述:NSString = NSString(format: "%0.1fKB",当前文件大小/1024)
        let 总文件大小描述:NSString = NSString(format: "%0.1fKB",总文件大小/1024)
        var 进度描述:NSString = "100.0%"
        var 进度数值:Float = 0
        let 当前文件大小F:Float = NSNumber(longLong: 当前文件大小).floatValue
        let 总文件大小F:Float = NSNumber(longLong: 总文件大小).floatValue
        if (总文件大小 != 0) {
            进度数值 = 当前文件大小F/总文件大小F
            进度描述 = NSString(format: "%3.1f%%",进度数值 * 100.0)
        }
        let 已用时间:NSTimeInterval = 开始任务时间戳 - 当前时间戳
        var 已用时间F:Float = NSNumber(double: 已用时间).floatValue
        if (已用时间F == 0) {
            已用时间F = 1
        }
        let 下载速度数值:Float = 总文件大小F / 已用时间F / 1024.0
        let 下载速度描述:NSString = NSString(format: "%0.1fKB/s",下载速度数值)
        信息字符串 = NSString(format: "%@/%@(%@):%@",当前文件大小描述,总文件大小描述,进度描述,下载速度描述)
        信息数组 = [当前文件大小描述,总文件大小描述,进度描述,下载速度描述]
        if (要用文件缓存) {
            var 全部数据字节 = 0
            data.enumerateByteRangesUsingBlock() {
                buffer, range, stop in
                var 当前字节 = UnsafePointer<UInt8>(buffer)
                var 字节写入 = 0
                var 字节差异 = range.length
                while 字节差异 > 0 {
                    字节写入 = self.文件流!.write(当前字节, maxLength: 字节差异)
                    if 字节写入 < 0 {
                        stop.initialize(true)
                        全部数据字节 = -1
                        return
                    }
                    当前字节 += 字节写入
                    字节差异 -= 字节写入
                    全部数据字节 += 字节写入
                }
            }
        } else {
            下载的数据.appendData(data)
        }
        if (代理 != nil) {
            代理!.网络下载收到数据(self)
        }
    }
    
    func 获得缓存文件夹路径() -> NSString {
        let 系统文件夹路径数组:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let 文档文件夹路径:NSString = 系统文件夹路径数组.objectAtIndex(0) as! NSString
        let 缓存文件夹名称:NSString = "YSNetworkCache"
        let 缓存文件夹路径:String = "\(文档文件夹路径)/\(缓存文件夹名称)"
        let 缓存文件夹是否存在:Bool = 文件管理器.fileExistsAtPath(缓存文件夹路径)
        if (缓存文件夹是否存在 == false) {
            do {
                try 文件管理器.createDirectoryAtPath(缓存文件夹路径, withIntermediateDirectories: false, attributes: nil)
            } catch _ {
            }
        }
        return 缓存文件夹路径
    }
    
    func 从网址生成临时文件路径和名称(网址:String,文件扩展名:NSString) -> NSString {
        let 临时文件路径:NSString = "\(获得缓存文件夹路径())/\(md5(网址)).\(文件扩展名)"
        return 临时文件路径
    }
    
    func 计算文件大小(文件路径:String) -> Int64 {
        if (文件管理器.fileExistsAtPath(文件路径)) {
            let 文件信息:NSDictionary = try! 文件管理器.attributesOfItemAtPath(文件路径)
            let 文件大小:NSNumber = 文件信息.objectForKey("NSFileSize") as! NSNumber
            return 文件大小.longLongValue
        }
        return 0
    }
    
    func 网络请求描述(方式:NetworkHTTPMethod) -> String {
        if (方式 == NetworkHTTPMethod.GET) {
            return "GET";
        } else {
            return "POST";
        }
    }
    
    deinit {
        NSLog("[NetWork Class]释放内存。")
    }
}