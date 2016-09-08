//
//  ArrayString.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/9/2.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class ArrayString: NSObject {
   
    func 数组转JSON字符串(_ inArray:NSArray) -> NSString
    {
        return NSString(data: try! JSONSerialization.data(withJSONObject: inArray, options: JSONSerialization.WritingOptions()), encoding: String.Encoding.utf8.rawValue)!
    }
    
    func JSON字符串转数组(_ inString:NSString) -> NSArray
    {
        return (try! JSONSerialization.jsonObject(with: inString.data(using: String.Encoding.utf8.rawValue)!, options: JSONSerialization.ReadingOptions())) as! NSArray
    }
}
