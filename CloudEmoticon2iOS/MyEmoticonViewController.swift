//
//  MyEmoticonViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/20.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class MyEmoticonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let 文件管理器:FileManager = FileManager()
    var 表格数据:NSMutableArray = NSMutableArray.array()
    
//    enum 模式:Int
//    {
//        收藏 = 0
//        历史记录 = 1
//        自定义 = 2
//    }
    //内容选择菜单.selectedSegmentIndex

    override func viewDidLoad() {
        super.viewDidLoad()
        右上按钮.title = "编辑"
        表格.delegate = self
        表格.dataSource = self
    }
    
    @IBOutlet weak var 表格: UITableView!
    @IBOutlet weak var 右上按钮: UIBarButtonItem!
    @IBOutlet weak var 内容选择菜单: UISegmentedControl!
    
    @IBAction func 右上按钮(sender: UIBarButtonItem)
    {
        switch (内容选择菜单.selectedSegmentIndex) {
        case 0:
            break
        case 1:
            表格数据.removeAllObjects()
            表格.reloadData()
            保存历史记录数据()
            break
        case 2:
            break
        default:
            break
        }
    }
    
    @IBAction func 内容选择菜单(内容选择: UISegmentedControl)
    {
        changemode(内容选择.selectedSegmentIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        changemode(内容选择菜单.selectedSegmentIndex)
    }
    
    // MARK: - 载入数据
    func changemode(id:Int)
    {
        switch (id) {
        case 0:
            载入收藏数据()
            右上按钮.title = "编辑"
            break
        case 1:
            载入历史记录数据()
            右上按钮.title = "清空"
            break
        case 2:
            载入自定义数据()
            右上按钮.title = "添加"
            break
        default:
            break
        }
    }
    func 载入收藏数据()
    {
        var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.FAVORITE)
        将数据载入表格(文件中的数据)
    }
    func 载入历史记录数据()
    {
        var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.HISTORY)
        将数据载入表格(文件中的数据)
    }
    func 载入自定义数据()
    {
        var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.CUSTOM)
        将数据载入表格(文件中的数据)
    }
    func 将数据载入表格(文件中的数据:NSArray?)
    {
        表格数据.removeAllObjects()
        if (文件中的数据 != nil) {
            表格数据.addObjectsFromArray(文件中的数据!)
        }
        表格.reloadData()
    }
    
    // MARK: - 保存数据
    func 保存收藏数据()
    {
        文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.FAVORITE)
    }
    func 保存历史记录数据()
    {
        文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.HISTORY)
    }
    func 保存自定义数据()
    {
        文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.CUSTOM)
    }
    
   
    
    // MARK: - 表格数据
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int
    {
        return 1;
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return 表格数据.count
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let CellIdentifier:NSString = "Cell"
        var cell:UITableViewCell? = 表格.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
            cell!.selectionStyle = UITableViewCellSelectionStyle.Blue
        }
        
        cell?.textLabel.text = 表格数据.objectAtIndex(indexPath.row) as NSString
        return cell;
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        let 要复制的文本:NSString = 表格数据.objectAtIndex(indexPath.row) as NSString
        NSNotificationCenter.defaultCenter().postNotificationName("复制到剪贴板通知", object: 要复制的文本, userInfo: nil)
        载入历史记录数据()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
