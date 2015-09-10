//
//  MD5.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫 on 15/5/2.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import Foundation

func md5(md5:String) -> String {
    
        let str = md5.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(md5.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.destroy()
    
        NSLog("md5")
        return String(format: hash as String)
    
}
