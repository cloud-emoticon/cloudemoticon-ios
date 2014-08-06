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


    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        
        //TEST
//        var newdwn = NetworkDownload.alloc()
//        newdwn.startAsyConnection()
        //TEST
        
        var statBarFrame = UIApplication.sharedApplication().statusBarFrame
        self.statBar = CustomStatusBar(frame: CGRectMake(statBarFrame.width * 0.6, 0, statBarFrame.width * 0.4, statBarFrame.height))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadwebdataf", name: "loadwebdata", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadwebdataokf", name: "loaddataok", object: nil)
        return true
    }
    
    func loadwebdataf()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        var newdwn = NetworkDownload.alloc()
        newdwn.startAsyConnection()
        statBar.showMsg("正在下载源...")
    }
    func loadwebdataokf()
    {
        statBar.hideMsg()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

