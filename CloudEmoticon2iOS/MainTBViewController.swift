//
//  MainTBViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/6.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class MainTBViewController: UITabBarController {
    
//    var load: LoadingView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NSNotificationCenter.defaultCenter().postNotificationName("loadwebdata", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "alertview:", name: "alertview", object: nil)
//        self.view.addSubview(statBar)
//        self.view.addSubview(load)
        
    }
    
    func alertview(notification:NSNotification)
    {
        let altarr:NSArray = notification.object as NSArray
        //数组：title，message，btn title
        let alert = UIAlertController(title: altarr.objectAtIndex(0) as NSString, message: altarr.objectAtIndex(1) as NSString, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: altarr.objectAtIndex(2) as NSString, style: .Default) {
            [weak alert] action in
//            print("OK Pressed")
            alert!.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(okAction)
        presentViewController (alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func shouldAutorotate() -> Bool
//    {
//        return true
//    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator!)
    {
        let newScreenSize:NSArray = [size.width, size.height]
        NSNotificationCenter.defaultCenter().postNotificationName("transition", object: newScreenSize)
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
