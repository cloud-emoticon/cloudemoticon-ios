//
//  CEViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/12.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class CEViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource { //, UIGestureRecognizerDelegate
    
//    let className:NSString = "[CEViewController]"

    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var sortTable: UITableView!
    @IBOutlet weak var sortBtn: UIBarButtonItem!
    @IBOutlet weak var ceTable: UITableView!
    
    var scrollEndWidth:CGFloat = 0
    var oldTapPointX:CGFloat = 0
    var touching:Bool = false
    var sortData:NSMutableArray = NSMutableArray.array()
    var ceData:NSMutableArray = NSMutableArray.array()
    
    override func viewDidLoad() {
        //Load UI
        if (isCanAutoHideSortView())
        {
            let panRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "edge:")
            self.view.addGestureRecognizer(panRecognizer)
            panRecognizer.maximumNumberOfTouches = 1
            panRecognizer.delegate = self
            scrollEndWidth = self.view.frame.width * 0.6
            sortView.frame = CGRectMake(0, 0, scrollEndWidth, self.view.frame.height)
            ceTable.frame = CGRectMake(sortView.frame.size.width, 0, self.view.frame.width, self.view.frame.height)
        }
        sortTable.tag = 100
        ceTable.tag = 101
        
//        else {
//            sortView.frame = CGRectMake(0, 0, self.view.frame.width * 0.3, self.view.frame.height)
//            ceTable.frame = CGRectMake(self.view.frame.width * 0.3, 0, self.view.frame.width * 0.7, self.view.frame.height)
//        }
        
        
        //Load Data
        sortTable.delegate = self
        sortTable.dataSource = self
        ceTable.delegate = self
        ceTable.dataSource = self
        
//        p_emodata
        if (p_emodata.count >= 3) {
            var y_emoarr:NSArray = p_emodata.objectAtIndex(3) as NSArray
//            let groupnames:NSMutableArray = NSMutableArray.array()
            sortData.removeAllObjects()
//            println(y_emoarr)
            for emogroup_o in y_emoarr
            {
                var emogroup:NSArray = emogroup_o as NSArray
                let groupname:NSString = emogroup.objectAtIndex(0) as NSString
                sortData.addObject(groupname)
            }
            sortTable.reloadData()
            if (sortData.count > 0) {
                sortTable.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
                openSortData(0)
            }
            
        } else {
            println("NODATA")
        }
}

    @IBAction func sortBtn(sender: UIBarButtonItem) {
//        if (isCanAutoHideSortView()) {
//            var x:CGFloat = 0
//            if (ceTable.frame.origin.x < scrollEndWidth * 0.5) {
//                x = scrollEndWidth
//            }
//            self.view.layer.removeAllAnimations()
//            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
//            UIView.animateWithDuration(0.25, animations: {
//                self.ceTable.frame = CGRectMake(x, self.ceTable.frame.origin.y, self.ceTable.frame.size.width, self.ceTable.frame.size.height)
//                })
//        }
        println(sortView.frame)
        println(sortTable.frame)
    }
    
    func openSortData(row:Int)
    {
        ceData.removeAllObjects()
        var y_emoarr:NSArray = p_emodata.objectAtIndex(3) as NSArray
        let emogroup_o:NSArray = y_emoarr.objectAtIndex(row) as NSArray
        ceData.addObjectsFromArray(emogroup_o)
        ceData.removeObjectAtIndex(0)
        ceTable.reloadData()
    }
    
    func edge(recognizer:UITapGestureRecognizer)
    {
        if (recognizer.state == UIGestureRecognizerState.Ended || recognizer.state == UIGestureRecognizerState.Cancelled || recognizer.state == UIGestureRecognizerState.Failed) {
            var tapPoint:CGPoint = recognizer.locationInView(self.view)
            oldTapPointX = 0
            var x:CGFloat = 0
            if (ceTable.frame.origin.x > scrollEndWidth * 0.5) {
                x = scrollEndWidth
            }
            touching = false
            self.view.layer.removeAllAnimations()
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.animateWithDuration(0.25, animations: {
                self.ceTable.frame = CGRectMake(x, self.ceTable.frame.origin.y, self.ceTable.frame.size.width, self.ceTable.frame.size.height)
                })
        } else {
            var tapPoint:CGPoint = recognizer.locationInView(self.view)
            var touchX:CGFloat = tapPoint.x
            if (isCanAutoHideSortView()) {
                let add:CGFloat = oldTapPointX - touchX
                var tableX:CGFloat = ceTable.frame.origin.x - add
                
                self.view.layer.removeAllAnimations()
                if (tableX > scrollEndWidth) {
                    tableX = scrollEndWidth
                } else if (tableX < 0) {
                    tableX = 0
                }
                oldTapPointX = tapPoint.x
                if (self.touching == true) {
                    self.ceTable.frame = CGRectMake(tableX, self.ceTable.frame.origin.y, self.ceTable.frame.size.width, self.ceTable.frame.size.height)
                }
            }
        }
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer!) -> Bool
    {
        touching = true
        var tapPoint:CGPoint = gestureRecognizer.locationInView(self.view)
        oldTapPointX = tapPoint.x
        return true
    }
    
    
    func isCanAutoHideSortView() -> Bool
    {
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone && self.view.frame.width < self.view.frame.height) {
            return true
        }
        return false
    }
    
    //表格数据
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int
    {
        return 1;
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        if (tableView.tag == 100) {
            return sortData.count
        } else {
            return ceData.count
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let CellIdentifier:NSString = "Cell"
        var cell:UITableViewCell? = sortTable.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
            cell!.selectionStyle = UITableViewCellSelectionStyle.Blue
        }
        if (tableView.tag == 100) {
            let groupname:NSString = sortData.objectAtIndex(indexPath.row) as NSString
            cell!.textLabel.text = groupname
        } else {
            let emoobj:NSArray = ceData.objectAtIndex(indexPath.row) as NSArray
            let emo:NSString = emoobj.objectAtIndex(0) as NSString
            cell!.textLabel.text = emo
            if (emoobj.count > 1) {
                let name:NSString = emoobj.objectAtIndex(1) as NSString
                cell!.detailTextLabel.text = name
            }
        }
        return cell;
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        if (tableView.tag == 100) {
            openSortData(indexPath.row)
            sortBtn(sortBtn)
        } else {
            
        }
    }
    
//    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
//    {
//        if (tableView.tag == 100) {
//            
//        } else {
//            
//        }
//    }
}
