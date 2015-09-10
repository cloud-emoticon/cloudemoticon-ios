//
//  ArrayString.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/9/2.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class ArrayString: NSObject {
   
    func 数组转JSON字符串(inArray:NSArray) -> NSString
    {
        return NSString(data: try! NSJSONSerialization.dataWithJSONObject(inArray, options: NSJSONWritingOptions()), encoding: NSUTF8StringEncoding)!
    }
    
    func JSON字符串转数组(inString:NSString) -> NSArray
    {
        return (try! NSJSONSerialization.JSONObjectWithData(inString.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions())) as! NSArray
    }
}