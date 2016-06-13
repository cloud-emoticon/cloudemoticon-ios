//
//  EmoViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫 on 16/6/10.
//  Copyright © 2016年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class EmoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, QRViewDelegate {

    @IBOutlet weak var 搜索栏: UISearchBar!
    @IBOutlet weak var 颜文字表格: UITableView!
    
    var 主文字:UILabel = UILabel()
    var 副文字:UILabel = UILabel()
    var 搜索结果:NSMutableArray = NSMutableArray()
    var 搜索结果的名称:NSMutableArray = NSMutableArray()
    var ceData:NSMutableArray = NSMutableArray()
    var 单元格在表格中的位置:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    var 二维码缓存:UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        颜文字表格.delegate = self
        颜文字表格.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loaddata()
    {
        var y_emoarr:NSArray = NSArray()
        let p_emoweb:NSArray? = p_emodata
        if(p_emoweb != nil && p_emodata.count >= 3)
        {
            let p_emoary:NSArray = p_emoweb!
            y_emoarr = p_emoary.objectAtIndex(3) as! NSArray
        } else {
            let 内置源路径:NSString = NSBundle.mainBundle().pathForResource("default", ofType: "plist")!
            let p_emo:NSArray! = NSArray(contentsOfFile: 内置源路径 as String)
            y_emoarr = p_emo.objectAtIndex(3) as! NSArray
        }
        
        搜索结果.removeAllObjects()
        搜索结果的名称.removeAllObjects()
        for g_emoobj in y_emoarr
        {
            let g_emoarr:NSArray = g_emoobj as! NSArray
            for e_emo  in g_emoarr
            {
                if ((e_emo as? NSArray) != nil){
                    搜索结果.addObject(e_emo.objectAtIndex!(0))
                    if (e_emo.count > 1) {
                        搜索结果的名称.addObject(e_emo.objectAtIndex!(1))
                    } else {
                        搜索结果的名称.addObject("")
                    }
                }
            }
        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        if (颜文字表格.frame.origin.x >= self.view.frame.size.width * 0.3){
            return false
        } else {
            return true
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        搜索栏.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        搜索栏.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        loaddata()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let str:NSString = searchText
        if (str.isEqualToString("")) {
            EmoSortViewController().openSortData(EmoSortViewController().当前分类)
        } else {
            var i = 0
            ceData.removeAllObjects()
            for 搜索结果颜文字 in 搜索结果 {
                let 匹配:NSRange = 搜索结果颜文字.rangeOfString(str as String, options: NSStringCompareOptions.CaseInsensitiveSearch)
                let 搜索的颜文字名称 = 搜索结果的名称.objectAtIndex(i) as! NSString
                let 匹配2:NSRange = 搜索的颜文字名称.rangeOfString(str as String, options: NSStringCompareOptions.CaseInsensitiveSearch)
                if(匹配.length > 0 || 匹配2.length > 0){
                    ceData.addObjectsFromArray([[搜索结果颜文字,搜索的颜文字名称]])
                }
                i += 1
            }
            颜文字表格.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return ceData.count
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        搜索栏.resignFirstResponder()
//        NSNotificationCenter.defaultCenter().postNotificationName("取消单元格左滑通知", object: nil)
            let 颜文字数组:NSArray = ceData.objectAtIndex(indexPath.row) as! NSArray
            //            let 颜文字:NSString = emoobj.objectAtIndex(0) as NSString
            //            let 颜文字名称:NSString = emoobj.objectAtIndex(1) as NSString
            NSNotificationCenter.defaultCenter().postNotificationName("复制到剪贴板通知", object: 颜文字数组, userInfo: nil)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    
    func 显示二维码() {
        //QRViewDelegate
        let 二维码视图:QRView = QRView()
        二维码视图.显示二维码(二维码缓存)
        self.view.addSubview(二维码视图)
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // 1
        let 当前单元格:CETableViewCell = 颜文字表格.cellForRowAtIndexPath(单元格在表格中的位置) as! CETableViewCell
        let 颜文字:NSString = 当前单元格.主文字.text!
        let 颜文字名称:NSString? = 当前单元格.副文字.text
        
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "分享" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            var 二维码分享按钮入:[QRActivity]? = nil
            if (颜文字.length <= 64) {
                let 二维码分享按钮:QRActivity = QRActivity()
                二维码分享按钮.代理 = self
                self.二维码缓存 = QRCodeGenerator.qrImageForString(颜文字 as String, imageSize: 200.0)
                二维码分享按钮.设置二维码图片(self.二维码缓存)
                二维码分享按钮入 = [二维码分享按钮]
                
            }
            let 分享视图:UIActivityViewController = UIActivityViewController(activityItems: [颜文字], applicationActivities: 二维码分享按钮入)
            分享视图.modalTransitionStyle = UIModalTransitionStyle.CoverVertical;
            分享视图.excludedActivityTypes = [UIActivityTypeCopyToPasteboard];
            self.presentViewController(分享视图, animated: true, completion: nil)


        })
            shareAction.backgroundColor = UIColor.cyanColor()
        // 3
        var favAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "收藏" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 4
            let 文件管理器:FileManager = FileManager()
            let 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.FAVORITE)
            var 收藏中已经存在这个颜文字:Bool = false
            if (文件中的数据 != nil) {
                for 文件中的颜文字数组对象 in 文件中的数据! {
                    let 文件中的颜文字数组:NSArray = 文件中的颜文字数组对象 as! NSArray
                    let 文件中的颜文字:NSString = 文件中的颜文字数组.objectAtIndex(0) as! NSString
                    if (颜文字.isEqualToString(文件中的颜文字 as String)) {
                        收藏中已经存在这个颜文字 = true
                    }
                }
            }
            var 提示文字:NSString?
            if (收藏中已经存在这个颜文字 == false) {
                let 颜文字数组:NSMutableArray = [颜文字]
                if (颜文字名称 != nil) {
                    颜文字数组.addObject(颜文字名称!)
                }
                let 收藏:NSMutableArray = NSMutableArray()
                收藏.addObject(颜文字数组)
                if (文件中的数据 != nil) {
                    收藏.addObjectsFromArray(文件中的数据! as [AnyObject])
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
            NSNotificationCenter.defaultCenter().postNotificationName("显示自动关闭的提示框通知", object: 提示文字!)        })
        favAction.backgroundColor = UIColor.orangeColor()
        // 5
        return [shareAction,favAction]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
                cell.backgroundColor = UIColor.clearColor()
                cell.selectionStyle = UITableViewCellSelectionStyle.Blue
                let 选中行背景视图:UIImageView = UIImageView(frame: cell.frame)
                //                选中行背景视图.backgroundColor = UIColor.orangeColor()
                cell.selectedBackgroundView = 选中行背景视图
            
        
//            let 选中行背景视图:UIImageView = cell?.selectedBackgroundView as! UIImageView
//            选中行背景视图.backgroundColor = 列表当前选中的行背景色
//            选中行背景视图.image = 列表当前选中的行背景图片
//            cell?.主文字.textColor = 列表文字颜色
//            cell?.副文字.textColor = 副标题列表文字颜色
        
            let emoobj:NSArray = ceData.objectAtIndex(indexPath.row) as! NSArray
            let emo:NSString = emoobj.objectAtIndex(0) as! NSString
            cell.textLabel!.text = emo as String
            //            cell!.textLabel.text = emo
            if (emoobj.count > 1) {
                let name:NSString = emoobj.objectAtIndex(1) as! NSString
                cell.detailTextLabel!.text = name as String
            } else {
                cell.detailTextLabel!.text = ""
            }
            cell.textLabel!.lineBreakMode = NSLineBreakMode.ByCharWrapping
            cell.textLabel!.numberOfLines = 0

            return cell
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}