//
//  XMLReader.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/6.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//


import UIKit

class XMLReader: NSObject { //,NSXMLParserDelegate
    
    func data2json(data:NSData) {
        
        var 全部字符串:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)
        var 字符串长度:Int = 全部字符串.length - 1
        //验证
        var 头部分检查:NSString = 全部字符串.substringWithRange(NSMakeRange(0, 7))
        if (头部分检查.isEqualToString("<emoji>"))
        {
            var 当前句子:NSMutableString = ""
            for i in 0...字符串长度
            {
                var 当前字符:NSString = 全部字符串.substringWithRange(NSMakeRange(i, 1))
                当前句子.insertString(当前字符, atIndex: 当前句子.length)
                
                if (当前字符.isEqualToString(">"))
                {
                    for i2 in 0...(当前句子.length-1)
                    {
                        var 内容字符串:NSString = ""
                        var 当前字符2a:NSString = 当前句子.substringWithRange(NSMakeRange(i2, 1))
                        if (当前字符2.isEqualToString("<"))
                        {
                            
                            var 当前字符2:NSString = 当前句子.substringWithRange(NSMakeRange(i2, 2))
                            if (当前字符2.isEqualToString("</"))
                            {
                                
                                //if (i2 + 1 < 当前句子.length)
                                //{
                                //    var 当前字符3:NSString = 当前句子.substringWithRange(NSMakeRange(i2+1, 1))
                                //    if (当前字符3.isEqualToString("/"))
                                //    {
                                //        //结束关键字
                                        内容字符串 = 当前句子.substringWithRange(NSMakeRange(0, i2-1))
                                        println(内容字符串)
                                //    }
                                //}
                                
                                
                                
                            }
                        }
                        
                    }
                    当前句子 = ""
                }
            }
            
        } else {
            //错误
        }
        
    }
    
//    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!)
//    {
//        NSLog("Name:%@",elementName);
//    }
//    
//    func parser(parser: NSXMLParser!, foundCharacters string: String!)
//    {
//        NSLog("Value:%@",string);
//    }
//    
//    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
//    {
//        NSLog("Name:%@",elementName);
//    }
}
