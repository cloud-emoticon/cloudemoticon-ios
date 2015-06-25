//
//  RegViewController.swift
//  
//
//  Created by 神楽坂紫 on 15/6/23.
//
//

import UIKit

class RegViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var 邮箱输入框: UITextField!
    @IBOutlet weak var 用户名输入框: UITextField!
    @IBOutlet weak var 密码输入框: UITextField!
    @IBOutlet weak var 确认密码输入框: UITextField!
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var reg: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let 背景色:UIColor = UIColor(red: 1, green: 0.79215, blue: 0.86274, alpha: 1)
        self.navigationController?.view.backgroundColor = 背景色
        self.view.backgroundColor = 背景色
        邮箱输入框.delegate = self
        邮箱输入框.keyboardType = UIKeyboardType.EmailAddress
        用户名输入框.delegate = self
        用户名输入框.keyboardType = UIKeyboardType.NamePhonePad
        密码输入框.delegate = self
        确认密码输入框.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func 注册按钮点击(sender: UIButton) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func 重置按钮(sender: AnyObject) {
        邮箱输入框.text = ""
        用户名输入框.text = ""
        密码输入框.text = ""
        确认密码输入框.text = ""
//        邮箱输入框.becomeFirstResponder()
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
        if (邮箱输入框.isFirstResponder()) {
            用户名输入框.becomeFirstResponder()
        } else if (用户名输入框.isFirstResponder()) {
            密码输入框.becomeFirstResponder()
        } else if (密码输入框.isFirstResponder()) {
            确认密码输入框.becomeFirstResponder()
        } else if (确认密码输入框.isFirstResponder()) {
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
}
