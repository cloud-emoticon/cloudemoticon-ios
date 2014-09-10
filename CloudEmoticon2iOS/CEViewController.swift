//
//  CEViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/12.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class CEViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UIScrollViewDelegate, ScoreTableViewControllerDelegate, CETableViewCellDelegate, UITableViewDataSource { //, UIGestureRecognizerDelegate

    @IBOutlet weak var sortBtn: UIBarButtonItem!
    @IBOutlet weak var scoreBtn: UIBarButtonItem!

    var 分类表格:UITableView = UITableView()
    var 颜文字表格:UITableView = UITableView()
    var 颜文字表格背景:UIImageView = UIImageView()
//    var 单元格高度:NSMutableArray = NSMutableArray.array()
    var 当前单元格高度:CGFloat = 0
    var userview:UIView = UIView()
    var username:UILabel = UILabel()
    var 下拉刷新提示:UILabel? = nil
    var 表格初始滚动位置:CGFloat = 0
    var 下拉刷新动作中:Bool = false
    var 菜单滑动中:Bool = false
    var 当前滚动中表格标识:Int = 0
    
    var userimg:UIImageView = UIImageView(image:UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("nouserimg", ofType: "jpg")!))
    
    var 滑动最大X坐标:CGFloat = 0
    var 手势起始位置X坐标:CGFloat = 0
    var 手势中:Bool = false
    var sortData:NSMutableArray = NSMutableArray.array()
    var ceData:NSMutableArray = NSMutableArray.array()
    
    @IBOutlet weak var bgpview: UIImageView!
    
    func language()
    {
        scoreBtn.title = lang.uage("源管理")
        self.title = lang.uage("云颜文字")
    }
    
    override func viewDidAppear(animated: Bool) {
        let bg:UIImage? = UIImage(contentsOfFile: userbgimgfullpath)
        
        if(bg != nil){
            bgimage = bg!
        }
        bgpview.image = bgimage
        bgpview.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    override func viewDidLoad() {
    
        //Load UI
        self.title = lang.uage("云颜文字")
        载入视图()
        
        //Load Data
        分类表格.delegate = self
        分类表格.dataSource = self
        颜文字表格.delegate = self
        颜文字表格.dataSource = self
        载入数据(NetDownloadTo.CLOUDEMOTICON)
        
        self.language()
}
    
    func 载入视图() {
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "widget2.png"), forBarMetrics: UIBarMetrics.Default)
        sortBtn.title = lang.uage("分类")
        
        let bg:UIImage? = UIImage(contentsOfFile: userbgimgfullpath)
        
        if(bg != nil){
            bgimage = bg!
        }
        bgpview.image = bgimage
        bgpview.contentMode = UIViewContentMode.ScaleAspectFill
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "transition:", name: "transition", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadwebdataokf2:", name: "loaddataok2", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "time:", name: "loaddataok", object: nil)
        
        分类表格.tag = 100
        颜文字表格.tag = 101
        
        分类表格.frame = CGRectMake(0, 0, self.view.frame.size.width * 0.3, self.view.frame.size.height)
        if (isCanAutoHideSortView())
        {
            let panRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "手势执行:")
            self.view.addGestureRecognizer(panRecognizer)
            panRecognizer.maximumNumberOfTouches = 1
            panRecognizer.delegate = self
            滑动最大X坐标 = self.view.frame.width * 0.6
            分类表格.frame = CGRectMake(0, 0, 滑动最大X坐标, self.view.frame.size.height)
            颜文字表格.frame = CGRectMake(分类表格.frame.size.width, 0, self.view.frame.width, self.view.frame.height)
        } else {
            sortBtn.title = ""
            滑动最大X坐标 = self.view.frame.width * 0.3
            分类表格.frame = CGRectMake(0, 0, 滑动最大X坐标, self.view.frame.size.height)
            颜文字表格.frame = CGRectMake(分类表格.frame.size.width, 0, self.view.frame.width - 分类表格.frame.size.width, self.view.frame.height)
        }
        
        颜文字表格背景.frame = 颜文字表格.frame
        颜文字表格背景.image = bgpview.image
        颜文字表格背景.backgroundColor = UIColor.whiteColor()
        颜文字表格背景.contentMode = UIViewContentMode.ScaleAspectFill
        颜文字表格背景.layer.masksToBounds = true
        
        userview.frame = CGRectMake(0, 0, 分类表格.frame.size.width, 120)
        userimg.frame = CGRectMake(10, 20, 80, 80)
        
        userview.addSubview(userimg)
        username.frame = CGRectMake(userimg.frame.origin.x + userimg.frame.size.width + 5, userimg.frame.origin.y, userview.frame.size.width - userimg.frame.origin.x - userimg.frame.size.width - 5, userimg.frame.size.height)
        username.text = lang.uage("未登录")
        username.font = UIFont.systemFontOfSize(13)
        
        userview.addSubview(username)
        
        分类表格.tableHeaderView = userview
        
        //        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.automaticallyAdjustsScrollViewInsets = false
        if (self.view.frame.width < self.view.frame.height || UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
            分类表格.contentInset = UIEdgeInsetsMake(64, 0, 48, 0)
        } else {
            分类表格.contentInset = UIEdgeInsetsMake(32, 0, 48, 0)
        }
        
        颜文字表格.contentInset = 分类表格.contentInset
        
        颜文字表格.layer.shadowColor = UIColor.grayColor().CGColor
        颜文字表格.layer.shadowOffset = CGSizeMake(-5, 0)
        颜文字表格.layer.shadowOpacity = 0.9
        颜文字表格.layer.masksToBounds = false
        
        分类表格.alpha = 0.8
        颜文字表格.alpha = 0.8
        
        self.view.addSubview(分类表格)
        self.view.addSubview(颜文字表格背景)
        self.view.addSubview(颜文字表格)
    }

    func 载入数据(downloadTo:NetDownloadTo) {
        let 下载到位置序号:Int = downloadTo.toRaw()
        var 设置存储:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var 当前下载网址:NSString? = 设置存储.stringForKey("nowurl")
        if ((当前下载网址 != nil) && !当前下载网址!.isEqualToString("localhost")) {
            let 网址和目标位置序号数组:NSMutableArray = [当前下载网址!,NSNumber(integer: 下载到位置序号)]
            NSNotificationCenter.defaultCenter().postNotificationName("loadwebdata", object: 网址和目标位置序号数组) //开始下载
        } else {
            let 内置源路径:NSString = NSBundle.mainBundle().pathForResource("default", ofType: "plist")!
            p_emodata = NSArray(contentsOfFile: 内置源路径)
            载入本地数据()
        }
    }
    
    func 载入本地数据()
    {
        if (p_emodata.count >= 3) {
            var y_emoarr:NSArray = p_emodata.objectAtIndex(3) as NSArray
            sortData.removeAllObjects()
            for emogroup_o in y_emoarr
            {
                var emogroup:NSArray = emogroup_o as NSArray
                let groupname:NSString = emogroup.objectAtIndex(0) as NSString
                sortData.addObject(groupname)
            }
            分类表格.reloadData()
            if (sortData.count > 0) {
                分类表格.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
                openSortData(0)
            }
            
        } else {
            println("NODATA")
        }
    }
    
    func time(notification:NSNotification)
    {
        载入本地数据()
    }
    
    func loadwebdataokf2(notification:NSNotification)
    {
        let urlArr:NSArray = notification.object as NSArray
        let urlStr:NSString = urlArr.objectAtIndex(0) as NSString
        let downloadModeIntNB:NSNumber = urlArr.objectAtIndex(1) as NSNumber
        let downloadModeInt:Int = downloadModeIntNB.integerValue
        let nowDownloadMode:NetDownloadTo = NetDownloadTo.fromRaw(downloadModeInt)!
        if (nowDownloadMode == NetDownloadTo.CLOUDEMOTICON || nowDownloadMode == NetDownloadTo.CLOUDEMOTICONONLINE) {
            载入本地数据()
        } else if (nowDownloadMode == NetDownloadTo.SOURCEMANAGER) {
            if (p_storeIsOpen == false) {
                切换到源管理页面(urlStr)
            }
        }
    }
    
    @IBAction func scoreBtn(sender: UIBarButtonItem) {
        切换到源管理页面(nil)
    }
    
    func 切换到源管理页面(要添加的新源网址:NSString?) {
        let 源管理页面:ScoreTableViewController = ScoreTableViewController(style: UITableViewStyle.Plain)
        源管理页面.代理 = self
        源管理页面.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(源管理页面, animated: true)
        if ((要添加的新源网址) != nil) {
            
                源管理页面.viewDidLoad()
            
            源管理页面.加入源(要添加的新源网址!, 来自源商店: true)
        }
    }
