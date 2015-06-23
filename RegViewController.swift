//
//  RegViewController.swift
//  
//
//  Created by 神楽坂紫 on 15/6/23.
//
//

import UIKit

class RegViewController: UIViewController {

    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passconfirm: UITextField!
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var reg: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func 重置按钮(sender: AnyObject) {
        mail.text = ""
        username.text = ""
        password.text = ""
        passconfirm.text = ""
        mail.becomeFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
