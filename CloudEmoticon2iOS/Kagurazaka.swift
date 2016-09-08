//
//  Kagurazaka.swift
//  Kagurazaka
//
//  Created by 神楽坂雅詩 on 15/7/11.
//  Copyright (c) 2015年 神楽坂雅詩. All rights reserved.
//

import UIKit

class Kagurazaka: NSObject {
    
    func initArr(w:Int,h:Int,a:String) -> NSMutableArray {
        let harr:NSMutableArray = NSMutableArray()
        for _ in 0...h {
            let warr:NSMutableArray = NSMutableArray()
            for _ in 0...w {
                warr.add(a)
            }
            warr.add("\n")
            harr.add(warr)
        }
        return harr
    }
    
    func rArr(_ harr:NSMutableArray,tArr:NSArray,b:String) -> NSMutableArray {
        var h = 0
        var w:NSMutableArray = harr.object(at: h) as! NSMutableArray
        for ti in 0...(tArr.count - 1) {
            let tN:NSNumber = tArr[ti] as! NSNumber
            let t:Int = tN.intValue
            if (t < 0) {
                h += 1
                w = harr.object(at: h) as! NSMutableArray
            } else {
                w.replaceObject(at: t, with: b)
            }
        }
        return w
    }
    
    func tostr(_ harr:NSMutableArray) {
        let str:NSMutableString = ""
        for hi in 0...(harr.count - 1) {
            let warr:NSArray = harr.object(at: hi) as! NSArray
            for wi in 0...(warr.count - 1) {
                let nstr:String = warr.object(at: wi) as! String
                str.append(nstr)
            }
        }
        NSLog(" %@", str)
    }
    
    func centerStr(_ s:String,w:Int) -> String {
        let sn:NSMutableString = NSMutableString(string: s)
        let sl:Int = sn.length
        if (sl >= w) {
            return s
        }
        let n:Int = w/2 - sl/2
        for _ in 1...n {
            sn.insert(" ", at: 0)
        }
        return sn as String
    }
    
    func KagurazakaArray(_ a:String,b:String) {
        let ww:Int = 34
        let harr:NSMutableArray = initArr(w: ww, h: 10, a: a)
        let title:String = centerStr("Kagurazaka\n", w: ww*2-8)
        let foot:String = centerStr("神楽坂雅詩(KagurazakaYashi) x 神楽坂紫(KagurazakaYukari)\n", w: ww*2-14)
        let t:NSArray = [1,7,17,26,-1,2,7,12,22,26,-2,7,13,15,19,21,26,30,-3,3,5,7,10,-4,2,7,15,19,26,29,34,-5,5,7,10,26,34,-6,0,5,7,10,17,26,29,31,33,-7,2,7,29,31,33,-8,2,7,15,17,19,28,32,-9,2,7,14,17,20,27,31,33,-10,2,7,17,26,34]
        rArr(harr, tArr: t, b: b)
        
        var w:NSMutableArray = harr.object(at: 0) as! NSMutableArray
        for i in 32...34 {
            w.replaceObject(at: i, with: b)
        }
        
        w = harr.object(at: 1) as! NSMutableArray
        for i in 15...19 {
            w.replaceObject(at: i, with: b)
        }
        for i in 29...31 {
            w.replaceObject(at: i, with: b)
        }
        
        w = harr.object(at: 2) as! NSMutableArray
        for i in 0...3 {
            w.replaceObject(at: i, with: b)
        }
        for i in 5...10 {
            w.replaceObject(at: i, with: b)
        }
        
        w = harr.object(at: 3) as! NSMutableArray
        for i in 14...20 {
            w.replaceObject(at: i, with: b)
        }
        for i in 24...34 {
            w.replaceObject(at: i, with: b)
        }
        
        w = harr.object(at: 4) as! NSMutableArray
        for i in 5...10 {
            w.replaceObject(at: i, with: b)
        }
        for i in 12...13 {
            w.replaceObject(at: i, with: b)
        }
        for i in 21...22 {
            w.replaceObject(at: i, with: b)
        }
        
        w = harr.object(at: 5) as! NSMutableArray
        for i in 1...2 {
            w.replaceObject(at: i, with: b)
        }
        for i in 15...19 {
            w.replaceObject(at: i, with: b)
        }
        for i in 29...30 {
            w.replaceObject(at: i, with: b)
        }
        
        w = harr.object(at: 6) as! NSMutableArray
        for i in 2...3 {
            w.replaceObject(at: i, with: b)
        }
        
        w = harr.object(at: 7) as! NSMutableArray
        for i in 5...10 {
            w.replaceObject(at: i, with: b)
        }
        for i in 12...22 {
            w.replaceObject(at: i, with: b)
        }
        for i in 26...27 {
            w.replaceObject(at: i, with: b)
        }
        
        w = harr.object(at: 8) as! NSMutableArray
        for i in 24...25 {
            w.replaceObject(at: i, with: b)
        }
        
        w = harr.object(at: 9) as! NSMutableArray
        
        w = harr.object(at: 10) as! NSMutableArray
        for i in 12...13 {
            w.replaceObject(at: i, with: b)
        }
        for i in 21...22 {
            w.replaceObject(at: i, with: b)
        }
        for i in 29...30 {
            w.replaceObject(at: i, with: b)
        }
        harr.insert(["\n",title], at: 0)
        harr.add([foot])
        tostr(harr)
    }
}

