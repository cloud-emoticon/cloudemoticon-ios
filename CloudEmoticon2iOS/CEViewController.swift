//
//  CEViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/12.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class CEViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate { //, UIGestureRecognizerDelegate
    
//    let className:NSString = "[CEViewController]"

//    @IBOutlet weak var sortView: UIView!
//    @IBOutlet weak var sortTable: UITableView!
    @IBOutlet weak var sortBtn: UIBarButtonItem!
    @IBOutlet weak var scoreBtn: UIBarButtonItem!
//    @IBOutlet weak var sourceBtn: UIBarButtonItem!
//    @IBOutlet weak var ceTable: UITableView!
    
//    var sortView:UIView = UIView()
    var sortTable:UITableView = UITableView()
    var ceTable:UITableView = UITableView()
    var userview:UIView = UIView()
    var username:UILabel = UILabel()
    
    var userimg:UIImageView = UIImageView(image:UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("nouserimg", ofType: "jpg")))
    
    var scrollEndWidth:CGFloat = 0
    var oldTapPointX:CGFloat = 0
    var touching:Bool = false
    var sortData:NSMutableArray = NSMutableArray.array()
    var ceData:NSMutableArray = NSMutableArray.array()
    
    override func viewDidLoad() {
        
        //Load UI
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "transition:", name: "transition", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadwebdataokf2:", name: "loaddataok2", object: nil)
        
        sortTable.tag = 100
        ceTable.tag = 101
        
        
        sortTable.frame = CGRectMake(0, 0, self.view.frame.size.width * 0.3, self.view.frame.size.height)
        if (isCanAutoHideSortView())
        {
            let panRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "edge:")
            self.view.addGestureRecognizer(panRecognizer)
            panRecognizer.maximumNumberOfTouches = 1
            panRecognizer.delegate = self
            self.view.backgroundColor = UIColor.orangeColor()
            scrollEndWidth = self.view.frame.width * 0.6
            sortTable.frame = CGRectMake(0, 0, scrollEndWidth, self.view.frame.size.height)
        }
        
        ceTable.frame = CGRectMake(sortTable.frame.size.width, 0, self.view.frame.width, self.view.frame.height)
        
        userview.frame = CGRectMake(0, 0, sortTable.frame.size.width, 120)
        
        userimg.frame = CGRectMake(10, 20, 80, 80)
        userview.addSubview(userimg)
        username.frame = CGRectMake(userimg.frame.origin.x + userimg.frame.size.width + 5, userimg.frame.origin.y, userview.frame.size.width - userimg.frame.origin.x - userimg.frame.size.width - 5, userimg.frame.size.height)
        username.text = "未登录"
        username.font = UIFont.systemFontOfSize(13)
        userview.addSubview(username)
        
        sortTable.tableHeaderView = userview
        
//        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.automaticallyAdjustsScrollViewInsets = false
        if (self.view.frame.width < self.view.frame.height) {
            sortTable.contentInset = UIEdgeInsetsMake(64, 0, 48, 0)
        } else {
            sortTable.contentInset = UIEdgeInsetsMake(0, 0, 48, 0)
        }
        
        ceTable.contentInset = sortTable.contentInset
        self.view.addSubview(sortTable)
        self.view.addSubview(ceTable)
        
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
        loadData()
}
    
    func loadData()
    {
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
    
    func loadwebdataokf2(notification:NSNotification)
    {
        let urlArr:NSArray = notification.object as NSArray
        let urlStr:NSString = urlArr.objectAtIndex(0) as NSString
        let downloadModeIntNB:NSNumber = urlArr.objectAtIndex(1) as NSNumber
        let downloadModeInt:Int = downloadModeIntNB.integerValue
        let nowDownloadMode:NetDownloadTo = NetDownloadTo.fromRaw(downloadModeInt)!
        if (nowDownloadMode == NetDownloadTo.CLOUDEMOTICON) {
            loadData()
        } else if (nowDownloadMode == NetDownloadTo.SOURCEMANAGER) {
            if (p_storeIsOpen == false) {
                let source:ScoreTableViewController = ScoreTableViewController(coder: nil)
                self.navigationController.pushViewController(source, animated: true)
                source.addSource(urlStr, isStore: true)
            }
        }
    }
    
    @IBAction func sortBtn(sender: UIBarButtonItem) {
        if (isCanAutoHideSortView()) {
            var x:CGFloat = 0
            if (ceTable.frame.origin.x < scrollEndWidth * 0.5) {
                x = scrollEndWidth
            }
            self.view.layer.removeAllAnimations()
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.animateWithDuration(0.25, animations: {
                self.ceTable.frame = CGRectMake(x, self.ceTable.frame.origin.y, self.ceTable.frame.size.width, self.ceTable.frame.size.height)
                })
        }
    }
    
//    @IBAction func sourceBtn(sender: UIBarButtonItem) {
//        let source:ScoreTableViewController = ScoreTableViewController.alloc()
//        self.navigationController.pushViewController(source, animated: true)
//    }
    
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
    
//    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView!
//    {
////        if (tableView.tag == 100) {
//        println("return userview")
//            return userview
////        } else {
////            return UIView()
////        }
//    }
    
    func transition(notification:NSNotification)
    {
        println("收到屏幕旋转")
        let newScreenSizeArr:NSArray = notification.object as NSArray
        let newScreenSize:CGSize = CGSizeMake(newScreenSizeArr.objectAtIndex(0) as CGFloat, newScreenSizeArr.objectAtIndex(1) as CGFloat)
        
        sortTable.frame = CGRectMake(0, 0, scrollEndWidth, newScreenSize.height)
        ceTable.frame = CGRectMake(sortTable.frame.size.width, 0, newScreenSize.width, newScreenSize.height)
        
        if (newScreenSize.width < newScreenSize.height) {
            sortTable.contentInset = UIEdgeInsetsMake(64, 0, 48, 0)
        } else {
            sortTable.contentInset = UIEdgeInsetsMake(32, 0, 48, 0)
        }
        ceTable.contentInset = sortTable.contentInset
    }
    
//    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
//    {
//        if (tableView.tag == 100) {
//             、、
//        } else {
//            
//        }
//    }
}
