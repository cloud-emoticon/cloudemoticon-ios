//
//  MyEmoticonViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/20.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit
import CoreImage
import GLKit
import OpenGLES

class MyEmoticonViewController: UIViewController, UITableViewDelegate, UIAlertViewDelegate, UITableViewDataSource {
    
    let 文件管理器:FileManager = FileManager()
    var 表格数据:NSMutableArray = NSMutableArray()
    var 列表文字颜色:UIColor = UIColor.black
    var 列表当前选中的行背景色:UIColor = UIColor.lightGray
    var 列表当前选中的行背景图片:UIImage? = nil

    @IBOutlet weak var 背景: UIView!
    @IBOutlet weak var 无颜文字: UIImageView!
    @IBOutlet weak var 无颜文字文字: UILabel!
    
    @IBOutlet weak var bgpview: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector:#selector(MyEmoticonViewController.appWillResignActive), name:NSNotification.Name(rawValue: "WillEnterForeground"), object: nil)

        右上按钮.title = lang.uage("编辑")
        左上按钮.title = ""
        表格.delegate = self
        表格.dataSource = self
        表格.backgroundColor = UIColor.clear
        
        self.title = lang.uage("自定表情")
//        self.tabBarController?.tabBar.translucent = false
//        self.navigationController?.navigationBar.translucent = false
        self.language()
        
         //MARK - 主题

        self.navigationController?.navigationBar.barTintColor = UIColor(red: 33/255.0, green: 150/255.0, blue:243/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.tabBarController?.tabBar.tintColor = UIColor(red: 33/255.0, green: 150/255.0, blue:243/255.0, alpha: 1)//tabbar选中文字颜色
        let tbitemcolor = NSDictionary(object: UIColor.black,
            forKey:convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) as NSCopying)
        NotificationCenter.default.addObserver(self, selector: #selector(MyEmoticonViewController.切换主题), name: NSNotification.Name(rawValue: "切换主题通知"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MyEmoticonViewController.屏幕旋转), name: NSNotification.Name(rawValue: "屏幕旋转通知"), object: nil)
        切换主题()
    }
    
    @objc func 屏幕旋转() {
        刷新背景图()
    }
    
