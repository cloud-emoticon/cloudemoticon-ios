//
//  CETableViewCell.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/21.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

protocol CETableViewCellDelegate:NSObjectProtocol{
    func 单元格代理：点击滑出的按钮时(点击按钮的ID:Int, 单元格在表格中的位置:NSIndexPath)
    func 单元格代理：是否可以接收手势() -> Bool
}

class CETableViewCell: UITableViewCell, UIGestureRecognizerDelegate {
    
    enum cellMode:Int {
        case DEFAULT = 0
        case CEVIEWCONTROLLER = 1
    }
    var 单元格样式:cellMode = cellMode.DEFAULT
    let 滑出按钮A:UIButton = UIButton()
    let 滑出按钮B:UIButton = UIButton()
    let 按钮宽度:CGFloat = 60.0
    var 单元格在表格中的位置:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    var 代理:CETableViewCellDelegate?
    var 覆盖视图:UIView = UIView()
    var 主文字:UILabel = UILabel()
    var 手势中:Bool = false
    var 手势:UIPanGestureRecognizer = UIPanGestureRecognizer()
    var 手势起始位置X坐标:CGFloat = 0.0
//    var 右侧距离:CGFloat = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func 初始化单元格样式(nowmode:cellMode)
    {
        单元格样式 = nowmode
        if (单元格样式 == cellMode.CEVIEWCONTROLLER) {
            滑出按钮A.tag = 101
            滑出按钮B.tag = 102
            滑出按钮A.backgroundColor = UIColor.orangeColor()
            滑出按钮B.backgroundColor = UIColor.redColor()
            滑出按钮A.setTitle("收藏", forState: UIControlState.Normal)
            滑出按钮B.setTitle("分享", forState: UIControlState.Normal)
            滑出按钮A.addTarget(self, action: "点击滑出按钮:", forControlEvents: UIControlEvents.TouchUpInside)
            滑出按钮B.addTarget(self, action: "点击滑出按钮:", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(滑出按钮A)
            self.addSubview(滑出按钮B)
            self.addSubview(覆盖视图)
            覆盖视图.addSubview(主文字)
            手势 = UIPanGestureRecognizer(target: self, action: "手势执行:")
            手势.delegate = self
            覆盖视图.backgroundColor = UIColor.whiteColor()
            覆盖视图.addGestureRecognizer(手势)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "取消单元格左滑方法:", name: "取消单元格左滑通知", object: nil)
        }
    }
    
    func 取消单元格左滑方法(notification:NSNotification)
    {
        let 通知传值对象:AnyObject? = notification.object
        if (通知传值对象 == nil) {
            UIView.animateWithDuration(0.15, animations: {
                self.覆盖视图.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            })
        } else {
            let 当前单元格在表格中的位置:NSIndexPath = 通知传值对象 as NSIndexPath
            let 当前单元格在表格中的行:Int = 当前单元格在表格中的位置.row
            let 单元格在表格中的行:Int = 单元格在表格中的位置.row
            if (当前单元格在表格中的行 != 单元格在表格中的行) {
                UIView.animateWithDuration(0.15, animations: {
                    self.覆盖视图.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                })
            }
        }
    }
    
    func 点击滑出按钮(sender:UIButton)
    {
        let 点击按钮的ID:Int = sender.tag - 100
        代理?.单元格代理：点击滑出的按钮时(点击按钮的ID, 单元格在表格中的位置: 单元格在表格中的位置)
    }
    
    func 手势执行(recognizer:UIPanGestureRecognizer)
    {
        var 手指当前坐标:CGPoint = recognizer.locationInView(self)
        let 滑动最大X坐标:CGFloat = 0 - (按钮宽度 * 2)
        if (recognizer.state == UIGestureRecognizerState.Ended || recognizer.state == UIGestureRecognizerState.Cancelled || recognizer.state == UIGestureRecognizerState.Failed) {
            手势起始位置X坐标 = 0
            var x:CGFloat = 0
            if (覆盖视图.frame.origin.x < 滑动最大X坐标 * 0.5) {
                x = 滑动最大X坐标
            }
            手势中 = false
            self.layer.removeAllAnimations()
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.animateWithDuration(0.15, animations: {
                self.覆盖视图.frame = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height)
                }, completion: {
                    (Bool completion) in
                    if completion {
//                        self.菜单滑动中 = false
                    }
            })
        } else if (代理 != nil) {
            if (代理!.单元格代理：是否可以接收手势()) {
                var 手指当前X坐标:CGFloat = 手指当前坐标.x
                //if (isCanAutoHideSortView())
                let 手指移动距离:CGFloat = 手势起始位置X坐标 - 手指当前X坐标
                var 覆盖视图的新X坐标:CGFloat = 覆盖视图.frame.origin.x - 手指移动距离
                self.layer.removeAllAnimations()
                if (覆盖视图的新X坐标 < 滑动最大X坐标) {
                    覆盖视图的新X坐标 = 滑动最大X坐标
                } else if (覆盖视图的新X坐标 > 0) {
                    覆盖视图的新X坐标 = 0
                }
                手势起始位置X坐标 = 手指当前坐标.x
                if (self.手势中 == true) {
                    self.覆盖视图.frame = CGRectMake(覆盖视图的新X坐标, 0, self.frame.size.width, self.frame.size.height)
                }
            }
        }
    }
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer!) -> Bool
    {
//        if (覆盖视图.frame.origin.x != 0) {
//            菜单滑动中 = true
//        }
//        取消单元格左滑通知
        NSNotificationCenter.defaultCenter().postNotificationName("取消单元格左滑通知", object: self.单元格在表格中的位置)
        手势中 = true
        var 手指当前坐标:CGPoint = gestureRecognizer.locationInView(self)
        手势起始位置X坐标 = 手指当前坐标.x
        return true
    }
    
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool
    {
        if (代理 != nil) {
            return !代理!.单元格代理：是否可以接收手势()
        }
        return false
    }
    
    func 修正元素位置()
    {
        覆盖视图.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        滑出按钮A.frame = CGRectMake(self.frame.size.width - 按钮宽度, 0, 按钮宽度, self.frame.size.height)
        滑出按钮B.frame = CGRectMake(self.frame.size.width - 按钮宽度 * 2, 0, 按钮宽度, self.frame.size.height)
        主文字.frame = CGRectMake(20, 0, self.frame.size.width - 20, self.frame.size.height)
    }
}
