//
//  EmokbViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫 on 14/9/5.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class EmokbViewController: UIViewController {


    @IBOutlet weak var EmoKBText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = lang.uage("输入法") as String
        EmoKBText.text = lang.uage("颜文字输入法") as String
        // Do any additional setup after loading the view.
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
