////
////  UserSync.swift
////  
////
////  Created by 神楽坂雅詩 on 15/6/27.
////
////
//
//import UIKit
//import Parse
//protocol UserSyncDelegate {
//    
//}
//
//class UserSync: NSObject {
//    
//    func 下载当前用户同步对象(类名:String) { // PFObject Array
//        NSLog("[UserSync]下载“%@”同步信息...",类名)
//        let 查询:PFQuery = PFQuery(className: 类名)
//        let 当前用户:NSDictionary? = 全局_Parse读写.当前用户()
//        if (当前用户 != nil) {
//            查询.whereKey("owner", equalTo: PFUser.currentUser()!)
//            查询.findObjectsInBackgroundWithBlock{ (返回对象数组对象:[AnyObject]?, 错误信息:NSError?) -> Void in
//                if (错误信息 == nil) {
//                    let 返回对象数组:NSArray = 返回对象数组对象!
//                    NSLog("[UserSync]下载“%d”个“%@”同步信息数据完成。",返回对象数组.count, 类名)
////                    for (var i:Int = 0; i < 返回对象数组.count; i++) {
////                        let 对象:PFObject = 返回对象数组.objectAtIndex(i) as! PFObject
////                    }
//                    self.对象数组下载完毕(返回对象数组,类名: 类名)
//                } else {
//                    NSLog("[UserSync]下载“%@”同步信息数据失败！(%@)", 类名, 错误信息!)
//                    self.对象数组下载完毕(nil,类名: 类名)
//                }
//            }
//        }
//    }
//    
//    func 对象数组下载完毕(数据:NSArray?,类名:String) {
//        if (数据 != nil) {
//            if (类名 == "SyncInfo") {
//                let SyncInfoDic:PFObject = 数据?.objectAtIndex(0) as! PFObject
//                let SyncInfo:M_SyncInfo = M_SyncInfo()
//                SyncInfo.owner = SyncInfoDic.objectForKey("owner") as! PFUser
//                SyncInfo.lastUploadTime = SyncInfoDic.objectForKey("lastUploadTime") as! NSDate
//                SyncInfo.lastDownloadTime = SyncInfoDic.objectForKey("lastDownloadTime") as! NSDate
//                SyncInfo.lastUploadDevice = SyncInfoDic.objectForKey("lastUploadDevice") as! String
//                SyncInfo.lastUploadOS = SyncInfoDic.objectForKey("lastUploadOS") as! String
//                SyncInfo.lastUploadAPP = SyncInfoDic.objectForKey("lastUploadAPP") as! String
//                SyncInfo.show()
//                //判断上次设备类型版本APP等或新增一个识别码用于判断该上传还是下载
//            }
//        } else {
//            UIAlertView(title: lang.uage("同步以下失败"), message: 类名, delegate: nil, cancelButtonTitle: lang.uage("取消")).show()
//        }
//    }
//    
//    func 转换为同步用数据格式() -> NSArray? {
//        let 组数据读写:AppGroupIO = AppGroupIO()
//        let 数据数组:NSArray? = 组数据读写.读取设置UD模式()
////        let 全部收藏数组:NSArray = 数据数组!.objectAtIndex(0) as! NSArray
////        let 全部自定数组:NSArray = 数据数组!.objectAtIndex(1) as! NSArray
////        let 全部历史数组:NSArray = 数据数组!.objectAtIndex(2) as! NSArray
////        let 全部皮肤数组:NSArray = 数据数组!.objectAtIndex(3) as! NSArray
//        if (数据数组 != nil && 数据数组?.count >= 3 && PFUser.currentUser() != nil) {
//            let 主同步数组:NSMutableArray = NSMutableArray()
//            for 类别循环:Int in 0 ..< (数据数组?.count)! {
////            for (var 类别循环:Int = 0; 类别循环 < 数据数组?.count; 类别循环 += 1) {
//                let 当前类别数组:NSArray = 数据数组!.objectAtIndex(类别循环) as! NSArray
//                let 当前类别返回数组:NSMutableArray = NSMutableArray()
//                for 颜文字循环:Int in 0 ..< 当前类别数组.count {
////                for (var 颜文字循环:Int = 0; 颜文字循环 < 当前类别数组.count; 颜文字循环 += 1) {
//                    let 当前颜文字数组:NSArray = 当前类别数组.objectAtIndex(颜文字循环) as! NSArray
//                    let 新建颜文字数据模型:M_SyncEmo = M_SyncEmo()
//                    新建颜文字数据模型.emoticon = 当前颜文字数组.objectAtIndex(0) as! String
//                    if (当前颜文字数组.count > 1) {
//                        新建颜文字数据模型.descriptions = 当前颜文字数组.objectAtIndex(1) as! String
//                    }
//                    新建颜文字数据模型.shortcut = ""
//                    新建颜文字数据模型.owner = PFUser.currentUser()!
//                    当前类别返回数组.addObject(新建颜文字数据模型)
//                }
//                主同步数组.addObject(当前类别返回数组)
//            }
//            return 主同步数组
//        }
//        return nil
//    }
//}
//
