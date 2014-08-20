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
            //println(urlStr) //cloudemoticon://cxchope.sites.my-card.in/ce.xml
            let urlarr:NSArray = urlStr.componentsSeparatedByString(":")
            var schemeStr:NSString = "http:"
            if (url.scheme == "cloudemoticons") {
                schemeStr = "https:"
            }
            let address:NSString = urlarr.objectAtIndex(1) as NSString
            let downloadURL:NSString = NSString(format: "%@%@", schemeStr, address)
            let nettoInt:Int = NetDownloadTo.SOURCEMANAGER.toRaw()
            
            let downloadArr:NSMutableArray = [downloadURL,NSNumber(integer: nettoInt)]
            NSNotificationCenter.defaultCenter().postNotificationName("loadwebdata", object: downloadArr)
            
            return true
        }

        return false
    }
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        let documentDirectory:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryAddress:NSString = documentDirectory[0] as NSString
        NSLog("[核心]云颜文字启动，启动文件夹：%@", documentDirectoryAddress)
        
        var statBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.statBar = CustomStatusBar(frame: CGRectMake(statBarFrame.width * 0.6, 0, statBarFrame.width * 0.4, statBarFrame.height))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadwebdataf:", name: "loadwebdata", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadwebdataokf:", name: "loaddataok", object: nil)
        
        //TEST
//        let nettoInt:Int = NetDownloadTo.CLOUDEMOTICON.toRaw()
//        let downloadURL:NSString = "http://cxchope.sites.my-card.in/ce.xml"
//        let downloadArr:NSMutableArray = [downloadURL,NSNumber(integer: nettoInt)]
//        NSNotificationCenter.defaultCenter().postNotificationName("loadwebdata", object: downloadArr)
        //TEST
        
        
        return true
    }
    
    func loadwebdataf(notification:NSNotification)
    {
        statBar.showMsg("正在加载源...")
        let urlArr:NSArray = notification.object as NSArray
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        filemgr.nowURLarr = urlArr
        
        let alldata:NSArray? = filemgr.LoadArrayFromFile(FileManager.saveMode.NETWORK)

        if( (alldata != nil))
        {
            var newdwn = NetworkDownload.alloc()
            newdwn.开始异步连接(urlArr)
        } else {
            p_emodata = alldata!
        }
        NSNotificationCenter.defaultCenter().postNotificationName("loaddataok2", object: urlArr)
        statBar.hideMsg()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func loadwebdataokf(notification:NSNotification)
    {
        let 网址和目标位置序号数组:NSArray = notification.object as NSArray
        let 网址:NSString = 网址和目标位置序号数组.objectAtIndex(0) as NSString
        let 目标位置序号对象:NSNumber = 网址和目标位置序号数组.objectAtIndex(1) as NSNumber
        let 目标位置序号:Int = 目标位置序号对象.integerValue
        let 当前下载目标位置:NetDownloadTo = NetDownloadTo.fromRaw(目标位置序号)!
        let 请求的数据数组:NSArray? = filemgr.LoadArrayFromFile(FileManager.saveMode.NETWORK)
        if ((请求的数据数组) != nil) {
            if (当前下载目标位置 == NetDownloadTo.CLOUDEMOTICON) {
                p_emodata = 请求的数据数组!
            } else if (当前下载目标位置 == NetDownloadTo.SOURCEMANAGER) {
//                println(请求的数据数组)
            }
        }
        
        statBar.hideMsg()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        var err:NSError = NSError()
        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CE2NCWidget")!
        
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

