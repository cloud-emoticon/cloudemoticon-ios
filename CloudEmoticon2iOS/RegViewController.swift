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
    var 右上按钮: UIBarButtonItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = lang.uage("注册")
        reset.setTitle(lang.uage("重置"), for: UIControl.State())
        reg.setTitle(lang.uage("注册"), for: UIControl.State())
        let 背景色:UIColor = UIColor(red: 1, green: 0.79215, blue: 0.86274, alpha: 1)
        self.navigationController?.view.backgroundColor = 背景色
        self.view.backgroundColor = 背景色
        右上按钮 = UIBarButtonItem(title: lang.uage("关闭键盘"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(RegViewController.关闭软键盘))
        邮箱输入框.delegate = self
        用户名输入框.delegate = self
        密码输入框.delegate = self
        确认密码输入框.delegate = self
        // Do any additional setup after loading the view.
        //  <测试用>
        邮箱输入框.text = "cxchope@163.com"
        用户名输入框.text = "yashitest"
        密码输入框.text = "123456"
        确认密码输入框.text = 密码输入框.text
        //  </测试用>
    }
    
    @IBAction func 注册按钮点击(_ sender: UIButton) {
        let 输入的用户名:NSString = 用户名输入框.text! as NSString
        if (输入的用户名.length >= 3) {
            if (检查是否为邮箱(邮箱输入框.text!)) {
                let 输入的密码:NSString = 密码输入框.text! as NSString
                if (输入的密码.length >= 6) {
                    if (输入的密码.isEqual(to: 确认密码输入框.text!)) {
                        //继续
                        NotificationCenter.default.addObserver(self, selector: #selector(RegViewController.注册失败(_:)), name: NSNotification.Name(rawValue: "P用户:注册失败"), object: nil)
                        NotificationCenter.default.addObserver(self, selector: #selector(RegViewController.注册成功(_:)), name: NSNotification.Name(rawValue: "P用户:注册成功"), object: nil)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "显示等待提示框通知"), object: NSNumber(value: true as Bool))
                        //全局_Parse读写.用户注册(用户名输入框.text!, 密码: 密码输入框.text!, 邮箱: 邮箱输入框.text!)
                    } else {
                        let 提示框:UIAlertView = UIAlertView(title: lang.uage("输入错误"), message: lang.uage("两次输入的密码不一致"), delegate: nil, cancelButtonTitle: lang.uage("取消"))
                        提示框.show()
                    }
                } else {
                    let 提示框:UIAlertView = UIAlertView(title: lang.uage("输入错误"), message: lang.uage("密码至少要6位"), delegate: nil, cancelButtonTitle: lang.uage("取消"))
                    提示框.show()
                }
            } else {
                let 提示框:UIAlertView = UIAlertView(title: lang.uage("输入错误"), message: lang.uage("不是有效的电子邮件地址"), delegate: nil, cancelButtonTitle: lang.uage("取消"))
                提示框.show()
            }
        } else {
            let 提示框:UIAlertView = UIAlertView(title: lang.uage("输入错误"), message: lang.uage("用户名不能少于3位"), delegate: nil, cancelButtonTitle: lang.uage("取消"))
            提示框.show()
        }
    }
    
    @objc func 注册失败(_ 返回信息:Notification) {
        结束工作中提示()
        let 错误信息:String = 返回信息.object as! String
        let 提示框:UIAlertView = UIAlertView(title: lang.uage("注册新用户失败"), message: 错误信息, delegate: nil, cancelButtonTitle: lang.uage("取消"))
        提示框.show()
    }
    
    @objc func 注册成功(_ 返回信息:Notification) {
        结束工作中提示()
        检查用户登录()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func 结束工作中提示() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "显示等待提示框通知"), object: NSNumber(value: false as Bool))
    }
    
    func 键盘收起按钮开关(_ 开关:Bool) {
        if (开关 == true && self.view.frame.size.height < 1024) {
            self.navigationItem.rightBarButtonItem = 右上按钮
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func 重置按钮(_ sender: AnyObject) {
        邮箱输入框.text = ""
        用户名输入框.text = ""
        密码输入框.text = ""
        确认密码输入框.text = ""
    }
    
    @objc func 关闭软键盘() {
        邮箱输入框.resignFirstResponder()
        用户名输入框.resignFirstResponder()
        密码输入框.resignFirstResponder()
        确认密码输入框.resignFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (self.view.frame.origin.y == 0 && self.view.frame.size.height < 1024) {
            键盘收起按钮开关(true)
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.view.frame.origin.y = 0 - textField.frame.origin.y + self.navigationController!.navigationBar.frame.size.height + 25
                //self.view.frame.origin.y = 0 - self.view.frame.size.height * 0.25
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (邮箱输入框.isFirstResponder) {
            用户名输入框.becomeFirstResponder()
        } else if (用户名输入框.isFirstResponder) {
            密码输入框.becomeFirstResponder()
        } else if (密码输入框.isFirstResponder) {
            确认密码输入框.becomeFirstResponder()
        } else if (确认密码输入框.isFirstResponder) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        键盘收起按钮开关(false)
        if (self.view.frame.origin.y < 0 && self.view.frame.size.height < 1024) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.view.frame.origin.y = 0
            })
        }
    }
    
    func 检查是否为邮箱(_ 邮件地址:String) -> Bool {
        let 格式表达式:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let 格式校验器:NSPredicate = NSPredicate(format: "SELF MATCHES%@",格式表达式)
        let 判断结果:Bool = 格式校验器.evaluate(with: 邮件地址)
        return 判断结果
    }
}
