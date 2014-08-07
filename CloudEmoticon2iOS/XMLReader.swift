//
//  XMLReader.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/7.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class XMLReader: NSObject {
   
    func data2xml(data:NSData) {
        var xmld:XMLDictionaryParser = XMLDictionaryParser()
        var rootDic:NSDictionary = xmld.dictionaryWithData(data)
        println(rootDic)
    }
    
}
