//
//  EmoViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫 on 16/6/10.
//  Copyright © 2016年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class EmoViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var 搜索栏: UISearchBar!
    @IBOutlet weak var 颜文字表格: UITableView!
    
    var 主文字:UILabel = UILabel()
    var 副文字:UILabel = UILabel()
    var 搜索结果:NSMutableArray = NSMutableArray()
    var 搜索结果的名称:NSMutableArray = NSMutableArray()
    var ceData:NSMutableArray = NSMutableArray()
    var 单元格在表格中的位置:NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

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


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let CellIdentifier:NSString = "Cell"
        
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier as String)!
        
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