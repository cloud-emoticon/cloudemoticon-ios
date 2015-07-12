//
//  UserSync.swift
//  
//
//  Created by 神楽坂雅詩 on 15/6/27.
//
//

import UIKit
import Parse
protocol UserSyncDelegate {
    
}

class UserSync: NSObject {
    
    func 下载当前用户同步对象(类名:String) { // PFObject Array
        NSLog("[UserSync]下载“%@”同步信息...",类名)
        let 查询:PFQuery = PFQuery(className: 类名)
        var 当前用户:NSDictionary? = 全局_Parse读写.当前用户()
        if (当前用户 != nil) {
            查询.whereKey("owner", equalTo: PFUser.currentUser()!)
            查询.findObjectsInBackgroundWithBlock({ (返回对象数组对象:[AnyObject]?, 错误信息:NSError?) -> Void in
                if (错误信息 == nil) {
                    let 返回对象数组:NSArray = 返回对象数组对象!
                    NSLog("[UserSync]下载“%d”个“%@”同步信息数据完成。",返回对象数组.count, 类名)
//                    for (var i:Int = 0; i < 返回对象数组.count; i++) {
//                        let 对象:PFObject = 返回对象数组.objectAtIndex(i) as! PFObject
//                    }
                    self.对象数组下载完毕(数据: 返回对象数组,类名: 类名)
                } else {
                    NSLog("[UserSync]下载“%@”同步信息数据失败！(%@)", 类名, 错误信息!)
                    self.对象数组下载完毕(数据: nil,类名: 类名)
                }
            })
        }
    }
    
    func 对象数组下载完毕(#数据:NSArray?,类名:String) {
        if (数据 != nil) {
            if (类名 == "SyncInfo") {
                let SyncInfoDic:PFObject = 数据?.objectAtIndex(0) as! PFObject
                let SyncInfo:M_SyncInfo = M_SyncInfo()
                SyncInfo.owner = SyncInfoDic.objectForKey("owner") as! PFUser
                SyncInfo.lastUploadTime = SyncInfoDic.objectForKey("lastUploadTime") as! NSDate
                SyncInfo.lastDownloadTime = SyncInfoDic.objectForKey("lastDownloadTime") as! NSDate
                SyncInfo.lastUploadDevice = SyncInfoDic.objectForKey("lastUploadDevice") as! String
                SyncInfo.lastUploadOS = SyncInfoDic.objectForKey("lastUploadOS") as! String
                SyncInfo.lastUploadAPP = SyncInfoDic.objectForKey("lastUploadAPP") as! String
                SyncInfo.show()
                //判断上次设备类型版本APP等或新增一个识别码用于判断该上传还是下载
            }
        } else {
            UIAlertView(title: lang.uage("同步以下失败"), message: 类名, delegate: nil, cancelButtonTitle: lang.uage("取消")).show()
        }
    }
    
}

