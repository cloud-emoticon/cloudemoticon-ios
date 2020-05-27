//
//  MD5.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫 on 15/5/2.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import Foundation

func md5(_ md5:String) -> String {
    
        let str = md5.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(md5.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
    result.deinitialize(count: digestLen)
    
        NSLog("md5")
        return String(format: hash as String)
    
}
