//
//  ArrayString.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/9/2.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class ArrayString: NSObject {
    
    func array2json(inArray:NSArray) -> NSString
    {
        return NSString(data: NSJSONSerialization.dataWithJSONObject(inArray, options: NSJSONWritingOptions(), error: nil)!, encoding: NSUTF8StringEncoding)!
    }
    
    func json2array(inString:NSString) -> NSArray
    {
        return NSJSONSerialization.JSONObjectWithData(inString.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions(), error: nil) as! NSArray
    }
}