//
//  AppDelegate.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/7/8.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var statBar: CustomStatusBar!
    var netto:NetDownloadTo = NetDownloadTo.NONE
    let filemgr:FileManager = FileManager()

    func application(application: UIApplication!, openURL url: NSURL!, sourceApplication: String!, annotation: AnyObject!) -> Bool {
        if url.scheme == "emostart" {
            return true
        }
        if (url.scheme == "cloudemoticon" || url.scheme == "cloudemoticons") {
            let urlStr:NSString = url.absoluteString!
            let urlarr:NSArray = urlStr.componentsSeparatedByString(":")
            var schemeStr:NSString = "http:"
            if (url.scheme == "cloudemoticons") {
                schemeStr = "https:"
            }
            let address:NSString = urlarr.objectAtIndex(1) as NSString
            let downloadURL:NSString = NSString(format: "%@%@", schemeStr, address)
            let nettoInt:Int = NetDownloadTo.SOURCEMANAGER.rawValue
            
            let downloadArr:NSMutableArray = [downloadURL,NSNumber(integer: nettoInt)]
//            NSNotificationCenter.defaultCenter().postNotificationName("loadwebdata", object: downloadArr)
            NSNotificationCenter.defaultCenter().postNotificationName("切换到源商店通知", object: downloadArr)
            return true
        }
        return false
    }
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        initSetting()
        NSLog("[核心]云颜文字启动，启动文件夹：%@", documentDirectoryAddress)
        
        var statBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.statBar = CustomStatusBar(frame: CGRectMake(statBarFrame.width * 0.6, 0, statBarFrame.width * 0.4, statBarFrame.height))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadwebdataf:", name: "loadwebdata", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadwebdataokf:", name: "loaddataok", object: nil)
        
        lang.载入语言(lang.当前系统语言())
//        println(lang.系统支持的所有语言())
        println(lang.uage("语言包名称"))
        println(lang.uage("语言包作者"))
        return true
    }
    
    func initSetting()
    {
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let noFirstRun:Bool = defaults.boolForKey("noFirstRun")
        let checkbgo:Float? = defaults.floatForKey("bgopacity")
        if (!noFirstRun) {
            defaults.setBool(false, forKey: "exitaftercopy")
            defaults.setFloat(100, forKey: "adfrequent")
            defaults.setFloat(20, forKey: "bgopacity")
//            defaults.setBool(true, forKey: "noFirstRun")
            defaults.synchronize()
        }
        if(noFirstRun && checkbgo == 0.0)
        {
            defaults.setFloat(0.0, forKey: "bgopacity")
            defaults.synchronize()
        }
    }
    
    func loadwebdataf(notification:NSNotification)
    {
        statBar.showMsg(lang.uage("正在加载源"))
        let 网址和目标位置序号数组:NSArray = notification.object as NSArray
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        全局_网络繁忙 = true
        filemgr.nowURLarr = 网址和目标位置序号数组
        let 目标位置序号对象:NSNumber = 网址和目标位置序号数组.objectAtIndex(1) as NSNumber
        let 目标位置序号:Int = 目标位置序号对象.integerValue
        let 当前下载模式:NetDownloadTo = NetDownloadTo(rawValue: 目标位置序号)!
        var alldata:NSArray? = nil
        if (当前下载模式 != NetDownloadTo.CLOUDEMOTICONONLINE) {
            alldata = filemgr.LoadArrayFromFile(FileManager.saveMode.NETWORK)
        }
        if(alldata == nil)
        {
            var newdwn = NetworkDownload()
            newdwn.开始异步连接(网址和目标位置序号数组)
        } else {
            p_emodata = alldata!
        }
        NSNotificationCenter.defaultCenter().postNotificationName("loaddataok2", object: 网址和目标位置序号数组)
        statBar.hideMsg()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        全局_网络繁忙 = false
    }
    
    func loadwebdataokf(notification:NSNotification)
    {
        let 网址和目标位置序号数组:NSArray = notification.object as NSArray
        let 网址:NSString = 网址和目标位置序号数组.objectAtIndex(0) as NSString
        let 目标位置序号对象:NSNumber = 网址和目标位置序号数组.objectAtIndex(1) as NSNumber
        let 目标位置序号:Int = 目标位置序号对象.integerValue
        let 当前下载目标位置:NetDownloadTo = NetDownloadTo(rawValue: 目标位置序号)!
        let 请求的数据数组:NSArray? = filemgr.LoadArrayFromFile(FileManager.saveMode.NETWORK)
        if (请求的数据数组 != nil) {
            if (当前下载目标位置 == NetDownloadTo.CLOUDEMOTICON || 当前下载目标位置 == NetDownloadTo.CLOUDEMOTICONONLINE) {
                p_emodata = 请求的数据数组!
//            } else if (当前下载目标位置 == NetDownloadTo.SOURCEMANAGER) {
//
            }
        }
        
        statBar.hideMsg()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        全局_网络繁忙 = false
        
//        var err:NSError = NSError()
//        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CE2Keyboard")!
        
//        let documentDirectory:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let documentDirectoryAddress:NSString = documentDirectory[0] as NSString
//        let dicstr:NSString = NSString.localizedStringWithFormat("%@/",documentDirectoryAddress)
//        containerURL = containerURL.URLByAppendingPathComponent(dicstr)
//        let value:NSArray = p_emodata
        
        //http://www.cocoachina.com/applenews/devnews/2014/0627/8960.html
        
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //p_emodata
        
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

