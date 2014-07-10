//
//  CEViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/7/10.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class CEViewController: UIViewController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.move.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var emoView: UIView
    @IBOutlet var emosortView: UIView
    @IBOutlet strong var move: UIPanGestureRecognizer
    
    //    用户拖动视图
    var panGestureRecognizer :
    UIPanGestureRecognizer!
    
    //    用户touch的点位置
    var panGestureStartLocation : CGPoint!
    
    var i=0
    
//    self.panGestureRecognizer = UIPanGestureRecognizer()
//    self.panGestureRecognizer.addTarget(self,action:"panGestureRecognized:");
    
    @IBAction func move(sender: AnyObject) {
        
        i++
        println("test \(i)")
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
