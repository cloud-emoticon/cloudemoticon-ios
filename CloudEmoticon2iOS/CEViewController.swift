//
//  CEViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/12.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class CEViewController: UIViewController, UIScrollViewDelegate { //, UIGestureRecognizerDelegate
    
    let className:NSString = "[CEViewController]"

    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var sortTable: UITableView!
    @IBOutlet weak var ceTable: UITableView!
    @IBOutlet weak var scroll: UIScrollView!
    
//    var autoHideSortView:Bool = true
    
    override func viewDidLoad() {
//        self.scroll.delegate = self
//        sortView.backgroundColor = UIColor.blueColor()
//        ceTable.backgroundColor = UIColor.orangeColor()
//        scroll.frame = self.view.frame
//        scroll.contentSize = CGSizeMake(3000, self.view.frame.height)
//        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone && self.view.frame.width < self.view.frame.height)
//        {
//            sortView.frame = CGRectMake(0, 0, scroll.frame.width * 0.6, scroll.frame.height)
//            ceTable.frame = CGRectMake(sortView.frame.size.width, 0, scroll.frame.width, scroll.frame.height)
//            scroll.contentSize = CGSizeMake(sortView.frame.size.width + ceTable.frame.size.width, scroll.frame.height)
//            scroll.contentOffset = CGPointMake(sortView.frame.width, 0)
//        } else {
//            sortView.frame = CGRectMake(0, 0, scroll.frame.width * 0.3, scroll.frame.height)
//            ceTable.frame = CGRectMake(0, 0, scroll.frame.width * 0.7, scroll.frame.height)
//            scroll.contentSize = CGSizeMake(scroll.frame.width, scroll.frame.height)
//            scroll.contentOffset = CGPointMake(0, 0)
//        }
    }
    //¥60% 30%
    
    func scrollViewDidScroll(scrollView: UIScrollView!)
    {
        
    }

//    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
//    {
//        let touch:UITouch = touches.anyObject() as UITouch
//        var point:CGPoint = touch.locationInView(self.view)
//        NSLog("%f, %f", point.x, point.y)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
