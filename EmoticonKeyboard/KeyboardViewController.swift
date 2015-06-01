//
//  KeyboardViewController.swift
//  EmoticonKeyboard
//
//  Created by 神楽坂雅詩 on 14/9/3.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UITableViewDelegate, UITableViewDataSource {

    var 表格视图: UITableView!
    var 当前数据数组:NSMutableArray = NSMutableArray()
    let 按钮文字数组:NSArray = ["🌐","历史","收藏","自定义","◀️","⏬"]
    let 按钮命令数组:NSArray = ["advanceToNextInputMode","历史按钮:","收藏按钮:","自定义按钮:","删除按钮","dismissKeyboard"]
    var 全部收藏数组:NSMutableArray = NSMutableArray()
    var 全部自定数组:NSMutableArray = NSMutableArray()
    var 全部历史数组:NSMutableArray = NSMutableArray()
    var 全部皮肤数组:NSMutableArray = NSMutableArray()
    var 功能按钮数组:NSMutableArray = NSMutableArray()
    let 模板按钮:UIButton = UIButton.buttonWithType(.System) as! UIButton
//    var 初始化提示:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

    override func updateViewConstraints() {
        super.updateViewConstraints()
//        NSLog("云颜文字键盘初始化1...")
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        NSLog("云颜文字键盘初始化2...")
//        初始化提示.frame = CGRectMake(0, 0, 30, 30)
//        self.view.addSubview(初始化提示)
//        var 初始化提示对齐方式1 = NSLayoutConstraint(item: 初始化提示, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
//        var 初始化提示对齐方式2 = NSLayoutConstraint(item: 初始化提示, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
//        self.view.addConstraints([初始化提示对齐方式1, 初始化提示对齐方式2])
//        let 初始化计时器:NSTimer = NSTimer(timeInterval: 0.5, target: self, selector: "初始化()", userInfo: nil, repeats: false)
//        初始化计时器.fire()
        初始化()
    }
    
    func 初始化() {
        初始化画面()
        初始化数据()
    }
    
    func 初始化画面()
    {
        self.view.backgroundColor = UIColor(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1)//172 179 190
        let 按钮数量:Int = 按钮文字数组.count
        
        //let 模板按钮:UIButton = UIButton.buttonWithType(.System) as! UIButton
        模板按钮.frame = CGRectMake(0, 0, 0, 0)
        模板按钮.sizeToFit()
        模板按钮.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(模板按钮)

        
//        if(UIDevice.currentDevice().orientation.isPortrait) {
//            表格视图 = UITableView(frame: CGRectMake(0, 0, 320, 165), style: .Plain)
//        } else {
//            表格视图 = UITableView(frame: CGRectMake(0, 0, 320, 89), style: .Plain)
//        }
        表格视图 = UITableView() //frame: , style: UITableViewStyle.Plain
        表格视图.setTranslatesAutoresizingMaskIntoConstraints(false)
        表格视图.delegate = self
        表格视图.dataSource = self
        表格视图.backgroundColor = UIColor.whiteColor()
        表格视图.showsVerticalScrollIndicator = false
        self.view.addSubview(表格视图)
        
        for i in 0...按钮文字数组.count - 1
        {
            let 按钮:UIButton = UIButton.buttonWithType(.System) as! UIButton
            var 上一个按钮:UIView = UIView()
            if (i > 0) {
                上一个按钮 = self.view.viewWithTag(100 + i - 1)!
            }
            按钮.setTitle(按钮文字数组.objectAtIndex(i) as? String, forState: .Normal)
            按钮.sizeToFit()
            按钮.setTranslatesAutoresizingMaskIntoConstraints(false)
            按钮.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            按钮.addTarget(self, action: Selector(按钮命令数组.objectAtIndex(i) as! String), forControlEvents: .TouchUpInside)
            if (i == 0){
                按钮.backgroundColor = UIColor(red: 172.0/255.0, green: 179.0/255.0, blue: 190.0/255.0, alpha: 1)
            } else {
                按钮.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
            }
            按钮.layer.cornerRadius = 4
            self.view.addSubview(按钮)
            按钮.titleLabel?.textAlignment = NSTextAlignment.Center
            按钮.tag = 100 + i
            功能按钮数组.addObject(按钮)
        }
        //切换按钮选中颜色(103)
        屏幕旋转通知()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "屏幕旋转通知", name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
    }
    
    func 修改方向(是竖屏:Bool) {
        let 布局器数组:[AnyObject] = self.view.constraints()
        self.view.removeConstraints(布局器数组)
//        let 全部控件:NSArray = NSArray(array: self.view.subviews)
//        for 控件 in self.view.subviews {
//            var 当前控件:UIView = 控件 as! UIView
//            当前控件.removeFromSuperview()
//        }
        
        var 表格视图横向对齐方式 = NSLayoutConstraint(item: 表格视图, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0)
        var 表格视图横向对齐方式2 = NSLayoutConstraint(item: 表格视图, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -0.0)
        var 表格视图纵向对齐方式 = NSLayoutConstraint(item: 表格视图, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 4)
        var 表格视图纵向对齐方式2 = NSLayoutConstraint(item: 表格视图, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 168)
        var 表格视图纵向对齐方式3 = NSLayoutConstraint(item: 表格视图, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 112)
        if (是竖屏) {
            self.view.addConstraints([表格视图横向对齐方式,表格视图纵向对齐方式,表格视图横向对齐方式2,表格视图纵向对齐方式2])
        } else {
            self.view.addConstraints([表格视图横向对齐方式,表格视图纵向对齐方式,表格视图横向对齐方式2,表格视图纵向对齐方式3])
        }
    
        for i in 0...按钮文字数组.count - 1 {
            let 当前按钮对象:AnyObject = 功能按钮数组.objectAtIndex(i)
            var 上一个按钮:UIView = UIView()
            if (i > 0) {
                上一个按钮 = self.view.viewWithTag(100 + i - 1)!
            }
            var 按钮:UIButton = 当前按钮对象 as! UIButton
            var 按钮高度 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 36)
            self.view.addConstraint(按钮高度)
            if (i == 0){
                var 按钮横向对齐方式 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 3.0)
                var 按钮纵向对齐方式 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: 表格视图, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 6)
                
                var 按钮宽度适应 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: (UIScreen.mainScreen().bounds.size.width - 31) / 6)
                self.view.addConstraints([按钮横向对齐方式, 按钮纵向对齐方式, 按钮宽度适应])
            } else if (i == 按钮文字数组.count - 1) {
                var 按钮横向对齐方式 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -3.0)
                var 按钮纵向对齐方式 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: 上一个按钮, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
                var 按钮宽度适应 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: 上一个按钮, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
                self.view.addConstraints([按钮横向对齐方式, 按钮纵向对齐方式, 按钮宽度适应])
            } else {
                var 按钮横向对齐方式 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: 上一个按钮, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 5.0)
                var 按钮纵向对齐方式 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: 上一个按钮, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
                var 按钮宽度适应 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: 上一个按钮, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
                self.view.addConstraints([按钮横向对齐方式, 按钮纵向对齐方式, 按钮宽度适应])
            }
        }
        