    @objc func 切换主题() {
        NSLog("[Skin]->MyEmoticonViewController")
        //默认设置
        列表当前选中的行背景色 = 全局_默认当前选中行颜色
        UINavigationBar.appearance().setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.barTintColor = 全局_默认导航栏背景颜色
        左上按钮.tintColor = UIColor.white
        右上按钮.tintColor = UIColor.white
        let navigation_seg_tintcolor_dic:NSDictionary = NSDictionary(object: UIColor.white, forKey:convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) as NSCopying)
        self.navigationController?.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary(navigation_seg_tintcolor_dic as? [String : AnyObject])
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UISegmentedControl.appearance().tintColor = UIColor.white
        表格.backgroundColor = nil
        列表文字颜色 = UIColor.black
        列表当前选中的行背景色 = 全局_默认当前选中行颜色
        列表当前选中的行背景图片 = nil
        //背景图默认设置
        bgpview.image = nil
        bgpview.alpha = 1
        bgpview.contentMode = UIView.ContentMode.scaleAspectFill
        
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
            //图片文件名：顶端导航栏两侧按钮颜色 yes
            let navigation_btn_textcolor_S:String = 全局_皮肤设置.object(forKey: "navigation_btn_textcolor") as! String
            NSLog("[Skin]navigation_btn_textcolor_S=%@",navigation_btn_textcolor_S)
            if (navigation_btn_textcolor_S != "null") {
                let navigation_btn_textcolor:UIColor? = 主题参数转对象.color(navigation_btn_textcolor_S) //navigation_btn_textcolor_S
                if (navigation_btn_textcolor != nil) {
//                    self.navigationController?.navigationBar.tintColor = navigation_btn_textcolor
                    左上按钮.tintColor = navigation_btn_textcolor
                    右上按钮.tintColor = navigation_btn_textcolor
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
            
            //RGBA色值：顶端收藏历史自定义选项卡颜色 yes
            let navigation_seg_bar_S:String = 全局_皮肤设置.object(forKey: "navigation_seg_bar") as! String
            NSLog("[Skin]navigation_seg_bar_S=%@",navigation_seg_bar_S)
            if (navigation_seg_bar_S != "null") {
                let navigation_seg_bar:UIColor? = 主题参数转对象.color(navigation_seg_bar_S) //navigation_seg_bar_S
                if (navigation_seg_bar != nil) {
                    self.navigationController?.navigationBar.tintColor = navigation_seg_bar
                    UISegmentedControl.appearance().tintColor = navigation_seg_bar
                }
            }
            //RGBA色值：顶端收藏历史自定义选项卡未选定时文字颜色 yes
//            let navigation_seg_bartext_S:String = 全局_皮肤设置.objectForKey("navigation_seg_bartext") as! String
//            NSLog("[Skin]navigation_seg_bartext_S=%@",navigation_seg_bartext_S)
//            if (navigation_seg_bartext_S != "null") {
//                let navigation_seg_bartext:UIColor? = 主题参数转对象.color(navigation_seg_bartext_S) //navigation_seg_bartext_S
//                if (navigation_seg_bartext != "null") {
//                    let navigation_seg_bartext_dic:NSDictionary = NSDictionary(object: navigation_seg_bartext!,
//                        forKey:NSForegroundColorAttributeName)
//                    UISegmentedControl.appearance().setTitleTextAttributes(navigation_seg_bartext_dic as [NSObject : AnyObject], forState: UIControlState.Normal)
//                    self.navigationController?.navigationBar.backgroundColor = navigation_seg_bartext
//                    UISegmentedControl.appearance().backgroundColor = navigation_seg_bartext
//                }
//            }
            
            //TableView
            //RGBA色值：列表的背景色 yes
            let table_bgcolor_S:String = 全局_皮肤设置.object(forKey: "table_bgcolor") as! String
            NSLog("[Skin]table_bgcolor_S=%@",table_bgcolor_S)
            if (table_bgcolor_S != "null") {
                let table_bgcolor:UIColor? = 主题参数转对象.color(table_bgcolor_S) //table_bgcolor_S
                if (table_bgcolor != nil) {
                    表格.backgroundColor = table_bgcolor
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
            
            //背景图
            刷新背景图()
            表格.reloadData()
        }
    }
    
    func 刷新背景图() {
        let 启用修改背景:Bool = UserDefaults.standard.bool(forKey: "diybg")
        if (启用修改背景) {
            NSLog("[Skin]背景图被用户替换")
            let bg:UIImage? = loadbg()
            bgpview.image = bgimage
            if(bg != defaultimage){
                bgpview.contentMode = UIView.ContentMode.scaleAspectFill
            } else {
                bgpview.contentMode = UIView.ContentMode.scaleAspectFit
            }
            bgpview.alpha = loadopc()
        } else {
            let 主题参数转对象:Skin2Object = Skin2Object()
            let 取背景图:String = 主题参数转对象.判断应该显示的背景图()
            let background_image_S:String? = 全局_皮肤设置.object(forKey: 取背景图) as? String
            if (background_image_S != nil && background_image_S != "null") {
                NSLog("[Skin]%@_S=%@",取背景图,background_image_S!)
                let background_image:UIImage? = 主题参数转对象.image(background_image_S) //table_selectimage_S
                if (background_image != nil) {
                    bgpview.image = background_image!
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(表格.isEditing){
            if(内容选择菜单.selectedSegmentIndex == 0){
                左上按钮.title = ""
                右上按钮.title = lang.uage("完成")
            }
            if(内容选择菜单.selectedSegmentIndex == 2){
                左上按钮.title = lang.uage("完成")
                右上按钮.title = ""
            }
        } else {
            if(内容选择菜单.selectedSegmentIndex == 0){
                左上按钮.title = ""
                右上按钮.title = lang.uage("编辑")
            }
            if(内容选择菜单.selectedSegmentIndex == 2){
                左上按钮.title = lang.uage("编辑")
                右上按钮.title = lang.uage("添加")
            }
        }
        
    }
    
    @objc func appWillResignActive(){
        if(内容选择菜单.selectedSegmentIndex == 1){
            载入历史记录数据()
        }
        if(内容选择菜单.selectedSegmentIndex == 2){
            载入自定义数据()
        }
    }
    
    func 生成无颜文字遮罩(){
        
        背景.backgroundColor = UIColor.white
        if (bgpview.image == nil) {
            无颜文字.image = nil
        } else {
            let bg:CIImage? = CIImage(image: bgpview.image!)
            let 模糊过滤器 = CIFilter(name: "CIGaussianBlur")
            模糊过滤器!.setValue(25, forKey: "InputRadius")
            模糊过滤器!.setValue(bg, forKey: "InputImage")
            let ciContext = CIContext(eaglContext: EAGLContext(api: .openGLES2)!)  //使用GPU方式，报错为Bug无视
            let cgImage = ciContext.createCGImage(模糊过滤器!.outputImage!, from: bg!.extent)
            ciContext.draw(模糊过滤器!.outputImage!, in: bg!.extent, from: bg!.extent)
            let 模糊图像 = UIImage(cgImage: cgImage!)
            //        let 背景透明度:CGFloat = (1 - loadopc()) * 0.7 + 0.3
            //        无颜文字.alpha = 背景透明度
            无颜文字.image = 模糊图像
        }
        无颜文字.contentMode = bgpview.contentMode
        显示文字()
    }
    
    func 显示文字()
    {
    switch (内容选择菜单.selectedSegmentIndex) {
        case 0:
            无颜文字文字.text = lang.uage("还没有收藏的颜文字喵")
            break
        case 1:
            无颜文字文字.text = lang.uage("还没有历史记录呢喵")
            break
        case 2:
            无颜文字文字.text = lang.uage("还没有添加自定义颜文字呢喵")
            break
        default:
            break
        }
        
        let 背景透明度:CGFloat = 1 - loadopc()
        
        if(背景透明度 < 0.35){
            无颜文字文字.textColor = UIColor.gray
            无颜文字文字.shadowColor = UIColor.white
        } else {
            无颜文字文字.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
            无颜文字文字.shadowColor = UIColor.white
        } //else {
//            无颜文字文字.textColor = UIColor.whiteColor()
//            无颜文字文字.shadowColor = UIColor.grayColor()
//        }
        
        无颜文字文字.backgroundColor = UIColor.clear
        无颜文字文字.font = UIFont.boldSystemFont(ofSize: 22)
        无颜文字文字.textAlignment = NSTextAlignment.center
        
        无颜文字文字.shadowOffset = CGSize(width: 1, height: 1)
        无颜文字文字.alpha = 0.8
        
        背景.isHidden = false
    }
    
    @IBOutlet weak var 左上按钮: UIBarButtonItem!
    @IBOutlet weak var 表格: UITableView!
    @IBOutlet weak var 右上按钮: UIBarButtonItem!
    @IBOutlet weak var 内容选择菜单: UISegmentedControl!
    
    func language() {
        内容选择菜单.setTitle(lang.uage("收藏"), forSegmentAt: 0)
        内容选择菜单.setTitle(lang.uage("历史记录"), forSegmentAt: 1)
        内容选择菜单.setTitle(lang.uage("自定义"), forSegmentAt: 2)
    }
    
    @IBAction func 左上按钮(_ sender: UIBarButtonItem) {
        
        switch (内容选择菜单.selectedSegmentIndex) {
        case 0:
            break
        case 1:
            break
        case 2:
            表格.setEditing(!表格.isEditing, animated: true)
            if(表格.isEditing){
                左上按钮.title = lang.uage("完成")
                右上按钮.title = ""
            } else {
                左上按钮.title = lang.uage("编辑")
                右上按钮.title = lang.uage("添加")
            }
        default:
            break
        }
    }
    
    
    @IBAction func 右上按钮(_ sender: UIBarButtonItem)
    {
        switch (内容选择菜单.selectedSegmentIndex) {
        case 0:
            表格.setEditing(!表格.isEditing, animated: true)
            if (表格.isEditing) {
                左上按钮.title = ""
                右上按钮.title = lang.uage("完成")
            } else {
                左上按钮.title = ""
                右上按钮.title = lang.uage("编辑")
            }
            表格.reloadData()
            保存收藏数据()
            break
        case 1:
            表格数据.removeAllObjects()
            表格.reloadData()
            保存历史记录数据()
            if (appgroup) {
//                var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CloudEmoticon")!
//                containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
//                var emolist:NSString? = NSString(contentsOfURL: containerURL, encoding: NSUTF8StringEncoding, error: nil)
//                var 文件中的数据:NSArray = ArrayString().json2array(emolist!) as NSArray
//                var 新建数据模型:NSArray = [文件中的数据.objectAtIndex(0),文件中的数据.objectAtIndex(1),NSArray()]
//                var value:NSString = ArrayString().array2json(新建数据模型)
//                value.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
//                NSLog("Group写入操作")
                let 组数据读写:AppGroupIO = AppGroupIO()
                let 组数据:NSArray? = 组数据读写.读取设置UD模式()
                if (组数据 != nil) {
                    let 新建数据模型:NSArray = [组数据!.object(at: 0),组数据!.object(at: 1),NSArray(),组数据!.object(at: 3)]
                    组数据读写.写入设置UD模式(新建数据模型)
                }
            }
            自动遮罩()
            break
        case 2:
            if (!表格.isEditing) {
                右上按钮.title = lang.uage("添加")
                左上按钮.title = lang.uage("编辑")
                let alert:UIAlertView = UIAlertView(title: lang.uage("添加颜文字"), message: "", delegate: self, cancelButtonTitle: lang.uage("取消"), otherButtonTitles: lang.uage("添加"))
                alert.alertViewStyle = UIAlertViewStyle.plainTextInput
                let alertImport:UITextField = alert.textField(at: 0) as UITextField!
                alert.tag = 300
                alertImport.keyboardType = UIKeyboardType.URL
                alertImport.text = ""
                alert.show()
            } else {
                右上按钮.title = ""
                左上按钮.title = lang.uage("完成")
            }
            表格.reloadData()
            保存自定义数据()
            break
        default:
            break
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        let alertImport:UITextField = alertView.textField(at: 0) as UITextField!
        if (alertView.tag == 300) {
            if (buttonIndex == 1) {
                //添加
                addemoticon(alertImport.text! as NSString)
                载入自定义数据()
                自动遮罩()
            }
        }
    }
    
    
    func addemoticon(_ emoticonstr:NSString)
    {
        let 颜文字名称:NSString = lang.uage("自定义") as NSString
        let 要添加的颜文字数组:NSArray = [emoticonstr,""]
        let 自定义:NSMutableArray = NSMutableArray()
        let 自定义颜文字:NSString = 要添加的颜文字数组.object(at: 0)as! NSString
        let 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.custom)
        var 自定义中已经存在这个颜文字 = false
        for 文件中的颜文字数组对象 in 文件中的数据! {
            let 文件中的颜文字数组:NSArray = 文件中的颜文字数组对象 as! NSArray
            let 文件中的颜文字:NSString = 文件中的颜文字数组.object(at: 0) as! NSString
            
            if ( 自定义颜文字.isEqual(to: 文件中的颜文字 as String)) {
                自定义中已经存在这个颜文字 = true
            }
        }
        if(!自定义中已经存在这个颜文字)
        {
            自定义.add(要添加的颜文字数组)
        }
        if (文件中的数据 != nil) {
            自定义.addObjects(from: 文件中的数据! as [AnyObject])
        }
        文件管理器.SaveArrayToFile(自定义,smode: FileManager.saveMode.custom)
        保存数据到输入法()
    }
    
    @IBAction func 内容选择菜单(_ 内容选择: UISegmentedControl)
    {
        表格.setEditing(false, animated: true)
        changemode(内容选择.selectedSegmentIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        changemode(内容选择菜单.selectedSegmentIndex)
    }
    
    // MARK: - 载入数据
    func changemode(_ id:Int)
    {
        背景.isHidden = true
        switch (id) {
        case 0:
            载入收藏数据()
            右上按钮.title = lang.uage("编辑")
            左上按钮.title = ""
            break
        case 1:
            载入历史记录数据()
            左上按钮.title = ""
            右上按钮.title = lang.uage("清空")
            break
        case 2:
//            var value:NSString? = nil
//            if (appgroup) {
//                var containerURL:NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.CE2NCWidget")!
//                containerURL = containerURL.URLByAppendingPathComponent("Library/caches/CE2")
//                value = NSString.stringWithContentsOfURL(containerURL, encoding: NSUTF8StringEncoding, error: nil)
//                if(value != nil && value != "") {
//                    addemoticon(value!)
//                }
//                value = ""
//                value?.writeToURL(containerURL, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
//            NSLog("Group写入操作")
//            }
            载入自定义数据()
            左上按钮.title = lang.uage("编辑")
            右上按钮.title = lang.uage("添加")
            break
        default:
            break
        }
    }
    func 载入收藏数据()
    {
        let 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.favorite)
        
        将数据载入表格(文件中的数据)
    }
    func 载入历史记录数据()
    {
        let 组数据读写:AppGroupIO = AppGroupIO()
        let 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.history)
        var 输入法中的数据:NSArray? = nil
        if (appgroup && 组数据读写.检查设置UD模式()) {
            输入法中的数据 = 组数据读写.读取设置UD模式()
        }
        if(输入法中的数据 != nil) {
            let 输入法中的历史记录数据:NSArray = 输入法中的数据?.object(at: 2) as! NSArray
            if (输入法中的历史记录数据.count != 0) {
                NSLog("历史记录：输入法中的数据")
                将数据载入表格(输入法中的历史记录数据)
                文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.history)
            } else {
                NSLog("历史记录：载入文件中的数据")
                将数据载入表格(文件中的数据)
            }
        } else {
            NSLog("历史记录：输入法中没有数据，载入文件中的数据")
            将数据载入表格(文件中的数据)
        }
    }
    func 载入自定义数据()
    {
        let 组数据读写:AppGroupIO = AppGroupIO()
        let 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.custom)
        var 输入法中的数据:NSArray? = nil
        if (appgroup && 组数据读写.检查设置UD模式()) {
            输入法中的数据 = 组数据读写.读取设置UD模式()
        }
        if(输入法中的数据 != nil) {
            let 输入法中的自定义数据:NSArray = 输入法中的数据?.object(at: 1) as! NSArray
            if (输入法中的自定义数据.count != 0) {
                NSLog("自定义：输入法中的数据")
                将数据载入表格(输入法中的自定义数据)
                文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.custom)
            } else {
                NSLog("自定义：载入文件中的数据")
                将数据载入表格(文件中的数据)
            }
        } else {
            NSLog("自定义：输入法中没有数据，载入文件中的数据")
            将数据载入表格(文件中的数据)
        }
        
    }
    func 将数据载入表格(_ 文件中的数据:NSArray?)
    {
        表格数据.removeAllObjects()
        var 表格内容为空:Bool = true
        if (文件中的数据 != nil) {
            表格数据.addObjects(from: 文件中的数据! as [AnyObject])
            if (表格数据.count > 0) {
                表格内容为空 = false
            }
        }
        if (表格内容为空) {
            生成无颜文字遮罩()
        } else {
            背景.isHidden = true
        }
        表格.reloadData()
    }
    
    func 自动遮罩() {
        if (表格数据.count == 0) {
            生成无颜文字遮罩()
        } else {
            背景.isHidden = true
        }
    }
    
    // MARK: - 保存数据
    func 保存收藏数据()
    {
        文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.favorite)
        保存数据到输入法()
    }
    func 保存历史记录数据()
    {
        文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.history)
        保存数据到输入法()
    }
    func 保存自定义数据()
    {
        文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.custom)
        保存数据到输入法()
    }
    
    // MARK: - 表格数据
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (表格数据.count > 0) {
            tableView.isUserInteractionEnabled = true
            return 表格数据.count
        }
        tableView.isUserInteractionEnabled = false
        return 表格数据.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let CellIdentifier:NSString = "Cell"
        var cell:UITableViewCell? = 表格.dequeueReusableCell(withIdentifier: CellIdentifier as String)! as UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: CellIdentifier as String)
            cell!.selectionStyle = UITableViewCell.SelectionStyle.blue
            cell?.backgroundColor = UIColor.clear
            let 选中行背景视图:UIImageView = UIImageView(frame: cell!.frame)
