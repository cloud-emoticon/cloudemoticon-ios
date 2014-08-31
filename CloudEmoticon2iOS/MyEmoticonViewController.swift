//
//  MyEmoticonViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/20.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class MyEmoticonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate{
    
    let 文件管理器:FileManager = FileManager()
    var 表格数据:NSMutableArray = NSMutableArray.array()

    
//    enum 模式:Int
//    {
//        收藏 = 0
//        历史记录 = 1
//        自定义 = 2
//    }
    //内容选择菜单.selectedSegmentIndex
    @IBOutlet weak var bgpview: UIImageView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let bg:UIImage? = UIImage(contentsOfFile: userbgimgfullpath)

        if(bg != nil){
            bgimage = bg!
        }
        bgpview.image = bgimage
        
        右上按钮.title = "编辑"
        左上按钮.title = ""
        表格.delegate = self
        表格.dataSource = self
        表格.alpha = 0.8
    }
    
    @IBOutlet weak var 左上按钮: UIBarButtonItem!
    @IBOutlet weak var 表格: UITableView!
    @IBOutlet weak var 右上按钮: UIBarButtonItem!
    @IBOutlet weak var 内容选择菜单: UISegmentedControl!
    
    @IBAction func 左上按钮(sender: UIBarButtonItem) {
    
        switch (内容选择菜单.selectedSegmentIndex) {
        case 0:
            break
        case 1:
            break
        case 2:
            表格.setEditing(!表格.editing, animated: true)
            if(表格.editing){
            左上按钮.title = "完成"
            右上按钮.title = ""
        } else {
            左上按钮.title = "编辑"
            右上按钮.title = "添加"
            }
        default:
            break
        }
    }
    
    
    @IBAction func 右上按钮(sender: UIBarButtonItem)
    {
        switch (内容选择菜单.selectedSegmentIndex) {
        case 0:
            表格.setEditing(!表格.editing, animated: true)
            if (表格.editing) {
                左上按钮.title = ""
                右上按钮.title = "完成"
            } else {
                左上按钮.title = ""
                右上按钮.title = "编辑"
            }
                表格.reloadData()
                保存收藏数据()
            break
        case 1:
            表格数据.removeAllObjects()
            表格.reloadData()
            保存历史记录数据()
            break
        case 2:
            if (!表格.editing) {
                右上按钮.title = "添加"
                左上按钮.title = "编辑"
                var alert:UIAlertView = UIAlertView(title: "添加颜文字", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "添加")
                alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
                var alertImport:UITextField = alert.textFieldAtIndex(0) as UITextField
                alert.tag = 300
                alertImport.keyboardType = UIKeyboardType.URL
                alertImport.text = ""
                alert.show()
            } else {
                右上按钮.title = ""
                左上按钮.title = "完成"
            }
            表格.reloadData()
            保存自定义数据()
            break
        default:
            break
        }
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        var alertImport:UITextField = alertView.textFieldAtIndex(0) as UITextField
        if (alertView.tag == 300) {
            if (buttonIndex == 1) {
                //添加
                addemoticon(alertImport.text)
                载入自定义数据()
            }
        }
    }
    
    func addemoticon(emoticonstr:NSString)
    {
        let 颜文字名称:NSString = "自定义"
        let 要添加的颜文字数组:NSArray = [emoticonstr]
        var 自定义:NSMutableArray = NSMutableArray.array()
        var 自定义颜文字:NSString = 要添加的颜文字数组.objectAtIndex(0)as NSString
        var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.CUSTOM)
        var 自定义中已经存在这个颜文字 = false
        for 文件中的颜文字数组对象 in 文件中的数据! {
            let 文件中的颜文字数组:NSArray = 文件中的颜文字数组对象 as NSArray
            let 文件中的颜文字:NSString = 文件中的颜文字数组.objectAtIndex(0) as NSString
            if ( 自定义颜文字.isEqualToString(文件中的颜文字)) {
                自定义中已经存在这个颜文字 = true
            }
        }
        if(!自定义中已经存在这个颜文字)
        {
        自定义.addObject(要添加的颜文字数组)
        }
        if (文件中的数据 != nil) {
            自定义.addObjectsFromArray(文件中的数据!)
        }
        文件管理器.SaveArrayToFile(自定义,smode: FileManager.saveMode.CUSTOM)
        
    }
    
    @IBAction func 内容选择菜单(内容选择: UISegmentedControl)
    {
        表格.setEditing(false, animated: true)
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
            左上按钮.title = ""
            break
        case 1:
            载入历史记录数据()
            左上按钮.title = ""
            右上按钮.title = "清空"
            break
        case 2:
            var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CE2NCWidget")!
            containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
            var value:NSString? = NSString.stringWithContentsOfURL(containerURL, encoding: NSUTF8StringEncoding, error: nil)
            if(value != nil && value != "") {
            addemoticon(value!)
            }
            value = ""
            value?.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
            载入自定义数据()
            左上按钮.title = "编辑"
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
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)
            cell!.selectionStyle = UITableViewCellSelectionStyle.Blue
        }
        
        let 当前单元格数据:NSArray = 表格数据.objectAtIndex(indexPath.row) as NSArray
        let 颜文字:NSString = 当前单元格数据.objectAtIndex(0) as NSString
        var 颜文字名称:NSString?
        if (当前单元格数据.count > 1) {
            颜文字名称! = 当前单元格数据.objectAtIndex(1) as NSString
        }
        cell?.textLabel.text = 颜文字
        if (颜文字名称 != nil) {
            cell?.detailTextLabel.text = 颜文字名称!
        } else {
            cell?.detailTextLabel.text = ""
        }
        cell?.textLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
        cell?.textLabel.numberOfLines = 0
        
            return cell
    }
    
