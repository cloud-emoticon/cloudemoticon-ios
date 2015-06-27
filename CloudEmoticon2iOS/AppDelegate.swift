//
//  AppDelegate.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/7/8.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var statBar: CustomStatusBar!
    var netto:NetDownloadTo = NetDownloadTo.NONE
    let filemgr:FileManager = FileManager()
    var 应用运行参数:[NSObject : AnyObject]? = nil

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if (url.scheme == "emostart") {
            return true
        } else if (url.scheme == "cloudemoticon" || url.scheme == "cloudemoticons") {
            let urlStr:NSString = url.absoluteString!
            let urlarr:NSArray = urlStr.componentsSeparatedByString(":")
            var schemeStr:NSString = "http:"
            if (url.scheme == "cloudemoticons") {
                schemeStr = "https:"
            }
            let address:NSString = urlarr.objectAtIndex(1) as! NSString
            let downloadURL:NSString = NSString(format: "%@%@", schemeStr, address)
            let nettoInt:Int = NetDownloadTo.SOURCEMANAGER.rawValue
            
            let downloadArr:NSMutableArray = [downloadURL,NSNumber(integer: nettoInt)]
//            NSNotificationCenter.defaultCenter().postNotificationName("loadwebdata", object: downloadArr)
            NSNotificationCenter.defaultCenter().postNotificationName("切换到源商店通知", object: downloadArr)
            return true
        } else if (url.scheme == "cloudemoticonskin") {
            let 要下载的文件路径:NSString = url.absoluteString!
            //切换到主题管理页
            NSNotificationCenter.defaultCenter().postNotificationName("切换到主题管理通知", object: 要下载的文件路径)
        }
        return false
    }
    
    func 第三方SDK初始化(launchOptions: [NSObject : AnyObject]?) {
        //因为涉及第三方SDK的APPKEY，非此项目开发人员请勿使用这些APPKey。
        let 加密设置:CE2CSReader = CE2CSReader()
        加密设置.载入设置()
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        全局_Parse读写.启用本地数据存储()
        // Initialize Parse.
        全局_Parse读写.设置应用程序编号(加密设置.parse_applicationid_o!,
            应用程序秘钥: 加密设置.parse_clientkey_o!)
        // [Optional] Track statistics around application opens.
        全局_Parse读写.跟踪应用程序启动设置(launchOptions)
        // Override point for customization after application launch.
        //友盟统计（SDK尚未引入,但AppKey已导入）
        //MobClick(闭源设置.mobclick_o!,reportPolicy: BATCH,channelId: "Web")
    }
    
    func 应用初始化() {
        NSLog("[AppDelegate]云颜文字启动，启动文件夹：%@", 全局_文档文件夹)
        
        //MARK - 主题
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent //通知栏文字颜色
        //载入皮肤
        let 皮肤管理器:SkinManager = SkinManager()
        let 正在使用皮肤内容:NSDictionary? = 皮肤管理器.获得正在使用皮肤内容()
        //NSLog("[Skin]正在使用皮肤内容=%@",正在使用皮肤内容!)
        if (正在使用皮肤内容 != nil) {
            NSLog("[AppDelegate]主题：载入皮肤设置。")
            全局_皮肤设置 = 正在使用皮肤内容!
        } else {
            NSLog("[AppDelegate]主题：使用默认皮肤。")
            全局_皮肤设置 = NSDictionary()
        }
        var statBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.statBar = CustomStatusBar(frame: CGRectMake(statBarFrame.width * 0.6, 0, statBarFrame.width * 0.4, statBarFrame.height))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadwebdatace:", name: "loadwebdata", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadwebdataokce:", name: "loaddataokce", object: nil)
        
        lang.载入语言(lang.当前系统语言())
        //        println(lang.系统支持的所有语言())
        let 当前语言包名称:String = lang.uage("语言包名称")
        let 当前语言包作者:String = lang.uage("语言包作者")
        NSLog("[AppDelegate]当前语言包名称：%@",当前语言包名称)
        NSLog("[AppDelegate]当前语言包作者：%@",当前语言包作者)
    }
    
    func 界面初始化() {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let IB:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        self.window?.rootViewController = IB.instantiateInitialViewController() as? UIViewController
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        应用运行参数 = launchOptions
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "重新启动", name: "重新启动通知", object: nil)
        界面初始化()
        第三方SDK初始化(应用运行参数)
        设置初始化()
        应用初始化()
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func 重新启动() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.window?.rootViewController?.view.alpha = 0
            }) { (isok:Bool) -> Void in
                self.window?.removeFromSuperview()
                self.window = nil
                NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "重新加载", userInfo: nil, repeats: false)
        }
    }
    
    func 重新加载() {
        界面初始化()
        self.window?.rootViewController?.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.window?.rootViewController?.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        })
        //第三方SDK初始化(应用运行参数) //不需要
        设置初始化()
        应用初始化()
        self.window?.makeKeyAndVisible()
    }
    
    func 设置初始化()
    {
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let noFirstRun:Bool = defaults.boolForKey("noFirstRun")
        let checkbgo:Float? = defaults.floatForKey("bgopacity")
        if (!noFirstRun) {
            defaults.setBool(false, forKey: "exitaftercopy")
            defaults.setFloat(100, forKey: "adfrequent")
            defaults.setFloat(40, forKey: "bgopacity")
//            defaults.setBool(true, forKey: "noFirstRun")
            defaults.synchronize()
        }
        if(noFirstRun && checkbgo == 0.0)
        {
            defaults.setFloat(0.0, forKey: "bgopacity")
            defaults.synchronize()
        }
    }
    
    func loadwebdatace(notification:NSNotification)
    {
        statBar.showMsg(lang.uage("正在加载源"))
        let 网址和目标位置序号数组:NSArray = notification.object as! NSArray
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        全局_网络繁忙 = true
        filemgr.nowURLarr = 网址和目标位置序号数组
        let 目标位置序号对象:NSNumber = 网址和目标位置序号数组.objectAtIndex(1) as! NSNumber
        let 目标位置序号:Int = 目标位置序号对象.integerValue
        let 当前下载模式:NetDownloadTo = NetDownloadTo(rawValue: 目标位置序号)!
        var alldata:NSArray? = nil
        if (当前下载模式 != NetDownloadTo.CLOUDEMOTICONREFRESH) {
            alldata = filemgr.LoadArrayFromFile(FileManager.saveMode.NETWORK)
        }
        if(alldata == nil)
        {
            var newdwn = NetworkDownload()
            newdwn.开始异步连接(网址和目标位置序号数组)
        } else {
            p_emodata = alldata!
        }
        NSNotificationCenter.defaultCenter().postNotificationName("loaddataoks", object: 网址和目标位置序号数组)
        statBar.hideMsg()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        全局_网络繁忙 = false
    }
    
    func loadwebdataokce(notification:NSNotification)
    {
        let 网址和目标位置序号数组:NSArray = notification.object as! NSArray
        let 网址:NSString = 网址和目标位置序号数组.objectAtIndex(0) as! NSString
        let 目标位置序号对象:NSNumber = 网址和目标位置序号数组.objectAtIndex(1) as! NSNumber
        let 目标位置序号:Int = 目标位置序号对象.integerValue
        let 当前下载目标位置:NetDownloadTo = NetDownloadTo(rawValue: 目标位置序号)!
        let 请求的数据数组:NSArray? = filemgr.LoadArrayFromFile(FileManager.saveMode.NETWORK)
        if (请求的数据数组 != nil) {
            if (当前下载目标位置 == NetDownloadTo.CLOUDEMOTICON || 当前下载目标位置 == NetDownloadTo.CLOUDEMOTICONREFRESH) {
                p_emodata = 请求的数据数组!
            }
        }
        
        statBar.hideMsg()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        全局_网络繁忙 = false
        
//        var err:NSError = NSError()
//        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CloudEmoticon")!
        
//        let documentDirectory:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let documentDirectoryAddress:NSString = documentDirectory[0] as NSString
//        let dicstr:NSString = NSString.localizedStringWithFormat("%@/",documentDirectoryAddress)
//        containerURL = containerURL.URLByAppendingPathComponent(dicstr)
//        let value:NSArray = p_emodata
        
        //http://www.cocoachina.com/applenews/devnews/2014/0627/8960.html
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //p_emodata
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        NSNotificationCenter.defaultCenter().postNotificationName("WillEnterForeground", object: nil)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the

    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}