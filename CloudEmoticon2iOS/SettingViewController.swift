//
//  SettingViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫喵 on 14/8/26.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {

    var adflist:NSMutableArray = NSMutableArray()
    var actlist:NSMutableArray = NSMutableArray()
    
    var SetTable:UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width), style: UITableViewStyle.grouped)
    
    var 设置广告显示频率:UISlider = UISlider()
    var 设置复制后退出应用:UISwitch = UISwitch()

    var defaults:UserDefaults = UserDefaults.standard
    var adf:Float? = UserDefaults.standard.value(forKey: "adfrequent") as? Float
    var copyexit:Bool? = UserDefaults.standard.value(forKey: "exitaftercopy") as? Bool
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = lang.uage("设置")
        SetTable.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        adflist.add(lang.uage("广告显示频率"))
        adflist.add("")
        adflist.add(lang.uage("复制后退出"))
        adflist.add(lang.uage("抹掉所有内容和设置"))
        SetTable.delegate = self
        SetTable.dataSource = self
        view.addSubview(SetTable)
        loadSetting()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveSetting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(section == 0)
        {
            return 2
        } else if(section == 1) {
            return 1
        } else {
            return 1
        }
    }
    
    func  tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if(section == 0)
        {
            return lang.uage("广告")
        } else if(section == 1) {
            return lang.uage("行为")
        } else {
            return lang.uage("还原")
        }
    }
    
    func loadSetting()
    {
        设置复制后退出应用.setOn(defaults.bool(forKey: "exitaftercopy"), animated: false)
        设置广告显示频率.value = defaults.float(forKey: "adfrequent")
    }
    func saveSetting()
    {
        defaults.set(设置复制后退出应用.isOn, forKey: "exitaftercopy")
        defaults.set(设置广告显示频率.value, forKey: "adfrequent")
        defaults.synchronize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if(adf == nil){
        adf = 100
        }
        if(copyexit == nil){
        copyexit = false
        }
        设置广告显示频率.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - 36, height: 20)
        设置广告显示频率.minimumValue = 0
        设置广告显示频率.maximumValue = 100
        设置广告显示频率.value = adf!
        设置复制后退出应用.frame = CGRect.zero
        设置复制后退出应用.isOn = copyexit!

        let CellIdentifier:NSString = "SettingCell"
        var cell:UITableViewCell? = SetTable.dequeueReusableCell(withIdentifier: CellIdentifier as String)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CellIdentifier as String)
        }
        
        if((indexPath as NSIndexPath).section == 0) {
        cell!.textLabel?.text = adflist.object(at: (indexPath as NSIndexPath).row) as? String
        }
        
        if (cell!.contentView.subviews.count > 1) {
            print("cell!.contentView.subviews.count > 1")
        }
        
        if((indexPath as NSIndexPath).section == 1) {
        cell!.textLabel?.text = adflist.object(at: (indexPath as NSIndexPath).row + 2) as? String
        }
        if((indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1){
            cell!.accessoryView = 设置广告显示频率
            
            
            设置广告显示频率.addTarget(self, action: #selector(getter: SettingViewController.设置广告显示频率), for: .touchUpInside)
            设置广告显示频率.tag = 1001
            cell!.contentView.addSubview(设置广告显示频率)
        } else if((indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 0){
                cell!.accessoryView = 设置复制后退出应用
            设置复制后退出应用.addTarget(self, action: #selector(getter: SettingViewController.设置复制后退出应用), for: .valueChanged)
            设置复制后退出应用.tag = 1002
            cell!.contentView.addSubview(设置复制后退出应用)
        } else if((indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 0) {
            cell!.textLabel?.text = adflist.object(at: 3) as? String
            cell!.textLabel?.textColor = UIColor.red
        }
        
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 0) {
            //抹掉所有内容和设置
            let 重置提示框:UIAlertView = UIAlertView(title: lang.uage("还原"), message: lang.uage("将要清除"), delegate: self, cancelButtonTitle: lang.uage("取消"), otherButtonTitles: lang.uage("抹掉这些内容"))
            重置提示框.tag = 10086
            重置提示框.show()
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if (alertView.tag == 10086 && buttonIndex == 1) {
            NSLog("执行重置")
            let 内容重置:ResetSetting = ResetSetting()
            内容重置.清除Document文件夹()
            内容重置.清除应用设置()
            内容重置.清除AppGroup设置()
            let 屏蔽画面:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            屏蔽画面.backgroundColor = UIColor.black
            self.view.addSubview(屏蔽画面)
            let 重置完毕提示框:UIAlertView = UIAlertView(title: lang.uage("还原"), message: lang.uage("抹掉成功"), delegate: self, cancelButtonTitle: lang.uage("退出云颜文字2"))
            重置完毕提示框.tag = 10087
            重置完毕提示框.show()
        } else if (alertView.tag == 10087) {
            NSLog("执行重置完毕，退出")
            exit(0)
        }
    }
    
    func updateSwitchAtIndesPath(_ sender:UISwitch){
        let switchview:UISwitch = sender
              defaults.set(switchview.isOn, forKey: "exitaftercopy")
        defaults.synchronize()
    }
    
    func updateSliderAtIndesPath(_ sender:UISlider){
        let sliderview:UISlider = sender
        defaults.set(sliderview.value, forKey: "adfrequent")
        defaults.synchronize()
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