//        for 控件 in 全部控件 {
//            var 当前控件:UIView = 控件 as! UIView
//            self.view.addSubview(当前控件)
//        }
    }
    
    override func dismissKeyboard() {
        NSLog("收起键盘")
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.dismissKeyboard()
    }
    
    func 屏幕旋转通知() { //(通知信息:NSNotification) -> Int {
        //方法1：(╯‵□′)╯︵┻━┻
//        let 屏幕方向:UIInterfaceOrientation = UIApplication().statusBarOrientation
//        if (屏幕方向 == UIInterfaceOrientation.LandscapeLeft || 屏幕方向 == UIInterfaceOrientation.LandscapeRight) {
//            NSLog("横屏")
//        } else if (屏幕方向 == UIInterfaceOrientation.Portrait || 屏幕方向 == UIInterfaceOrientation.PortraitUpsideDown) {
//            NSLog("竖屏")
//        } else {
//            NSLog("错误")
//        }
        
        //方法2：(╯‵□′)╯︵┻━┻
//        if(UIDevice.currentDevice().orientation.isLandscape) {
//            NSLog("横屏")
//        } else if (UIDevice.currentDevice().orientation.isPortrait) {
//            NSLog("竖屏")
//        } else {
//            NSLog("错误")
//        }
        
        //方法3：(╯‵□′)╯︵┻━┻
//        if (self.view.frame.size.height < self.view.frame.size.width) {
//            NSLog("横屏")
//        } else {
//            NSLog("竖屏")
//        }
        
//        //方法4：( っ*'ω'*c)  QAQ
//        let 屏幕尺寸:CGSize = UIScreen.mainScreen().bounds.size
//        let 屏幕宽:CGFloat = 屏幕尺寸.width
//        let 键盘宽:CGFloat = self.view.frame.size.width
//        if (屏幕宽 == 键盘宽) {
//            NSLog("横屏")
//            修改方向(false)
//        } else {
//            NSLog("竖屏")
//            修改方向(true)
//        }
        //方法5： ( っ*'ω'*c)
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){
            //Keyboard is in Portrait
            修改方向(true)
        }
        else{
            //Keyboard is in Landscape
            修改方向(false)
        }
        
        
        //return 0
    }
    
    func 切换按钮选中颜色(当前按钮Tag:Int) {
        for 当前按钮对象 in 功能按钮数组 {
            var 当前按钮:UIButton = 当前按钮对象 as! UIButton
            if (当前按钮.tag != 当前按钮Tag) {
                当前按钮.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            } else {
                当前按钮.setTitleColor(UIColor.redColor() , forState: UIControlState.Normal)
            }
        }
    }
    
    func 历史按钮(sender:UIButton) {
        当前数据数组.removeAllObjects()
        切换按钮选中颜色(sender.tag)
        for 颜文字数组 in 全部历史数组 {
            当前数据数组.addObject(颜文字数组.objectAtIndex(0))
        }
        按钮选择(sender)
    }
    
    func 收藏按钮(sender:UIButton) {
        当前数据数组.removeAllObjects()
        切换按钮选中颜色(sender.tag)
        for 颜文字数组 in 全部收藏数组 {
            当前数据数组.addObject(颜文字数组.objectAtIndex(0))
        }
        按钮选择(sender)
    }
    func 自定义按钮(sender:UIButton) {
        当前数据数组.removeAllObjects()
        切换按钮选中颜色(sender.tag)
        for 颜文字数组 in 全部自定数组 {
            当前数据数组.addObject(颜文字数组.objectAtIndex(0))
        }
        按钮选择(sender)
    }
    
    func 按钮选择(sender:UIButton)
    {
        for i in 0...按钮文字数组.count - 1 {
            let 当前按钮:UIButton = self.view.viewWithTag(100 + i) as! UIButton
            if (当前按钮.tag == sender.tag) {
                当前按钮.backgroundColor = UIColor.whiteColor()
//                当前按钮.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0,0,0,0.3])
            } else {
                if (i == 0){
                    当前按钮.backgroundColor = UIColor(red: 172.0/255.0, green: 179.0/255.0, blue: 190.0/255.0, alpha: 1)
                } else {
                当前按钮.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
                }
//                当前按钮.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0,0,0,0.0])
            }
        }
        表格视图.reloadData()
    }
    
    func 删除按钮() {
        (self.textDocumentProxy as! UITextDocumentProxy as UIKeyInput).deleteBackward()
    }
    
    func 初始化数据()
    {
//        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CloudEmoticon")!
//        containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
//        var value:NSString? = NSString(contentsOfURL: containerURL, encoding: NSUTF8StringEncoding, error: nil)
//        if(value != nil && value != "" && value != "[[],[],[]]") {
//            let 全部数据数组:NSArray = ArrayString().json2array(value!)
//            全部收藏数组.addObjectsFromArray(全部数据数组.objectAtIndex(0) as! [AnyObject])
//            全部自定数组.addObjectsFromArray(全部数据数组.objectAtIndex(1) as! [AnyObject])
//            全部历史数组.addObjectsFromArray(全部数据数组.objectAtIndex(2) as! [AnyObject])
//            收藏按钮(self.view.viewWithTag(102) as! UIButton)
//        } else {
//            NSLog("键盘没有数据：\(value)。")
//        }
        let 组数据读写:AppGroupIO = AppGroupIO()
        var 数据数组:NSArray? = 组数据读写.读取设置UD模式()
        if (数据数组 != nil) {
            全部收藏数组.addObjectsFromArray(数据数组!.objectAtIndex(0) as! [AnyObject])
            全部自定数组.addObjectsFromArray(数据数组!.objectAtIndex(1) as! [AnyObject])
            全部历史数组.addObjectsFromArray(数据数组!.objectAtIndex(2) as! [AnyObject])
            全部皮肤数组.addObjectsFromArray(数据数组!.objectAtIndex(3) as! [AnyObject])
            收藏按钮(self.view.viewWithTag(102) as! UIButton)
        } else {
            NSLog("键盘没有数据：\(数据数组)。")
        }
    }
    