//    override func viewDidAppear(animated: Bool)
//    {
//        载入数据()
//    }
    
    @IBAction func sortBtn(sender: UIBarButtonItem) {
        if (isCanAutoHideSortView()) {
            var x:CGFloat = 0
            if (颜文字表格.frame.origin.x < 滑动最大X坐标 * 0.5) {
                x = 滑动最大X坐标
                NSNotificationCenter.defaultCenter().postNotificationName("取消单元格左滑通知", object: nil)
            }
            self.view.layer.removeAllAnimations()
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.animateWithDuration(0.25, animations: {
                self.颜文字表格.frame = CGRectMake(x, self.颜文字表格.frame.origin.y, self.颜文字表格.frame.size.width, self.颜文字表格.frame.size.height)
                self.颜文字表格背景.frame = self.颜文字表格.frame
                })
        }
    }
    
    func openSortData(row:Int)
    {
        ceData.removeAllObjects()
        var y_emoarr:NSArray = p_emodata.objectAtIndex(3) as NSArray
        let emogroup_o:NSArray = y_emoarr.objectAtIndex(row) as NSArray
        ceData.addObjectsFromArray(emogroup_o)
        ceData.removeObjectAtIndex(0)
        颜文字表格.reloadData()
    }
    
    func 手势执行(recognizer:UITapGestureRecognizer)
    {
        var 手指当前坐标:CGPoint = recognizer.locationInView(self.view)
        if (recognizer.state == UIGestureRecognizerState.Ended || recognizer.state == UIGestureRecognizerState.Cancelled || recognizer.state == UIGestureRecognizerState.Failed) {
            NSNotificationCenter.defaultCenter().postNotificationName("允许单元格接收手势通知", object: nil)
            手势起始位置X坐标 = 0
            var x:CGFloat = 0
            if (颜文字表格.frame.origin.x > 滑动最大X坐标 * 0.5) {
                x = 滑动最大X坐标
                if (isCanAutoHideSortView()) {
                    NSNotificationCenter.defaultCenter().postNotificationName("取消单元格左滑通知", object: nil)
                }
            }
            手势中 = false
            self.view.layer.removeAllAnimations()
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.animateWithDuration(0.15, animations: {
                self.颜文字表格.frame = CGRectMake(x, self.颜文字表格.frame.origin.y, self.颜文字表格.frame.size.width, self.颜文字表格.frame.size.height)
                self.颜文字表格背景.frame = self.颜文字表格.frame
                }, completion: {
                    (Bool completion) in
                    if completion {
                        self.菜单滑动中 = false
                    }
            })
        } else {
            var 手指当前X坐标:CGFloat = 手指当前坐标.x
            if (isCanAutoHideSortView()) {
                let 手指移动距离:CGFloat = 手势起始位置X坐标 - 手指当前X坐标
                var 表格的新X坐标:CGFloat = 颜文字表格.frame.origin.x - 手指移动距离
                
                self.view.layer.removeAllAnimations()
                if (表格的新X坐标 > 滑动最大X坐标) {
                    表格的新X坐标 = 滑动最大X坐标
                } else if (表格的新X坐标 < 0) {
                    表格的新X坐标 = 0
                }
                手势起始位置X坐标 = 手指当前坐标.x
                if (self.手势中 == true) {
                    self.颜文字表格.frame = CGRectMake(表格的新X坐标, self.颜文字表格.frame.origin.y, self.颜文字表格.frame.size.width, self.颜文字表格.frame.size.height)
                    self.颜文字表格背景.frame = self.颜文字表格.frame
                }
            }
        }
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer!) -> Bool
    {
        if (isCanAutoHideSortView()) {
            if (颜文字表格.frame.origin.x != 0) {
                菜单滑动中 = true
            }
        }
        手势中 = true
        var 手指当前坐标:CGPoint = gestureRecognizer.locationInView(self.view)
        手势起始位置X坐标 = 手指当前坐标.x
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (tableView.tag == 100) {
            return sortData.count
        } else {
            return ceData.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let CellIdentifier:NSString = "Cell"
        
        if (tableView.tag == 100) {
            var cell:UITableViewCell? = 分类表格.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)
            }
            let groupname:NSString = sortData.objectAtIndex(indexPath.row) as NSString
            cell!.textLabel?.text = groupname
            return cell!
        } else {
            var cell:CETableViewCell? = 分类表格.dequeueReusableCellWithIdentifier(CellIdentifier) as? CETableViewCell
            if (cell == nil) {
                cell = CETableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)
                cell!.selectionStyle = UITableViewCellSelectionStyle.Blue
                cell!.初始化单元格样式(CETableViewCell.cellMode.CEVIEWCONTROLLER)
                cell!.代理 = self
            }
            cell!.单元格在表格中的位置 = indexPath
            let emoobj:NSArray = ceData.objectAtIndex(indexPath.row) as NSArray
            let emo:NSString = emoobj.objectAtIndex(0) as NSString
            cell!.主文字.text = emo
