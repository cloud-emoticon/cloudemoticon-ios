//
//  SetTableViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫喵 on 14/8/26.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class SetTableViewController: UITableViewController {
    
    var bgpview:UIImageView = UIImageView(image:UIImage(contentsOfFile:Bundle.main.path(forResource: "basicbg", ofType: "png")!))
    var 列表文字颜色:UIColor = UIColor.black
    var 列表当前选中的行背景色:UIColor = UIColor.lightGray
    var 列表当前选中的行背景图片:UIImage? = nil
    var 颜文字表格背景:UIImageView = UIImageView()
    
    var list:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list.add(lang.uage("背景"))
        list.add(lang.uage("个性化"))
        list.add(lang.uage("源管理"))
        list.add(lang.uage("设置"))
        list.add(lang.uage("关于"))
        self.title = lang.uage("设置")
        
//MARK - 主题
        颜文字表格背景.frame = self.tableView.frame
        self.tableView.backgroundView = 颜文字表格背景
        let backgroundView2:UIView = UIView(frame: self.tableView.frame)
        self.tableView.backgroundView?.addSubview(backgroundView2)
//包括下面这里
//        bgpview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
//        bgpview.sendSubviewToBack(self.view)
//        bgpview.contentMode = UIViewContentMode.ScaleAspectFit
//        bgpview.alpha = 0.3
//        self.view.addSubview(bgpview)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        NotificationCenter.default.addObserver(self, selector: #selector(SetTableViewController.切换主题), name: NSNotification.Name(rawValue: "切换主题通知"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SetTableViewController.屏幕旋转(_:)), name: NSNotification.Name(rawValue: "屏幕旋转通知"), object: nil)
        切换主题()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    @objc func 屏幕旋转(_ 通知:Notification) {
        let 新坐标:NSArray = 通知.object as! NSArray
        let 宽:CGFloat = 新坐标.object(at: 0) as! CGFloat
        let 高:CGFloat = 新坐标.object(at: 1) as! CGFloat
        let backgroundView2:UIView = (self.tableView.backgroundView?.subviews[0])!
        backgroundView2.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: 宽, height: 高)
        刷新背景图()
    }
    
    @objc func 切换主题() {
        NSLog("[Skin]->SetTableViewController")
        //默认设置
        UINavigationBar.appearance().setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.barTintColor = 全局_默认导航栏背景颜色
        let navigation_seg_tintcolor_dic:NSDictionary = NSDictionary(object: UIColor.white,
            forKey:convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) as NSCopying)
        self.navigationController?.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary(navigation_seg_tintcolor_dic as? [String : AnyObject])
        let backgroundView2:UIView = (self.tableView.backgroundView?.subviews[0])!
        backgroundView2.backgroundColor = UIColor.white
        列表文字颜色 = UIColor.black
        列表当前选中的行背景色 = 全局_默认当前选中行颜色
        列表当前选中的行背景图片 = nil
        bgpview.image = nil
        颜文字表格背景.image = nil
        bgpview.alpha = 1
        颜文字表格背景.alpha = 1
        
        if (全局_皮肤设置.count > 0 && 全局_皮肤设置.object(forKey: "md5") != nil) {
            let 主题参数转对象:Skin2Object = Skin2Object()
            //图片文件名：顶端导航栏背景图片 yes
            let navigation_bar_image_S:String = 全局_皮肤设置.object(forKey: "navigation_bar_image") as! String
            NSLog("[Skin]navigation_bar_image_S=%@",navigation_bar_image_S)
            if (navigation_bar_image_S != "null") {
                let navigation_bar_image:UIImage? = 主题参数转对象.image(navigation_bar_image_S) //tool_backgroundimage_S
                if (navigation_bar_image != nil) {
                    UINavigationBar.appearance().setBackgroundImage(navigation_bar_image, for: UIBarMetrics.default)
                }
            }
            //RGBA色值：顶端导航栏背景颜色 yes
            let navigation_bar_bgcolor_S:String = 全局_皮肤设置.object(forKey: "navigation_bar_bgcolor") as! String
            NSLog("[Skin]tnavigation_bar_bgcolor_S=%@",navigation_bar_bgcolor_S)
            if (navigation_bar_bgcolor_S != "null") {
                let navigation_bar_bgcolor:UIColor? = 主题参数转对象.color(navigation_bar_bgcolor_S) //navigation_bar_bgcolor_S
                if (navigation_bar_bgcolor != nil) {
                    self.navigationController?.navigationBar.barTintColor = navigation_bar_bgcolor
                }
            }
            //RGBA色值：顶端导航栏文字颜色 yes
            let navigation_seg_tintcolor_S:String = 全局_皮肤设置.object(forKey: "navigation_seg_tintcolor") as! String
            NSLog("[Skin]navigation_seg_tintcolor_S=%@",navigation_seg_tintcolor_S)
            if (navigation_seg_tintcolor_S != "null") {
                let navigation_seg_tintcolor:UIColor? = 主题参数转对象.color(navigation_seg_tintcolor_S) //navigation_seg_tintcolor_S
                if (navigation_seg_tintcolor != nil) {
                    let navigation_seg_tintcolor_dic:NSDictionary = NSDictionary(object: navigation_seg_tintcolor!,
                        forKey:convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) as NSCopying)
                    self.navigationController?.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary(navigation_seg_tintcolor_dic as? [String : AnyObject])
                }
            }
            //RGBA色值：列表的背景色 yes
            let table_bgcolor_S:String = 全局_皮肤设置.object(forKey: "table_bgcolor") as! String
            if (table_bgcolor_S != "null") {
                let table_bgcolor:UIColor? = 主题参数转对象.color(table_bgcolor_S) //table_bgcolor_S
                if (table_bgcolor != nil) {
                    backgroundView2.backgroundColor = table_bgcolor
                }
            }
            //RGBA色值：列表文字颜色 yes
            let table_textcolor_S:String = 全局_皮肤设置.object(forKey: "table_textcolor") as! String
            NSLog("[Skin]table_textcolor_S=%@",table_textcolor_S)
            if (table_textcolor_S != "null") {
                let table_textcolor:UIColor? = 主题参数转对象.color(table_textcolor_S) //table_textcolor_S
                if (table_textcolor != nil) {
                    列表文字颜色 = table_textcolor!
                }
            }
            //RGBA色值：列表当前选中的行背景色 yes
            let table_selectcolor_S:String = 全局_皮肤设置.object(forKey: "table_selectcolor") as! String
            NSLog("[Skin]table_selectcolor_S=%@",table_selectcolor_S)
            if (table_selectcolor_S != "null") {
                let table_selectcolor:UIColor? = 主题参数转对象.color(table_selectcolor_S) //table_selectcolor_S
                if (table_selectcolor != nil) {
                    列表当前选中的行背景色 = table_selectcolor!
                }
            }
            //图片文件名：列表当前选中的行背景图片 yes
            let table_selectimage_S:String = 全局_皮肤设置.object(forKey: "table_selectimage") as! String
            NSLog("[Skin]table_selectimage_S=%@",table_selectimage_S)
            if (table_selectimage_S != "null") {
                let table_selectimage:UIImage? = 主题参数转对象.image(table_selectimage_S) //table_selectimage_S
                if (table_selectimage != nil) {
                    列表当前选中的行背景图片 = table_selectimage!
                }
            }
            刷新背景图()
            self.tableView.reloadData()
        }
    }
    
    func 刷新背景图() {
        let 启用修改背景:Bool = UserDefaults.standard.bool(forKey: "diybg")
        if (启用修改背景) {
            NSLog("[Skin]背景图被用户替换")
            let bg:UIImage? = loadbg()
            bgpview.image = bgimage
            颜文字表格背景.image = bgimage
            if(bg != defaultimage){
                bgpview.contentMode = UIView.ContentMode.scaleAspectFill
                颜文字表格背景.contentMode = UIView.ContentMode.scaleAspectFill
            } else {
                bgpview.contentMode = UIView.ContentMode.scaleAspectFit
                颜文字表格背景.contentMode = UIView.ContentMode.scaleAspectFit
            }
            bgpview.alpha = loadopc()
            颜文字表格背景.alpha = loadopc()
        } else {
            bgpview.alpha = 1
            颜文字表格背景.alpha = 1
            bgpview.contentMode = UIView.ContentMode.scaleAspectFill
            颜文字表格背景.contentMode = UIView.ContentMode.scaleAspectFill
            let 主题参数转对象:Skin2Object = Skin2Object()
            let 取背景图:String = 主题参数转对象.判断应该显示的背景图()
            let background_image_S:String? = 全局_皮肤设置.object(forKey: 取背景图) as? String
            
            if (background_image_S != nil && background_image_S != "null") {
                NSLog("[Skin]%@_S=%@",取背景图,background_image_S!)
                let background_image:UIImage? = 主题参数转对象.image(background_image_S) //background_image_S
                if (background_image != nil) {
                    颜文字表格背景.image = background_image!
                }
            }
            
            //图片文件名：列表背景图片
            let cloudemo_typetable_bgimage_S:String? = 全局_皮肤设置.object(forKey: "cloudemo_typetable_bgimage") as? String
            if (cloudemo_typetable_bgimage_S != nil && cloudemo_typetable_bgimage_S != "null") {
                NSLog("[Skin]cloudemo_typetable_bgimage_S=%@",cloudemo_typetable_bgimage_S!)
                let cloudemo_typetable_bgimage:UIImage? = 主题参数转对象.image(cloudemo_typetable_bgimage_S) //cloudemo_typetable_bgimage_S
                if (cloudemo_typetable_bgimage != nil) {
                    bgpview.image = cloudemo_typetable_bgimage
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier:NSString = "Cell"
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier as String)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: CellIdentifier as String)
            cell?.selectionStyle = UITableViewCell.SelectionStyle.blue
            cell?.backgroundColor = UIColor.clear
            cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            let 选中行背景视图:UIImageView = UIImageView(frame: cell!.frame)
            cell?.selectedBackgroundView = 选中行背景视图
        }
        let 选中行背景视图:UIImageView = cell?.selectedBackgroundView as! UIImageView
        选中行背景视图.backgroundColor = 列表当前选中的行背景色
        选中行背景视图.image = 列表当前选中的行背景图片
        cell?.textLabel?.textColor = 列表文字颜色
        if (list.count > 0) {
            cell?.textLabel?.text = list.object(at: (indexPath as NSIndexPath).row) as? String
        } else {
            cell?.textLabel?.text = ""
        }
        return cell!
    }
    
    func 前往主题管理(_ 直接添加主题地址:String?) {
        let push = SkinTableViewController()
        //let push = storyboard?.instantiateViewControllerWithIdentifier("Color") as UIViewController
        push.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(push, animated: true)
        if (直接添加主题地址 != nil) {
            push.安装主题(直接添加主题地址!)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = self.storyboard
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            let push = storyboard?.instantiateViewController(withIdentifier: "Color")
            push!.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(push!, animated: true)
            break
        case 1:
            前往主题管理(nil)
            break
        case 2:
            let push = SourceTableViewController()
            push.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(push, animated: true)
            break
        case 3:
            let push:SettingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting") as! SettingViewController
            push.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(push, animated: true)
            break
        case 4:
            let push:UIViewController = (storyboard?.instantiateViewController(withIdentifier: "About"))!
            push.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(push, animated: true)
            break
        default:
            break
        }
    
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
