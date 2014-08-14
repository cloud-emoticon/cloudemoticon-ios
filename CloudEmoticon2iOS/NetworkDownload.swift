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
    let className:NSString = "[网络操作器]"
    var connData: NSMutableData!
    var nowURLarr:NSArray = []
    
//    init(connData: NSMutableData)
//    {
//        self.connData = NSMutableData.data();
//    }
    
    
    //开始连接
//    func startConnection()
//    {
//    }
    
    //开始异步连接
    func startAsyConnection(urlarr:NSArray)
    {
        NSLog("%@开始准备下载...",className)
        var urla: NSURL
//        p_nowurl = "http://www.heartunlock.com/ce.xml"
        urla = NSURL.URLWithString(urlarr.objectAtIndex(0) as NSString)
        nowURLarr = urlarr
        //http://www.heartunlock.com/ce.xml
        //https://gist.githubusercontent.com/KTachibanaM/f1700cbe613e3a9e7231/raw/f434b82f8185fbcea847eae6a6da689637be2d20/KT.json
        //https://dl.dropboxusercontent.com/u/73985358/Emoji/_KT_Current.xml
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
        NSLog("%@服务器已响应，正在下载...",className)
    }
    //接收数据
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!)
    {
        print("...")
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
        NSLog("%@数据接收完毕。",className)
        if (self.connData != nil)
        {
            var str:NSString
            str = NSString(data: self.connData, encoding: NSUTF8StringEncoding)
//            println(str)
            NSNotificationCenter.defaultCenter().postNotificationName("loaddataok", object: nowURLarr)
//            var err:NSError = NSError()
            
            var scoder:SwitchCoder = SwitchCoder()
            scoder.startScoder(self.connData, URLarr: nowURLarr)
//            var coder:SwitchCoder.Coder = scoder.scoder(self.connData)
            
//            var xml = XMLReader()
//            xml.data2xml(self.connData)
            
            
//            var reqdic:NSDictionary = xml.dictionaryForXMLData(self.connData, errorPointer: err)
//            println(reqdic)
            
        } else {
            println("NULL!!!")
        }
    }
    
    //接受失败
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!)
    {
        NSLog("%@网络接收失败！",className)
    }
}