//            cell!.textLabel.text = emo
            if (emoobj.count > 1) {
                let name:NSString = emoobj.objectAtIndex(1) as NSString
                cell!.副文字.text = name
            } else {
                cell!.副文字.text = ""
            }
            
//            cell?.textLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
//            cell?.textLabel.numberOfLines = 0
            cell?.主文字.lineBreakMode = NSLineBreakMode.ByCharWrapping
            cell?.主文字.numberOfLines = 0
            
            let 主文字框高度:CGFloat = heightForString(cell!.主文字.text!, FontSize: 17, andWidth: cell!.frame.size.width) + 8
            cell!.主文字.frame = CGRectMake(20, 0, cell!.frame.size.width - 20, 主文字框高度)
            if (emoobj.count > 1) {
                let 副文字框高度:CGFloat = heightForString(cell!.副文字.text!, FontSize: 12, andWidth: cell!.frame.size.width) - 13
                cell!.副文字.frame = CGRectMake(20, cell!.主文字.frame.size.height - 7, cell!.frame.size.width - 20, 副文字框高度)
                当前单元格高度 = 主文字框高度 + 副文字框高度
            } else {
                当前单元格高度 = 主文字框高度
            }
            
            cell!.修正元素位置(self.颜文字表格.frame.size.width)
            return cell!
        }
    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        NSNotificationCenter.defaultCenter().postNotificationName("取消单元格左滑通知", object: nil)
        if (tableView.tag == 100) {
            openSortData(indexPath.row)
            sortBtn(sortBtn)
        } else {
            let 颜文字数组:NSArray = ceData.objectAtIndex(indexPath.row) as NSArray
//            let 颜文字:NSString = emoobj.objectAtIndex(0) as NSString
//            let 颜文字名称:NSString = emoobj.objectAtIndex(1) as NSString
            NSNotificationCenter.defaultCenter().postNotificationName("复制到剪贴板通知", object: 颜文字数组, userInfo: nil)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
//    func tableView(tableView: UITableView!, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath!) -> String!
//    {
//        return "喵"
//    }
//    func tableView(tableView: UITableView!, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle
//    {
//        return UITableViewCellEditingStyle.Delete
//    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return false
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (tableView.tag == 101) {
            if (ceData.count > 0) {
                let emoobj:NSArray = ceData.objectAtIndex(indexPath.row) as NSArray
                let 主文字内容:NSString = emoobj.objectAtIndex(0) as NSString
                var 副文字内容:NSString = ""
                let 主文字框高度:CGFloat = heightForString(主文字内容, FontSize: 17, andWidth: tableView.frame.width - 20) + 8
                if (emoobj.count > 1) {
                    副文字内容 = emoobj.objectAtIndex(1) as NSString
                    let 副文字框高度:CGFloat = heightForString(副文字内容, FontSize: 12, andWidth: tableView.frame.width - 20) - 13
                    return 主文字框高度 + 副文字框高度 + 15
                } else {
                    return 主文字框高度 + 15
                }
            }
            return 当前单元格高度
        }
        return 44
    }
    