//            选中行背景视图.backgroundColor = UIColor.orangeColor()
            cell?.selectedBackgroundView = 选中行背景视图
        }
        if (表格数据.count > 0) {
            let 选中行背景视图:UIImageView = cell?.selectedBackgroundView as! UIImageView
            选中行背景视图.backgroundColor = 列表当前选中的行背景色
            选中行背景视图.image = 列表当前选中的行背景图片
            cell?.textLabel?.textColor = 列表文字颜色
            
            let 当前单元格数据:NSArray = 表格数据.object(at: (indexPath as NSIndexPath).row) as! NSArray
            if (当前单元格数据.count < 1) {
                cell?.textLabel?.text = "<错误数据>"
            } else {
                let 颜文字:NSString = 当前单元格数据.object(at: 0) as! NSString
                var 颜文字名称:NSString?
                if (当前单元格数据.count > 1 && 颜文字名称 != nil) {
                    颜文字名称! = 当前单元格数据.object(at: 1) as! NSString
                }
                cell?.textLabel?.text = 颜文字 as String
                if (颜文字名称 != nil) {
                    cell?.detailTextLabel?.text = 颜文字名称! as String
                } else {
                    cell?.detailTextLabel?.text = ""
                }
            }
        }
        else {
           //            switch (内容选择菜单.selectedSegmentIndex) {
//            case 0:
//                cell?.textLabel?.text = lang.uage("还没有收藏的颜文字喵")
//                break
//            case 1:
//                cell?.textLabel?.text = lang.uage("还没有历史记录呢喵")
//                break
//            case 2:
//                cell?.textLabel?.text = lang.uage("还没有添加自定义颜文字呢喵")
//                break
//            default:
//                break
//            } 
//            生成无颜文字遮罩()
            cell?.textLabel?.text = ""
            cell?.detailTextLabel?.text = ""
        }
        cell?.textLabel?.lineBreakMode = NSLineBreakMode.byCharWrapping
        cell?.textLabel?.numberOfLines = 0
        
        return cell!
    }
    
    //    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    //
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let 要复制的文本数组:NSArray = 表格数据.object(at: (indexPath as NSIndexPath).row) as! NSArray
        NotificationCenter.default.post(name: Notification.Name(rawValue: "复制到剪贴板通知"), object: 要复制的文本数组, userInfo: nil)
        if (内容选择菜单.selectedSegmentIndex == 1) {
            载入历史记录数据()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - 表格编辑范围
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
//        if (内容选择菜单.selectedSegmentIndex == 1) {
//            return UITableViewCellEditingStyle.None
//        }
        return UITableViewCell.EditingStyle.delete
    }
    // MARK: - 表格是否可以移动项目
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    // MARK: - 表格是否可以编辑
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    // MARK: - 表格项目被移动
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let fromRow:NSInteger = (sourceIndexPath as NSIndexPath).row
        let toRow:NSInteger = (destinationIndexPath as NSIndexPath).row
        let object: AnyObject = 表格数据.object(at: fromRow) as AnyObject
        表格数据.removeObject(at: fromRow)
        表格数据.insert(object, at: toRow)
        switch(内容选择菜单.selectedSegmentIndex) {
        case 0:
            文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.favorite)
            break
        case 1:
            文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.history)
            break
        case 2:
            文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.custom)
            break
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            switch (内容选择菜单.selectedSegmentIndex) {
            case 0:
                let 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.favorite)
                let nowrow:NSInteger = (indexPath as NSIndexPath).row
                let nowrowArr:NSArray = 文件中的数据!.object(at: nowrow) as! NSArray
                let nowemo:NSString = nowrowArr.object(at: 0) as! NSString
                表格数据.removeObject(at: nowrow)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                if(文件中的数据 != nil){
                    
                    文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.favorite)
                } else {
                    let fileName:NSString = 文件管理器.FileName(FileManager.saveMode.favorite)
                    let fulladd:NSString = 文件管理器.FileNameToFullAddress(fileName)
                    文件管理器.deleteFile(fulladd, smode: FileManager.saveMode.favorite)
                }
                break
            case 1:
                let 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.history)
                let nowrow:NSInteger = (indexPath as NSIndexPath).row
                let nowrowArr:NSArray = 文件中的数据!.object(at: nowrow) as! NSArray
                let nowemo:NSString = nowrowArr.object(at: 0) as! NSString
                表格数据.removeObject(at: nowrow)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                if(文件中的数据 != nil){
                    
                    文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.history)
                } else {
                    let fileName:NSString = 文件管理器.FileName(FileManager.saveMode.history)
                    let fulladd:NSString = 文件管理器.FileNameToFullAddress(fileName)
                    文件管理器.deleteFile(fulladd, smode: FileManager.saveMode.history)
                }
                break
            case 2:
                let 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.custom)
                let nowrow:NSInteger = (indexPath as NSIndexPath).row
                let nowrowArr:NSArray = 文件中的数据!.object(at: nowrow) as! NSArray
                let nowemo:NSString = nowrowArr.object(at: 0) as! NSString
                表格数据.removeObject(at: nowrow)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                if(文件中的数据 != nil){
                    
                    文件管理器.SaveArrayToFile(表格数据, smode: FileManager.saveMode.custom)
                } else {
                    let fileName:NSString = 文件管理器.FileName(FileManager.saveMode.custom)
                    let fulladd:NSString = 文件管理器.FileNameToFullAddress(fileName)
                    文件管理器.deleteFile(fulladd, smode: FileManager.saveMode.custom)
                }
                break
            default:
                break
            }
            自动遮罩()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return lang.uage("删掉喵")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (表格数据.count > 0) {
            var 文字高度:CGFloat = 44
            let emoobj:NSArray = 表格数据.object(at: (indexPath as NSIndexPath).row) as! NSArray
            let 主文字内容:NSString = emoobj.object(at: 0) as! NSString
            var 副文字内容:NSString = ""
            let 主文字框高度:CGFloat = 计算单元格高度(主文字内容, 字体大小: 17, 单元格宽度: tableView.frame.width - 20) + 8
            if (emoobj.count > 1) {
                副文字内容 = emoobj.object(at: 1) as! NSString
                let 副文字框高度:CGFloat = 计算单元格高度(副文字内容, 字体大小: 12, 单元格宽度: tableView.frame.width - 20) - 13
                文字高度 = 主文字框高度 + 副文字框高度 + 15
            } else {
                文字高度 = 主文字框高度 + 15
            }
            if (文字高度 < 44) {
                return 44
            } else {
                return 文字高度
            }
        }
        return 44
    }
    
    func 计算单元格高度(_ 要显示的文字:NSString, 字体大小:CGFloat, 单元格宽度:CGFloat) -> CGFloat
    {
        let 高度测试虚拟标签:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 单元格宽度, height: 0))
        高度测试虚拟标签.font = UIFont.systemFont(ofSize: 字体大小)
        高度测试虚拟标签.text = NSString(string: 要显示的文字) as String
        高度测试虚拟标签.lineBreakMode = NSLineBreakMode.byCharWrapping
        高度测试虚拟标签.numberOfLines = 0
        var 计算后尺寸:CGSize = 高度测试虚拟标签.sizeThatFits(CGSize(width: 单元格宽度,height: CGFloat.greatestFiniteMagnitude))
        计算后尺寸.height = ceil(计算后尺寸.height)
        return 计算后尺寸.height
    }
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
