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
    var 右上按钮: UIBarButtonItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = lang.uage("登录")
        注册按钮.setTitle(lang.uage("注册"), forState: UIControlState.Normal)
        登录按钮.setTitle(lang.uage("登录"), forState: UIControlState.Normal)
        let 背景色:UIColor = UIColor(red: 1, green: 0.79215, blue: 0.86274, alpha: 1)
        self.navigationController?.view.backgroundColor = 背景色
        self.view.backgroundColor = 背景色
        右上按钮 = UIBarButtonItem(title: lang.uage("关闭键盘"), style: UIBarButtonItemStyle.Plain, target: self, action: "关闭软键盘")
        账号输入框.delegate = self
        密码输入框.delegate = self
        //  <测试用>
        账号输入框.text = "yashitest"
        密码输入框.text = "123456"
        //  </测试用>
    }
    
    func 关闭软键盘() {
        账号输入框.resignFirstResponder()
        密码输入框.resignFirstResponder()
    }
    
    @IBAction func 登录按钮点击(sender: UIButton) {
        let 输入的用户名:NSString = 账号输入框.text!
        if (输入的用户名.length >= 3) {
            let 输入的密码:NSString = 密码输入框.text!
            if (输入的密码.length >= 6) {
                //继续
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "登录失败:", name: "P用户:登录失败", object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "登录成功:", name: "P用户:登录成功", object: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("显示等待提示框通知", object: NSNumber(bool: true))
                全局_Parse读写.用户登录(账号输入框.text!, 密码: 密码输入框.text!)
            } else {
                let 提示框:UIAlertView = UIAlertView(title: lang.uage("输入错误"), message: lang.uage("密码至少要6位"), delegate: nil, cancelButtonTitle: lang.uage("取消"))
                提示框.show()
            }
        } else {
            let 提示框:UIAlertView = UIAlertView(title: lang.uage("输入错误"), message: lang.uage("用户名不能少于3位"), delegate: nil, cancelButtonTitle: lang.uage("取消"))
            提示框.show()
        }
    }
    
    func 登录失败(返回信息:NSNotification) {
        结束工作中提示()
        let 错误信息:String = 返回信息.object as! String
        let 提示框:UIAlertView = UIAlertView(title: lang.uage("注册新用户失败"), message: 错误信息, delegate: nil, cancelButtonTitle: lang.uage("取消"))
        提示框.show()
    }
    
    func 登录成功(返回信息:NSNotification) {
        结束工作中提示()
        检查用户登录()
//        let 同步测试:UserSync = UserSync()
//        同步测试.下载同步信息数据()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func 结束工作中提示() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().postNotificationName("显示等待提示框通知", object: NSNumber(bool: false))
    }
    
    func 键盘收起按钮开关(开关:Bool) {
        if (开关 == true && self.view.frame.size.height < 1024) {
            self.navigationItem.rightBarButtonItem = 右上按钮
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (self.view.frame.origin.y == 0 && self.view.frame.size.height < 1024) {
            键盘收起按钮开关(true)
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
        键盘收起按钮开关(false)
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
