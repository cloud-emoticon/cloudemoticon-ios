//
//  KeyboardViewController.swift
//  EmoticonKeyboard
//
//  Created by 神楽坂雅詩 on 14/9/3.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UITableViewDelegate, UITableViewDataSource {

//    var 按钮1: UIButton!
    var 表格视图: UITableView!
    var 当前数据数组:NSArray = NSArray.array()
    let 按钮文字数组:NSArray = ["输入法","历史","收藏","自定义","删除","收起"]
    var 收藏夹数组:NSMutableArray = NSMutableArray.array()
    var 自定义数组:NSMutableArray = NSMutableArray.array()
    var 历史记录数组:NSMutableArray = NSMutableArray.array()

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        初始化画面()
        初始化数据()
    }
    
    func 初始化画面()
    {
        self.view.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1)
        let 按钮数量:Int = 按钮文字数组.count
        表格视图 = UITableView() //frame: , style: UITableViewStyle.Plain
        表格视图.setTranslatesAutoresizingMaskIntoConstraints(false)
        表格视图.delegate = self
        表格视图.dataSource = self
        表格视图.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(表格视图)
        
        var 表格视图横向对齐方式 = NSLayoutConstraint(item: 表格视图, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0)
        var 表格视图横向对齐方式2 = NSLayoutConstraint(item: 表格视图, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0)
        var 表格视图纵向对齐方式 = NSLayoutConstraint(item: 表格视图, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 1)
        var 表格视图纵向对齐方式2 = NSLayoutConstraint(item: 表格视图, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 179)
        var 表格视图纵向对齐方式3 = NSLayoutConstraint(item: 表格视图, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 103)
        if(self.interfaceOrientation.isPortrait) {
            self.view.addConstraints([表格视图横向对齐方式,表格视图纵向对齐方式,表格视图横向对齐方式2,表格视图纵向对齐方式2])
        } else {
            self.view.addConstraints([表格视图横向对齐方式,表格视图纵向对齐方式,表格视图横向对齐方式2,表格视图纵向对齐方式3])
        }
        
        for i in 0...按钮文字数组.count - 1
        {
            let 按钮:UIButton = UIButton.buttonWithType(.System) as UIButton
            let 模板按钮:UIButton = UIButton.buttonWithType(.System) as UIButton
            模板按钮.frame = CGRectMake(0, 0, 0, 0)
            模板按钮.sizeToFit()
            模板按钮.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.view.addSubview(模板按钮)
            var 上一个按钮:UIView = UIView()
            if (i > 0) {
                上一个按钮 = self.view.viewWithTag(100 + i - 1)!
            }
            按钮.setTitle(按钮文字数组.objectAtIndex(i) as NSString, forState: .Normal)
            按钮.sizeToFit()
            按钮.setTranslatesAutoresizingMaskIntoConstraints(false)
            //            按钮.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
            按钮.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(按钮)
//            按钮.layer.borderWidth = 1
//            按钮.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0,0,0,0.3])
            按钮.titleLabel?.textAlignment = NSTextAlignment.Center
            按钮.tag = 100 + i
            
            if (i == 0){
                var 按钮横向对齐方式 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 5.0)
                var 按钮纵向对齐方式 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: 表格视图, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 2)
                var 按钮宽度适应 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: 模板按钮, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 20.7)
                self.view.addConstraints([按钮横向对齐方式, 按钮纵向对齐方式, 按钮宽度适应])
            } else if (i == 按钮文字数组.count - 1) {
                var 按钮横向对齐方式 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -5.0)
                var 按钮纵向对齐方式 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: 上一个按钮, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
                var 按钮宽度适应 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: 上一个按钮, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
                self.view.addConstraints([按钮横向对齐方式, 按钮纵向对齐方式, 按钮宽度适应])
            } else {
                var 按钮横向对齐方式 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: 上一个按钮, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 1.0)
                var 按钮纵向对齐方式 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: 上一个按钮, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
                var 按钮宽度适应 = NSLayoutConstraint(item: 按钮, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: 上一个按钮, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
                self.view.addConstraints([按钮横向对齐方式, 按钮纵向对齐方式, 按钮宽度适应])
            }
        }
    }
    
    func 历史按钮() {
        
    }
    
    func 初始化数据()
    {
        var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CE2Keyboard")!
        containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
        var value:NSString? = NSString.stringWithContentsOfURL(containerURL, encoding: NSUTF8StringEncoding, error: nil)
        if(value != nil && value != "") {
            let 全部数据数组:NSArray = ArrayString().json2array(value!)
            let 全部收藏数组:NSArray = 全部数据数组.objectAtIndex(0) as NSArray
            for 颜文字数组 in 全部收藏数组 {
                收藏夹数组.addObject(颜文字数组.objectAtIndex(0))
            }
            let 全部自定数组:NSArray = 全部数据数组.objectAtIndex(1) as NSArray
            for 颜文字数组 in 全部自定数组 {
                自定义数组.addObject(颜文字数组.objectAtIndex(0))
            }
            
            当前数据数组 = 收藏夹数组
            表格视图.reloadData()
        } else {
            println("没有数据")
        }
    }
    
    func deleteBackword()
    {
        self.textDocumentProxy
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        var textColor: UIColor
        var buttonColor: UIColor
        var proxy = self.textDocumentProxy as UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
            buttonColor = UIColor.cyanColor()
        } else {
            textColor = UIColor.blackColor()
            buttonColor = UIColor.blueColor()
        }
        
        for i in 0...按钮文字数组.count-1 {
            let 当前按钮:UIButton = self.view.viewWithTag(100 + i) as UIButton
            当前按钮.setTitleColor(buttonColor, forState: .Normal)
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let CellIdentifier:NSString = "Cell"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)
            cell!.textLabel?.textAlignment = NSTextAlignment.Center
            cell!.selectionStyle = UITableViewCellSelectionStyle.Default
            cell!.accessoryType = UITableViewCellAccessoryType.None
            cell!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.01)
        }
        println(当前数据数组)
        cell?.textLabel?.text = 当前数据数组.objectAtIndex(indexPath.row) as NSString
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 当前数据数组.count;
    }
}
