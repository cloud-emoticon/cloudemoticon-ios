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
        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CE2Keyboard")!
        var value:NSString
        containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
        var emolist:NSString? = NSString.stringWithContentsOfURL(containerURL, encoding: NSUTF8StringEncoding, error: nil)
        if(emolist != nil || emolist != "") {
            var 文件中的数据:NSArray = ArrayString().json2array(emolist!) as NSArray
            var 自定义数据:NSMutableArray = NSMutableArray.array()
            自定义数据.addObjectsFromArray(文件中的数据.objectAtIndex(1) as NSArray)
            自定义数据.addObject([emoText.text,""])
            var 数据:NSArray = [文件中的数据.objectAtIndex(0),自定义数据,文件中的数据.objectAtIndex(2)]
            value = ArrayString().array2json(数据)
            value.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        } else {
            var 新建数据模型:NSArray = [NSArray.array(),[[emoText.text,""]],NSArray.array()]
            value = ArrayString().array2json(新建数据模型)
            value.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        }
        emoText.text = ""
        emoText.placeholder = "添加成功"
        println(emolist)
    }
    

    @IBOutlet weak var RunFamApp: UIButton!

    
    @IBAction func RunFamApp(sender: UIButton) {
        emostart(sender)
    }
    
    func emostart(sender: UIButton!) {
        extensionContext?.openURL(NSURL(string: "emostart://"), completionHandler: nil)
    }
    

}
