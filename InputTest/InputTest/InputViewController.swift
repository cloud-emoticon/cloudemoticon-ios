//
//  InputViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫 on 14/9/2.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    
    @IBOutlet weak var textbox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        textbox.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        
    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}