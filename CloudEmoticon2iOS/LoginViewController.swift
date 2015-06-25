//
//  LoginViewController.swift
//  
//
//  Created by 神楽坂雅詩 on 15/6/22.
//
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var 账号输入框: UITextField!
    @IBOutlet weak var 密码输入框: UITextField!
    @IBOutlet weak var 注册按钮: UIButton!
    @IBOutlet weak var 登录按钮: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登陆"  //lang.uage("登陆")
        let 背景色:UIColor = UIColor(red: 1, green: 0.79215, blue: 0.86274, alpha: 1)
        self.navigationController?.view.backgroundColor = 背景色
        self.view.backgroundColor = 背景色
        账号输入框.delegate = self
        账号输入框.keyboardType = UIKeyboardType.NamePhonePad
        密码输入框.delegate = self
    }
    
    @IBAction func 登录按钮点击(sender: UIButton) {
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (self.view.frame.origin.y == 0 && self.view.frame.size.height < 1024) {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.frame.origin.y = 0 - textField.frame.origin.y + self.navigationController!.navigationBar.frame.size.height + 25
                //self.view.frame.origin.y = 0 - self.view.frame.size.height * 0.25
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (账号输入框.isFirstResponder()) {
            密码输入框.becomeFirstResponder()
        } else if (密码输入框.isFirstResponder()) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (self.view.frame.origin.y < 0 && self.view.frame.size.height < 1024) {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.frame.origin.y = 0
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
