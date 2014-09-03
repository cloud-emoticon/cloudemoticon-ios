//
//  TodayViewController.swift
//  CE2NCWidget
//
//  Created by 神楽坂紫喵 on 14/8/7.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
//        RunFamApp.addTarget(self,action:"emostart:",forControlEvents:.TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encoutered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    @IBOutlet weak var AddtoCustom: UIButton!
    @IBOutlet weak var emoText: UITextField!
    
    @IBAction func AddtoCustom(sender: UIButton) {
        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CE2NCWidget")!
        var value:NSString = emoText.text
        containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
//        println(containerURL)
//        var emolist:NSMutableArray = [value]
//        println(emolist)
//        var container:NSMutableArray = NSMutableArray(contentsOfURL: containerURL)
//        println(emolist)
////        if(emolist == nil) {
////            var valuearr:NSMutableArray = [value]
////            emolist = valuearr
////        } else {
////        emolist?.addObject(value)
////        }
////        println(emolist)
////        if(emolist != nil) {
//        emolist.writeToURL(containerURL, atomically: true)
////        }
        value.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        emoText.text = ""
        emoText.placeholder = "添加成功"
        
    }
    

    @IBOutlet weak var RunFamApp: UIButton!

    
    @IBAction func RunFamApp(sender: UIButton) {
        emostart(sender)
    }
    
    func emostart(sender: UIButton!) {
        extensionContext?.openURL(NSURL(string: "emostart://"), completionHandler: nil)
    }
    

}