//    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
//        
//    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        let 要复制的文本数组:NSArray = 表格数据.objectAtIndex(indexPath.row) as NSArray
        NSNotificationCenter.defaultCenter().postNotificationName("复制到剪贴板通知", object: 要复制的文本数组, userInfo: nil)
        if (内容选择菜单.selectedSegmentIndex == 1) {
            载入历史记录数据()
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    // MARK: - 表格编辑范围
    func tableView(tableView: UITableView!, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle
    {
            return UITableViewCellEditingStyle.Delete
    }
    // MARK: - 表格是否可以移动项目
    func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool
    {
        return true
    }
    // MARK: - 表格是否可以编辑
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool
    {
        return true
    }
    
    // MARK: - 表格项目被移动
    func tableView(tableView: UITableView!, moveRowAtIndexPath sourceIndexPath: NSIndexPath!, toIndexPath destinationIndexPath: NSIndexPath!)
    {
            var fromRow:NSInteger = sourceIndexPath.row
            var toRow:NSInteger = destinationIndexPath.row
            var object: AnyObject = 表格数据.objectAtIndex(fromRow)
            表格数据.removeObjectAtIndex(fromRow)
            表格数据.insertObject(object, atIndex: toRow)
        switch(内容选择菜单.selectedSegmentIndex) {
        case 0:
            文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.FAVORITE)
            break
        case 1:
            break
        case 2:
            文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.CUSTOM)
            break
        default:
            break
        }
    }
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
        switch (内容选择菜单.selectedSegmentIndex) {
        case 0:
            var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.FAVORITE)
            var nowrow:NSInteger = indexPath.row
            let nowrowArr:NSArray = 文件中的数据!.objectAtIndex(nowrow) as NSArray
            let nowemo:NSString = nowrowArr.objectAtIndex(0) as NSString
            表格数据.removeObjectAtIndex(nowrow)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            if(文件中的数据 != nil){
                文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.FAVORITE)
            } else {
                let fileName:NSString = 文件管理器.FileName(FileManager.saveMode.FAVORITE)
                let fulladd:NSString = 文件管理器.FileNameToFullAddress(fileName)
                文件管理器.deleteFile(fulladd, smode: FileManager.saveMode.FAVORITE)
            }
            break
        case 1:
            break
        case 2:
            var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.CUSTOM)
            var nowrow:NSInteger = indexPath.row
            let nowrowArr:NSArray = 文件中的数据!.objectAtIndex(nowrow) as NSArray
            let nowemo:NSString = nowrowArr.objectAtIndex(0) as NSString
            表格数据.removeObjectAtIndex(nowrow)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            if(文件中的数据 != nil){
                文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.CUSTOM)
            } else {
                let fileName:NSString = 文件管理器.FileName(FileManager.saveMode.CUSTOM)
                let fulladd:NSString = 文件管理器.FileNameToFullAddress(fileName)
                文件管理器.deleteFile(fulladd, smode: FileManager.saveMode.CUSTOM)
            }
            break
        default:
            break
        }
    }
    }
//    - (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