//    override func viewDidAppear(animated: Bool) {
//        初始化数据()
//        表格视图.reloadData()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
//        var textColor: UIColor
//        var buttonColor: UIColor
//        var proxy = self.textDocumentProxy as UITextDocumentProxy
//        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
//            textColor = UIColor.whiteColor()
//            buttonColor = UIColor.cyanColor()
//        } else {
//            textColor = UIColor.blackColor()
//            buttonColor = UIColor.blueColor()
//        }
//        
//        for i in 0...按钮文字数组.count - 1 {
//            let 当前按钮:UIButton = self.view.viewWithTag(100 + i) as UIButton
//            当前按钮.setTitleColor(buttonColor, forState: .Normal)
//        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let 要复制的颜文字:NSString = 当前数据数组.objectAtIndex(indexPath.row) as! NSString
        (self.textDocumentProxy as! UITextDocumentProxy as UIKeyInput).insertText(要复制的颜文字 as String)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //for 当前历史条目对象 in 全部历史数组 {
        for (var i:Int = 0; i < 全部历史数组.count; i++) {
//            if (i >= 全部历史数组.count) {
//                break
//            }
            let 当前历史条目对象:AnyObject = 全部历史数组.objectAtIndex(i)
            let 当前历史条目数组:NSArray = 当前历史条目对象 as! NSArray
            let 当前历史条目:NSString = 当前历史条目数组.objectAtIndex(0) as! NSString
            //NSLog("当前历史条目=\(当前历史条目),要复制的颜文字=\(要复制的颜文字)")
            if (当前历史条目.isEqualToString(要复制的颜文字 as String)) {
                //NSLog("【删除】\n")
                全部历史数组.removeObjectAtIndex(i)
                if (i > 0) {
                    i--
                }
            }
        }
        全部历史数组.insertObject([要复制的颜文字,""], atIndex: 0)
        while (true) {
            if (全部历史数组.count > 50) {
                全部历史数组.removeLastObject()
            } else {
                break
            }
        }
        保存数据到主程序()
    }
    
    func 保存数据到主程序()
    {
        let 要保存的数据:NSArray = [全部收藏数组,全部自定数组,全部历史数组,全部皮肤数组]
//        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CloudEmoticon")!
//        containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
//        let 要保存的数据文本:NSString = ArrayString().array2json(要保存的数据)
//        要保存的数据文本.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
//        NSLog("Group写入操作")
        let 组数据读写:AppGroupIO = AppGroupIO()
        组数据读写.写入设置UD模式(要保存的数据)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let CellIdentifier:NSString = "Cell"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier as String) as? UITableViewCell
        cell?.textLabel?.lineBreakMode = NSLineBreakMode.ByCharWrapping
        cell?.textLabel?.numberOfLines = 0
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier as String)
            cell!.textLabel?.textAlignment = NSTextAlignment.Left
            cell!.selectionStyle = UITableViewCellSelectionStyle.Default
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        if (当前数据数组.count < 1) {
            cell?.textLabel?.text = "<错误数据>"
        } else {
            cell?.textLabel?.text = 当前数据数组.objectAtIndex(indexPath.row) as? String
        }
        return cell!
    }
    
    func 计算单元格高度(要显示的文字:NSString, 字体大小:CGFloat, 单元格宽度:CGFloat) -> CGFloat
    {
        var 高度测试虚拟标签:UILabel = UILabel(frame: CGRectMake(0, 0, 单元格宽度, 0))
        高度测试虚拟标签.font = UIFont.systemFontOfSize(字体大小)
        高度测试虚拟标签.text = NSString(string: 要显示的文字) as String
        高度测试虚拟标签.lineBreakMode = NSLineBreakMode.ByCharWrapping
        高度测试虚拟标签.numberOfLines = 0
        var 计算后尺寸:CGSize = 高度测试虚拟标签.sizeThatFits(CGSizeMake(单元格宽度,CGFloat.max))
        计算后尺寸.height = ceil(计算后尺寸.height)
        return 计算后尺寸.height
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (当前数据数组.count > 0) {
            var 文字高度:CGFloat = 44
            let 主文字内容 = 当前数据数组.objectAtIndex(indexPath.row) as! NSString
            let 主文字框高度:CGFloat = 计算单元格高度(主文字内容, 字体大小: 17, 单元格宽度: tableView.frame.width - 20) + 8
            文字高度 = 主文字框高度 + 15
            
            if (文字高度 < 44) {
                return 44
            } else {
                return 文字高度
            }
        }
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 当前数据数组.count;
    }
}
