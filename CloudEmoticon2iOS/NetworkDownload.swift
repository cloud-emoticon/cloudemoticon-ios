//
//  NetworkDownload.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/5.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit
import Foundation
class NetworkDownload: NSObject, NSURLConnectionDelegate, NSObjectProtocol {
    
    var connData: NSMutableData
    
    init(connData: NSMutableData)
    {
        self.connData = NSMutableData.data();
    }
    
    
    //开始连接
//    func startConnection()
//    {
//    }
    
    //开始异步连接
    func startAsyConnection()
    {
        var urla: NSURL
        urla = NSURL.URLWithString("http://www.heartunlock.com/ce.xml")
        var request: NSURLRequest
        request = NSURLRequest(URL:urla)
//        request.URL = urla
//        request.HTTPMethod = "POST"
        NSURLConnection.connectionWithRequest(request, delegate: self)
    }
    
//    func connection(connection: NSURLConnection!, willSendRequest request: NSURLRequest!, redirectResponse response: NSURLResponse!) -> NSURLRequest!
//    {
//        print("1")
//        return request
//    }
    
    //成功序列：服务器响应、接收数据、缓存、成功接收
    //失败序列：
    
    //服务器响应
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!)
    {
        print("2")
    }
    //接收数据
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!)
    {
        print("3")
        if (self.connData == nil)
        {
            self.connData = NSMutableData.data();
        }
        self.connData.appendData(data)
        //println(data)
    }
//    func connection(connection: NSURLConnection!, needNewBodyStream request: NSURLRequest!) -> NSInputStream!
//    {
//        print("4")
//        return NSInputStream.alloc();
//    }
//    func connection(connection: NSURLConnection!, didSendBodyData bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int)
//    {
//        print("5")
//    }
//    //缓存
//    func connection(connection: NSURLConnection!, willCacheResponse cachedResponse: NSCachedURLResponse!) -> NSCachedURLResponse!
//    {
//        print("6")
//        return NSCachedURLResponse.alloc()
//    }

    //成功接收
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        print("7")
        if (self.connData != nil)
        {
            var str:NSString
            str = NSString(data: self.connData, encoding: NSUTF8StringEncoding)
            println(str)
        } else {
            println("NULL!!!")
        }
    }
    
    //接受失败
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!)
    {
        print("ERR")
    }
}
