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
        AddtoCustom.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Disabled)
        AddtoCustom.layer.cornerRadius = 4
        RunFamApp.layer.cornerRadius = 4
        emoEx.frame = CGRectMake(0, 0, self.view.frame.width, 36)
    }
    
    @IBOutlet var emoEx: UIView!
    override func viewDidAppear(animated: Bool) {
        emoText.text = UIPasteboard.generalPasteboard().string
        if(UIPasteboard.generalPasteboard().string == nil)
        {
            AddtoCustom.enabled = false
            emoText.text = "剪贴板空"
        } else {
            AddtoCustom.enabled = true
        }
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
    @IBOutlet weak var emoText: UILabel!
    
    @IBAction func AddtoCustom(sender: AnyObject) {
        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CE2Keyboard")!
        var value:NSString
        containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
        var emolist:NSString? = NSString(contentsOfURL: containerURL, encoding: NSUTF8StringEncoding, error: nil)
        if(emolist != nil && emolist != "[[],[],[]]" && emolist != "") {
            let 文件中的数据:NSArray = ArrayString().json2array(emolist!) as NSArray
            var 自定义数据:NSMutableArray = NSMutableArray.alloc()
            自定义数据.addObject(文件中的数据.objectAtIndex(1))
            自定义数据.addObject([emoText.text!,""])
            var 数据:NSArray = [文件中的数据.objectAtIndex(0),自定义数据,文件中的数据.objectAtIndex(2)]
            value = ArrayString().array2json(数据)
            value.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        } else {
            var 新建数据模型:NSArray = [[],[[emoText.text!,""]],[]]
            value = ArrayString().array2json(新建数据模型)
            value.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        }
        emoText.text = "添加成功"
    }

    @IBOutlet weak var RunFamApp: UIButton!

    @IBAction func RunFamApp(sender: UIButton) {
        emostart(sender)
    }
    
    func emostart(sender: UIButton!) {
        extensionContext?.openURL(NSURL(string: "emostart://")!, completionHandler: nil)
    }
    

}
