//
//  CE2CSReader.swift
//
//
//  Created by 神楽坂雅詩 on 15/6/22.
//
//

import UIKit

class CE2CSReader: NSObject {
    
    var parse_applicationid_o:String? = nil
    var parse_clientkey_o:String? = nil
    var mobclick_o:String? = nil
    
    func 载入设置() {
        let parse_applicationid_p:UnsafeMutablePointer<Int8> = parse_applicationid()
        let parse_applicationid_s:NSMutableString = NSMutableString(format: "%s", parse_applicationid_p)
//        if (parse_applicationid_s.isEqualToString("")) {
//            NSLog("ok1")
//        }
        parse_applicationid_o = parse_applicationid_s as String
        
        let parse_clientkey_p:UnsafeMutablePointer<Int8> = parse_clientkey()
        let parse_clientkey_s:NSMutableString = NSMutableString(format: "%s", parse_clientkey_p)
        parse_clientkey_s.replaceCharacters(in: NSMakeRange(10, 1), with: "n")
//        if (parse_clientkey_s.isEqualToString("")) {
//            NSLog("ok2")
//        }
        parse_clientkey_o = parse_clientkey_s as String
        
        let mobclick_p:UnsafeMutablePointer<Int8> = mobclick()
        let mobclick_s:NSMutableString = NSMutableString(format: "%s", mobclick_p)
//        if (mobclick_s.isEqualToString("")) {
//            NSLog("ok3")
//        }
        mobclick_o = mobclick_s as String
    }
    
}
