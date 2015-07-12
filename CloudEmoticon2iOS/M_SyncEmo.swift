//
//  M_SyncEmo.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/7/12.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit
import Parse

//数据模型：同步用颜文字模型
class M_SyncEmo: NSObject {
    var emoticon:String = "unknown" //颜文字本体
    var descriptions:String = "" //描述
    var shortcut:String = "" //输入法快捷输入
    var owner:PFUser = PFUser() //指向拥有这个颜文字的用户
}
