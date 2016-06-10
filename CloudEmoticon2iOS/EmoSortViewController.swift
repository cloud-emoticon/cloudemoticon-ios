//
//  EmoSortViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫 on 16/6/10.
//  Copyright © 2016年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class EmoSortViewController: UITableViewController, SourceTableViewControllerDelegate {

    let className = "[云颜文字N]"
    let 文件管理器 = FileManager()
    var 当前源:NSString = NSString()
    var 分类表格:UITableView = UITableView()
    var 用户登录视图:UserTableHeaderView = UserTableHeaderView()
    var sortData:NSMutableArray = NSMutableArray()
    var ceData:NSMutableArray = NSMutableArray()
    var 源管理页面:SourceTableViewController? = nil
    var 当前分类:Int = 0

    @IBAction func 切换到源管理(sender: AnyObject) {
        切换到源管理页面(nil)
    }
    
    func 切换到源管理页面(要添加的新源网址:NSString?) {
        if (源管理页面 != nil) {
            p_storeIsOpen = false
            源管理页面?.代理 = nil
            源管理页面?.navigationController?.popViewControllerAnimated(false)
            源管理页面 = nil
        }
        源管理页面 = SourceTableViewController(style: UITableViewStyle.Plain)
        源管理页面?.代理 = self
        源管理页面?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(源管理页面!, animated: true)
        if ((要添加的新源网址) != nil) {
            源管理页面?.viewDidLoad()
            源管理页面?.加入源(要添加的新源网址!, 来自源商店: true)
        }
    }
    func 源管理页面代理：退出源管理页面时()
    {
        载入数据(NetDownloadTo.CLOUDEMOTICON)
        EmoViewController().loaddata()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        载入数据(NetDownloadTo.CLOUDEMOTICON)
        //        loadbgi()
        //        let 背景透明度:CGFloat = loadopc()
        //        分类表格.alpha = 背景透明度
        //        分类表格.alpha = 背景透明度
        //        颜文字表格.alpha = 背景透明度
        
        var y_emoarr:NSArray = NSArray()
        let p_emoweb:NSArray? = p_emodata
        if(p_emoweb != nil && p_emodata.count >= 3)
        {
            当前源 = NSString(format: "%@:%@",lang.uage("当前源"),p_emodata.objectAtIndex(1) as! NSString)
            NSLog("%@",当前源)
        } else {
            当前源 = NSString(format: "%@:%@",lang.uage("当前源"),lang.uage("本地内置源"))
        }
    }
    
    @IBOutlet weak var 源管理: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        分类表格.delegate = self
        分类表格.dataSource = self
        分类表格.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func 载入数据(downloadTo:NetDownloadTo) {
        let 下载到位置序号:Int = downloadTo.rawValue
        let 设置存储:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let 当前下载网址:NSString? = 设置存储.stringForKey("nowurl")
        if ((当前下载网址 != nil) && !当前下载网址!.isEqualToString("localhost")) {
            let 网址和目标位置序号数组:NSMutableArray = [当前下载网址!,NSNumber(integer: 下载到位置序号)]
            NSNotificationCenter.defaultCenter().postNotificationName("loadwebdata", object: 网址和目标位置序号数组) //开始下载
        } else {
            let 内置源路径:NSString = NSBundle.mainBundle().pathForResource("default", ofType: "plist")!
            p_emodata = NSArray(contentsOfFile: 内置源路径 as String)!
            载入本地数据()
        }
    }
    
    func 载入本地数据()
    {
        if (p_emodata.count >= 3) {
            let y_emoarr:NSArray = p_emodata.objectAtIndex(3) as! NSArray
            sortData.removeAllObjects()
            for emogroup_o in y_emoarr
            {
                let emogroup:NSArray = emogroup_o as! NSArray
                let groupname:NSString = emogroup.objectAtIndex(0) as! NSString
                sortData.addObject(groupname)
            }
            分类表格.reloadData()
            if (sortData.count > 0) {
                分类表格.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
                openSortData(0)
            }
            
        } else {
            print("NODATA")
        }
    }
    
    func openSortData(row:Int)
    {
        ceData.removeAllObjects()
        let y_emoarr:NSArray = p_emodata.objectAtIndex(3) as! NSArray
        let emogroup_o:NSArray = y_emoarr.objectAtIndex(row) as! NSArray
        ceData.addObjectsFromArray(emogroup_o  as [AnyObject])
        ceData.removeObjectAtIndex(0)
//        颜文字表格.reloadData()
    }

    
    //表格数据
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let CellIdentifier:NSString = "Cell"
        
            var cell:UITableViewCell? = 分类表格.dequeueReusableCellWithIdentifier(CellIdentifier as String)
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier as String)
                cell?.backgroundColor = UIColor.clearColor()
                let 选中行背景视图:UIImageView = UIImageView(frame: cell!.frame)
                //                选中行背景视图.backgroundColor = UIColor.redColor()
                cell?.selectedBackgroundView = 选中行背景视图
            }
//            let 选中行背景视图:UIImageView = cell?.selectedBackgroundView as! UIImageView
//            选中行背景视图.backgroundColor = 云颜文字左侧分类列表选中行背景色
//            选中行背景视图.image = 云颜文字左侧分类列表选中行背景图片
//            cell?.textLabel?.textColor = 云颜文字左侧分类列表文字颜色
            let groupname:NSString = sortData.objectAtIndex(indexPath.row) as! NSString
            cell!.textLabel?.text  = groupname as String
            return cell!
        
    }
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


