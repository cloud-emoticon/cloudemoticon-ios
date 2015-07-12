//
//  Kagurazaka.swift
//  Kagurazaka
//
//  Created by 神楽坂雅詩 on 15/7/11.
//  Copyright (c) 2015年 神楽坂雅詩. All rights reserved.
//

import UIKit

class Kagurazaka: NSObject {
    
    func initArr(#w:Int,h:Int,a:String) -> NSMutableArray {
        var harr:NSMutableArray = NSMutableArray()
        for hi in 0...h {
            var warr:NSMutableArray = NSMutableArray()
            for wi in 0...w {
                warr.addObject(a)
            }
            warr.addObject("\n")
            harr.addObject(warr)
        }
        return harr
    }
    
    func rArr(harr:NSMutableArray,tArr:NSArray,b:String) -> NSMutableArray {
        var h = 0
        var w:NSMutableArray = harr.objectAtIndex(h) as! NSMutableArray
        for ti in 0...(tArr.count - 1) {
            let tN:NSNumber = tArr[ti] as! NSNumber
            let t:Int = tN.integerValue
            if (t < 0) {
                w = harr.objectAtIndex(++h) as! NSMutableArray
            } else {
                w.replaceObjectAtIndex(t, withObject: b)
            }
        }
        return w
    }
    
    func tostr(harr:NSMutableArray) {
        var str:NSMutableString = ""
        for hi in 0...(harr.count - 1) {
            let warr:NSArray = harr.objectAtIndex(hi) as! NSArray
            for wi in 0...(warr.count - 1) {
                let nstr:String = warr.objectAtIndex(wi) as! String
                str.appendString(nstr)
            }
        }
        NSLog(" %@", str)
    }
    
    func centerStr(s:String,w:Int) -> String {
        let sn:NSMutableString = NSMutableString(string: s)
        let sl:Int = sn.length
        if (sl >= w) {
            return s
        }
        let n:Int = w/2 - sl/2
        for i in 1...n {
            sn.insertString(" ", atIndex: 0)
        }
        return sn as String
    }
    
    func KagurazakaArray(a:String,b:String) {
        let ww:Int = 34
        var harr:NSMutableArray = initArr(w: ww, h: 10, a: a)
        let title:String = centerStr("Kagurazaka\n", w: ww*2-8)
        let foot:String = centerStr("神楽坂雅詩(KagurazakaYashi) x 神楽坂紫(KagurazakaYukari)\n", w: ww*2-14)
        let t:NSArray = [1,7,17,26,-1,2,7,12,22,26,-2,7,13,15,19,21,26,30,-3,3,5,7,10,-4,2,7,15,19,26,29,34,-5,5,7,10,26,34,-6,0,5,7,10,17,26,29,31,33,-7,2,7,29,31,33,-8,2,7,15,17,19,28,32,-9,2,7,14,17,20,27,31,33,-10,2,7,17,26,34]
        rArr(harr, tArr: t, b: b)
        
        var w:NSMutableArray = harr.objectAtIndex(0) as! NSMutableArray
        for i in 32...34 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        
        w = harr.objectAtIndex(1) as! NSMutableArray
        for i in 15...19 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        for i in 29...31 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        
        w = harr.objectAtIndex(2) as! NSMutableArray
        for i in 0...3 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        for i in 5...10 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        
        w = harr.objectAtIndex(3) as! NSMutableArray
        for i in 14...20 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        for i in 24...34 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        
        w = harr.objectAtIndex(4) as! NSMutableArray
        for i in 5...10 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        for i in 12...13 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        for i in 21...22 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        
        w = harr.objectAtIndex(5) as! NSMutableArray
        for i in 1...2 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        for i in 15...19 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        for i in 29...30 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        
        w = harr.objectAtIndex(6) as! NSMutableArray
        for i in 2...3 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        
        w = harr.objectAtIndex(7) as! NSMutableArray
        for i in 5...10 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        for i in 12...22 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        for i in 26...27 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        
        w = harr.objectAtIndex(8) as! NSMutableArray
        for i in 24...25 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        
        w = harr.objectAtIndex(9) as! NSMutableArray
        
        w = harr.objectAtIndex(10) as! NSMutableArray
        for i in 12...13 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        for i in 21...22 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        for i in 29...30 {
            w.replaceObjectAtIndex(i, withObject: b)
        }
        harr.insertObject(["\n",title], atIndex: 0)
        harr.addObject([foot])
        tostr(harr)
    }
}

