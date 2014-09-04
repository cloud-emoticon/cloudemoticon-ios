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
    var 当前数据数组:NSMutableArray = NSMutableArray.array()
    let 按钮文字数组:NSArray = ["输入法","收藏","自定","历史","删除","收起"]

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let 按钮数量:Int = 按钮文字数组.count
        let 每个按钮宽度:CGFloat = (UIScreen.mainScreen().bounds.size.width - 10.0) / CGFloat(按钮数量);
        
        let 表格视图Y坐标:CGFloat = 40.0
//        表格视图 = UITableView() //frame: , style: UITableViewStyle.Plain
//        表格视图.setTranslatesAutoresizingMaskIntoConstraints(true)
//        表格视图.delegate = self
//        表格视图.dataSource = self
//        表格视图.backgroundColor = UIColor.clearColor()
//        self.view.addSubview(表格视图)
//        var 表格视图横向对齐方式 = NSLayoutConstraint(item: 表格视图, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0)
//        var 表格视图纵向对齐方式 = NSLayoutConstraint(item: 表格视图, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 表格视图Y坐标)
        
//        表格视图.frame = CGRectMake(0, 表格视图Y坐标, UIScreen.mainScreen().bounds.size.width, 216 - 表格视图Y坐标)
//        self.view.addConstraints([表格视图横向对齐方式,表格视图纵向对齐方式])
        
        for i in 0...按钮文字数组.count - 1
        {
            let 按钮:UIButton = UIButton.buttonWithType(.System) as UIButton
//            let one:UIButton = UIButton.buttonWithType(.System) as UIButton
            
            var 上一个按钮:UIView? = nil
            if (i > 0) {
                上一个按钮? = self.view.viewWithTag(100 + i - 1)!
            }
            按钮.setTitle(按钮文字数组.objectAtIndex(i) as NSString, forState: .Normal)
//            按钮.sizeToFit()
            按钮.setTranslatesAutoresizingMaskIntoConstraints(false)
//            按钮.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
            按钮.backgroundColor = UIColor.lightGrayColor()
            self.view.addSubview(按钮)
            let 按钮X坐标:CGFloat = 5.0 + 每个按钮宽度 * CGFloat(i)
            
            按钮.titleLabel?.textAlignment = NSTextAlignment.Center
            按钮.tag = 100 + i
//            按钮.frame = CGRectMake(按钮X坐标, 0.0, 每个按钮宽度, 表格视图Y坐标)
            设置坐标(按钮, X坐标: 按钮X坐标, Y坐标: 0.0, 宽度: 每个按钮宽度, 高度: 表格视图Y坐标, 上一个按钮: 上一个按钮 as UIButton?)
        }
        
        for i in 1...30
        {
            当前数据数组.addObject("\(i)")
        }
//        表格视图.reloadData()
    }
    
    func 设置坐标(要调整的视图:AnyObject, X坐标 x:CGFloat, Y坐标 y:CGFloat, 宽度 w:CGFloat, 高度 h:CGFloat, 上一个按钮 b:UIButton?)
    {
        var 按钮横向对齐方式 = NSLayoutConstraint(item: 要调整的视图, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: b, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 1.0)
        var 按钮纵向对齐方式 = NSLayoutConstraint(item: 要调整的视图, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: b, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: y)
        var 按钮宽度 = NSLayoutConstraint(item: 要调整的视图, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: w)
        var 按钮高度 = NSLayoutConstraint(item: 要调整的视图, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: h)
        self.view.addConstraints([按钮横向对齐方式, 按钮纵向对齐方式]) //
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
        cell?.textLabel?.text = 当前数据数组.objectAtIndex(indexPath.row) as NSString
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 当前数据数组.count;
    }
}
