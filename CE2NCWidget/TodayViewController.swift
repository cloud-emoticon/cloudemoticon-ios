//
//  TodayViewController.swift
//  CE2NCWidget
//
//  Created by 神楽坂紫 on 14/8/7.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
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
    @IBOutlet weak var RunFamApp: UIButton!
    
    func addTarget(target: AnyObject!, action: Selector, forControlEvents controlEvents: UIControlEvents) {
    RunFamApp.addTarget(self,action:"tappedButton:",forControlEvents:.TouchUpInside);
}
    
    func tappedButton(sender: UIButton!) {
        var url:NSURL = NSURL.URLWithString("emostart://")
        UIApplication.sharedApplication().openURL(url)
    }
}