//    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject]!
//    {
//        
//    }
    
//    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView!
//    {
////        if (tableView.tag == 100) {

//            return userview
////        } else {
////            return UIView()
////        }
//    }
    
//    override func viewDidAppear(animated: Bool) {
//        颜文字表格.reloadData()
//    }
    
    func transition(notification:NSNotification)
    {
        println("收到屏幕旋转")
        
        let newScreenSizeArr:NSArray = notification.object as NSArray
        let newScreenSize:CGSize = CGSizeMake(newScreenSizeArr.objectAtIndex(0) as CGFloat, newScreenSizeArr.objectAtIndex(1) as CGFloat)
        
        分类表格.frame = CGRectMake(0, 0, 滑动最大X坐标, newScreenSize.height)
        
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone && newScreenSize.width < newScreenSize.height) {
            sortBtn.title = lang.uage("分类")
            颜文字表格.frame = CGRectMake(分类表格.frame.size.width, 0, newScreenSize.width, newScreenSize.height)
            self.颜文字表格背景.frame = self.颜文字表格.frame
        } else {
            sortBtn.title = ""
            颜文字表格.frame = CGRectMake(分类表格.frame.size.width, 0, newScreenSize.width - 分类表格.frame.size.width, newScreenSize.height)
            self.颜文字表格背景.frame = self.颜文字表格.frame
        }
        
        if (newScreenSize.width < newScreenSize.height || UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
            分类表格.contentInset = UIEdgeInsetsMake(64, 0, 48, 0)
        } else {
            分类表格.contentInset = UIEdgeInsetsMake(32, 0, 48, 0)
        }
        颜文字表格.contentInset = 分类表格.contentInset
        let 新的宽度:CGFloat = 颜文字表格.frame.size.width
        NSNotificationCenter.defaultCenter().postNotificationName("修正单元格尺寸通知", object: 新的宽度)
        颜文字表格.reloadData()
    }
    
    func 源管理页面代理：退出源管理页面时()
    {
        载入数据(NetDownloadTo.CLOUDEMOTICON)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!)
    {
        let 表格滚动位置:CGPoint = scrollView.contentOffset
        let 表格竖向滚动:CGFloat = 表格滚动位置.y
        let 表格滚动距离:CGFloat = 0 - 表格滚动位置.y - 表格初始滚动位置
        if (下拉刷新提示 != nil) {
            let 当前表格:UITableView = scrollView as UITableView
            下拉刷新提示!.frame = CGRectMake(当前表格.frame.origin.x, 表格初始滚动位置, 当前表格.frame.size.width, 表格滚动距离)
            if (下拉刷新动作中) {
                if (表格竖向滚动 < -100.0) {
                    下拉刷新提示!.text = lang.uage("松开手指刷新")
                } else {
                    下拉刷新提示!.text = lang.uage("下拉刷新")
                }
            }
        }
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView!)
    {
        下拉刷新动作中 = true
        if (self.view.frame.size.width < self.view.frame.size.height) {
            表格初始滚动位置 = 64
        } else {
            表格初始滚动位置 = 32
        }
//        表格初始滚动位置 = 0 - scrollView.contentOffset.y
        if (下拉刷新提示 != nil) {
            下拉刷新提示?.removeFromSuperview()
            下拉刷新提示 = nil
        }
        if (scrollView.frame.size.width == self.view.frame.size.width) {
            下拉刷新提示 = UILabel(frame: CGRectMake(颜文字表格.frame.origin.x, 表格初始滚动位置, 颜文字表格.frame.size.width, 0))
        } else {
            下拉刷新提示 = UILabel(frame: CGRectMake(分类表格.frame.origin.x, 表格初始滚动位置, 分类表格.frame.size.width, 0))
        }
//        下拉刷新提示!.backgroundColor = UIColor.blueColor()
        下拉刷新提示!.layer.masksToBounds = true
        下拉刷新提示!.textAlignment = NSTextAlignment.Center
        下拉刷新提示!.textColor = UIColor.grayColor()
        self.view.addSubview(下拉刷新提示!)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        下拉刷新动作中 = false
        let 表格滚动位置:CGPoint = scrollView.contentOffset
        let 表格竖向滚动:CGFloat = 表格滚动位置.y
        if (表格竖向滚动 < -100.0) {
            下拉刷新提示!.text = lang.uage("正在刷新")
            if (全局_网络繁忙 == false) {
                载入数据(NetDownloadTo.CLOUDEMOTICONONLINE)
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName("允许单元格接收手势通知", object: nil)
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        下拉刷新提示?.removeFromSuperview()
        下拉刷新提示 = nil
    }
    
    func 单元格代理：点击滑出的按钮时(点击按钮的ID:Int, 单元格在表格中的位置:NSIndexPath)
    {
        NSNotificationCenter.defaultCenter().postNotificationName("取消单元格左滑通知", object: nil)
        let 当前单元格:CETableViewCell = 颜文字表格.cellForRowAtIndexPath(单元格在表格中的位置) as CETableViewCell
        let 颜文字:NSString = 当前单元格.主文字.text!
        let 颜文字名称:NSString? = 当前单元格.副文字.text
        if (点击按钮的ID == 1) { //收藏
            let 文件管理器:FileManager = FileManager()
            var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.FAVORITE)
            var 收藏中已经存在这个颜文字:Bool = false
            if (文件中的数据 != nil) {
                for 文件中的颜文字数组对象 in 文件中的数据! {
                    let 文件中的颜文字数组:NSArray = 文件中的颜文字数组对象 as NSArray
                    let 文件中的颜文字:NSString = 文件中的颜文字数组.objectAtIndex(0) as NSString
                    if (颜文字.isEqualToString(文件中的颜文字)) {
                        收藏中已经存在这个颜文字 = true
                    }
                }
            }
            var 提示文字:NSString?
            if (收藏中已经存在这个颜文字 == false) {
                var 颜文字数组:NSMutableArray = [颜文字]
                if (颜文字名称 != nil) {
                    颜文字数组.addObject(颜文字名称!)
                }
                var 收藏:NSMutableArray = NSMutableArray.array()
                收藏.addObject(颜文字数组)
                if (文件中的数据 != nil) {
                    收藏.addObjectsFromArray(文件中的数据!)
                }
                //            if (收藏.count > 100) {
                //                收藏.removeLastObject()
                //            }
                文件管理器.SaveArrayToFile(收藏, smode: FileManager.saveMode.FAVORITE)
                保存数据到输入法()
                提示文字 = NSString(format: "“ %@ ” %@", 颜文字, lang.uage("添加到收藏夹成功"))
            } else {
                提示文字 = NSString(format: "%@ “ %@ ”",lang.uage("你已经收藏了") ,颜文字)
            }
            NSNotificationCenter.defaultCenter().postNotificationName("显示自动关闭的提示框通知", object: 提示文字!)
        } else { //分享 颜文字
            let 分享视图:UIActivityViewController = UIActivityViewController(activityItems: [颜文字], applicationActivities: nil)
            self.presentViewController(分享视图, animated: true, completion: nil)
        }
    }
    
    func 单元格代理：是否可以接收手势() -> Bool
    {
        if (isCanAutoHideSortView()) {

            if (颜文字表格.frame.origin.x == 0 && 菜单滑动中 == false) {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    

}
