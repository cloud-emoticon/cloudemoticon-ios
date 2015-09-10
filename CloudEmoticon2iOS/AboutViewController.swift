//
//  AboutViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫喵 on 14/8/26.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController,NSURLConnectionDelegate {

    @IBOutlet weak var 内容: UILabel!
    @IBOutlet weak var 载入等待: UIActivityIndicatorView!
    var 接收到的数据: NSMutableData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = lang.uage("关于")
        内容.text = "Loading..."
        载入等待.startAnimating()
        开始异步连接()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func 开始异步连接()
    {
        let 当前请求网址:NSURL = NSURL(string: "http://yoooooooooo.com/api/CloudEmoticon/CloudEmoticon2-Copyright.txt")!
        var URL请求: NSURLRequest
        URL请求 = NSURLRequest(URL: 当前请求网址, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        //        request.URL = urla
        //        request.HTTPMethod = "POST"
        NSURLConnection(request: URL请求, delegate: self)
    }
    //服务器响应
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!)
    {
        
    }
    //接收数据
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!)
    {
        if (self.接收到的数据 == nil)
        {
            self.接收到的数据 = NSMutableData()
        }
        self.接收到的数据?.appendData(data)
    }
    //成功接收
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        if (self.接收到的数据 != nil) {
            let 数据:NSString? = NSString(data: self.接收到的数据!, encoding: NSUTF8StringEncoding)
            if (数据 != nil) {
                内容.text = 数据 as? String
            } else {
                接收失败()
            }
        } else {
            接收失败()
        }
        载入等待.stopAnimating()
    }
    //接受失败
    func connection(connection: NSURLConnection, didFailWithError error: NSError)
    {
        接收失败()
    }
    func 接收失败()
    {
        内容.text = NSString(format: "%@\n\n%@", lang.uage("软件全称"),lang.uage("详细信息读取失败")) as String
        载入等待.stopAnimating()
    }
}
