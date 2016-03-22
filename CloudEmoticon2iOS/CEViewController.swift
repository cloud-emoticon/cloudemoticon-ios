//
//  CEViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 14/8/12.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit


class CEViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UIScrollViewDelegate, SourceTableViewControllerDelegate, CETableViewCellDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, QRViewDelegate, UserTableHeaderViewDelegate {

    
    @IBOutlet weak var sortBtn: UIBarButtonItem!
    @IBOutlet weak var scoreBtn: UIBarButtonItem!
    
    let className = "[云颜文字]"
    let 文件管理器 = FileManager()
    var 分类表格:UITableView = UITableView()
    var 颜文字表格:UITableView = UITableView()
    var 颜文字表格背景:UIImageView = UIImageView()
    var 搜索颜文字:UISearchBar = UISearchBar()
    var 搜索结果:NSMutableArray = NSMutableArray()
    var 搜索结果的名称:NSMutableArray = NSMutableArray()
    var 用户登录视图:UserTableHeaderView = UserTableHeaderView()
    var username:UILabel = UILabel()
    var 下拉刷新提示:UILabel? = nil
    var 表格初始滚动位置:CGFloat = 0
    var 下拉刷新动作中:Bool = false
    var 菜单滑动中:Bool = false
    var 当前分类:Int = 0
    var 源管理页面:SourceTableViewController? = nil
    var 调整搜索栏位置:Bool = true
    var 当前源:NSString = NSString()
    var 当前源文字框:UILabel = UILabel()
    var 二维码缓存:UIImage = UIImage()
    
//    var userimg:UIImageView = UIImageView(image:UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("nowuserimg", ofType: "jpg")!))
    
    var 滑动最大X坐标:CGFloat = 0
    var 手势起始位置X坐标:CGFloat = 0
    var 手势中:Bool = false
    var sortData:NSMutableArray = NSMutableArray()
    var ceData:NSMutableArray = NSMutableArray()
    //主题属性
    var 列表文字颜色:UIColor = UIColor.blackColor()
    var 副标题列表文字颜色:UIColor = UIColor.grayColor()
    var 列表当前选中的行背景色:UIColor = UIColor.lightGrayColor()
    var 列表当前选中的行背景图片:UIImage? = nil
    var 云颜文字左侧分类列表文字颜色:UIColor = UIColor.blackColor()
    var 云颜文字左侧分类列表选中行背景色:UIColor = UIColor.lightGrayColor()
    var 云颜文字左侧分类列表选中行背景图片:UIImage? = nil
    var 下拉刷新提示文本颜色:UIColor = UIColor.grayColor()
    
    @IBOutlet weak var bgpview: UIImageView!
    
    func language()
    {
        scoreBtn.title = lang.uage("源管理")
        self.title = lang.uage("云颜文字")
    }

//MARK - 主题
    
    func loadbgi(){
        let bg:UIImage? = loadbg()
        if(bg != defaultimage){
            bgpview.image = bgimage
            bgpview.contentMode = UIViewContentMode.ScaleAspectFill
        } else {
            bgpview.image = bgimage
            bgpview.contentMode = UIViewContentMode.ScaleAspectFit
        }
        颜文字表格背景.image = bgimage
        颜文字表格背景.contentMode = bgpview.contentMode
        
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
    
    override func viewDidLoad() {
        //Load UI
        
        //MARK - 主题
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 33/255.0, green: 150/255.0, blue:243/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let titlecolor = NSDictionary(object: UIColor.whiteColor(),
            forKey:NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = titlecolor as? [String : AnyObject]
        self.title = lang.uage("云颜文字") as String
        载入视图()
        
        //Load Data
        分类表格.delegate = self
        分类表格.dataSource = self
        分类表格.backgroundColor = UIColor.clearColor()
        颜文字表格.delegate = self
        颜文字表格.dataSource = self
        颜文字表格.backgroundColor = UIColor.clearColor()
        搜索颜文字.searchBarStyle = UISearchBarStyle.Minimal
        搜索颜文字.placeholder = lang.uage("搜索颜文字")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CEViewController.切换主题), name: "切换主题通知", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CEViewController.屏幕旋转 as (CEViewController) -> () -> ()), name: "屏幕旋转通知", object: nil)
//        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "延迟切换主题", userInfo: nil, repeats: false)
        用户登录视图.载入内容()
        切换主题()
        载入数据(NetDownloadTo.CLOUDEMOTICON)
        self.language()
        
        颜文字表格.contentOffset = CGPointMake(0, 颜文字表格.contentOffset.y-搜索颜文字.frame.size.height)
}
//    func 延迟切换主题() {
//        切换主题()
//    }
    
    func 屏幕旋转() {
        刷新背景图()
    }
    
    func 切换主题() {
        NSLog("[Skin]->CEViewController")
        列表当前选中的行背景色 = 全局_默认当前选中行颜色
        云颜文字左侧分类列表选中行背景色 = 全局_默认当前选中行颜色
        UINavigationBar.appearance().setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barTintColor = 全局_默认导航栏背景颜色
        sortBtn.tintColor = UIColor.whiteColor()
        scoreBtn.tintColor = UIColor.whiteColor()
        let navigation_seg_tintcolor_dic:NSDictionary = NSDictionary(object: UIColor.whiteColor(), forKey:NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigation_seg_tintcolor_dic as! [String : AnyObject]
        颜文字表格.backgroundColor = UIColor.whiteColor()
        列表文字颜色 = UIColor.blackColor()
        副标题列表文字颜色 = UIColor(red: 130/255.0, green: 130/255.0, blue: 130/255.0, alpha: 1)
        列表当前选中的行背景色 = 全局_默认当前选中行颜色
        列表当前选中的行背景图片 = nil
        分类表格.backgroundColor = UIColor.clearColor()
        bgpview.image = nil
        云颜文字左侧分类列表文字颜色 = UIColor.blackColor()
        云颜文字左侧分类列表选中行背景色 = 全局_默认当前选中行颜色
        云颜文字左侧分类列表选中行背景图片 = nil
        搜索颜文字.tintColor = UIColor(red: 201/255.0, green: 201/255.0, blue: 206/255.0, alpha: 1)
        let 搜索输入框:UITextField = 搜索颜文字.valueForKey("searchField") as! UITextField
        搜索输入框.textColor = UIColor.blackColor()
        下拉刷新提示文本颜色 = UIColor.blackColor()
        下拉刷新提示?.textColor = 下拉刷新提示文本颜色
        //背景图默认设置
        bgpview.alpha = 1
        颜文字表格背景.alpha = 1
        bgpview.contentMode = UIViewContentMode.ScaleAspectFill
        颜文字表格背景.contentMode = UIViewContentMode.ScaleAspectFill
        颜文字表格背景.image = nil
        bgpview.image = nil

        if (全局_皮肤设置.count > 0 && 全局_皮肤设置.objectForKey("md5") != nil) {
            let 主题参数转对象:Skin2Object = Skin2Object()
            
            //图片文件名：顶端导航栏背景图片 yes
            let navigation_bar_image_S:String = 全局_皮肤设置.objectForKey("navigation_bar_image") as! String
            NSLog("[Skin]navigation_bar_image_S=%@",navigation_bar_image_S)
            if (navigation_bar_image_S != "null") {
                let navigation_bar_image:UIImage? = 主题参数转对象.image(navigation_bar_image_S) //tool_backgroundimage_S
                if (navigation_bar_image != nil) {
                    UINavigationBar.appearance().setBackgroundImage(navigation_bar_image, forBarMetrics: UIBarMetrics.Default)
                }
            }
            //RGBA色值：顶端导航栏背景颜色 yes
            let navigation_bar_bgcolor_S:String = 全局_皮肤设置.objectForKey("navigation_bar_bgcolor") as! String
            NSLog("[Skin]tnavigation_bar_bgcolor_S=%@",navigation_bar_bgcolor_S)
            if (navigation_bar_bgcolor_S != "null") {
                let navigation_bar_bgcolor:UIColor? = 主题参数转对象.color(navigation_bar_bgcolor_S) //navigation_bar_bgcolor_S
                if (navigation_bar_bgcolor != nil) {
                    self.navigationController?.navigationBar.barTintColor = navigation_bar_bgcolor
                }
            }

            //图片文件名：顶端导航栏两侧按钮颜色 yes
            let navigation_btn_textcolor_S:String = 全局_皮肤设置.objectForKey("navigation_btn_textcolor") as! String
            NSLog("[Skin]navigation_btn_textcolor_S=%@",navigation_btn_textcolor_S)
            if (navigation_btn_textcolor_S != "null") {
                let navigation_btn_textcolor:UIColor? = 主题参数转对象.color(navigation_btn_textcolor_S) //navigation_btn_textcolor_S
                if (navigation_btn_textcolor != nil) {
                    sortBtn.tintColor = navigation_btn_textcolor
                    scoreBtn.tintColor = navigation_btn_textcolor
                }
            }
            
            //RGBA色值：顶端导航栏文字颜色 yes
            let navigation_seg_tintcolor_S:String = 全局_皮肤设置.objectForKey("navigation_seg_tintcolor") as! String
            NSLog("[Skin]navigation_seg_tintcolor_S=%@",navigation_seg_tintcolor_S)
            if (navigation_seg_tintcolor_S != "null") {
                let navigation_seg_tintcolor:UIColor? = 主题参数转对象.color(navigation_seg_tintcolor_S) //navigation_seg_tintcolor_S
                if (navigation_seg_tintcolor != "null") {
                    let navigation_seg_tintcolor_dic:NSDictionary = NSDictionary(object: navigation_seg_tintcolor!,
                        forKey:NSForegroundColorAttributeName)
                    self.navigationController?.navigationBar.titleTextAttributes = navigation_seg_tintcolor_dic as? [String : AnyObject]
                }
            }

            //RGBA色值：列表的背景色 yes
            let table_bgcolor_S:String = 全局_皮肤设置.objectForKey("table_bgcolor") as! String
            NSLog("[Skin]table_bgcolor_S=%@",table_bgcolor_S)
            if (table_bgcolor_S != "null") {
                let table_bgcolor:UIColor? = 主题参数转对象.color(table_bgcolor_S) //table_bgcolor_S
                if (table_bgcolor != nil) {
                    颜文字表格.backgroundColor = table_bgcolor
                }
            }
            //RGBA色值：列表文字颜色 yes
            let table_textcolor_S:String = 全局_皮肤设置.objectForKey("table_textcolor") as! String
            NSLog("[Skin]table_textcolor_S=%@",table_textcolor_S)
            if (table_textcolor_S != "null") {
                let table_textcolor:UIColor? = 主题参数转对象.color(table_textcolor_S) //table_textcolor_S
                if (table_textcolor != nil) {
                    列表文字颜色 = table_textcolor!
                }
            }
            //RGBA色值：副标题列表文字颜色 yes
            let table_textcolor_d_S:String = 全局_皮肤设置.objectForKey("table_textcolor_d") as! String
            NSLog("[Skin]table_textcolor_d_S=%@",table_textcolor_d_S)
            if (table_textcolor_d_S != "null") {
                let table_textcolor_d:UIColor? = 主题参数转对象.color(table_textcolor_d_S) //table_textcolor_d_S
                if (table_textcolor_d != nil) {
                    副标题列表文字颜色 = table_textcolor_d!
                }
            }
            //RGBA色值：列表当前选中的行背景色 yes
            let table_selectcolor_S:String = 全局_皮肤设置.objectForKey("table_selectcolor") as! String
            NSLog("[Skin]table_selectcolor_S=%@",table_selectcolor_S)
            if (table_selectcolor_S != "null") {
                let table_selectcolor:UIColor? = 主题参数转对象.color(table_selectcolor_S) //table_selectcolor_S
                if (table_selectcolor != nil) {
                    列表当前选中的行背景色 = table_selectcolor!
                }
            }
            //图片文件名：列表当前选中的行背景图片 yes
            let table_selectimage_S:String = 全局_皮肤设置.objectForKey("table_selectimage") as! String
            NSLog("[Skin]table_selectimage_S=%@",table_selectimage_S)
            if (table_selectimage_S != "null") {
                let table_selectimage:UIImage? = 主题参数转对象.image(table_selectimage_S) //table_selectimage_S
                if (table_selectimage != nil) {
                    列表当前选中的行背景图片 = table_selectimage!
                }
            }
            //RGBA色值：云颜文字左侧分类列表背景色 yes
            let cloudemo_typetable_bgcolor_S:String = 全局_皮肤设置.objectForKey("cloudemo_typetable_bgcolor") as! String
            NSLog("[Skin]cloudemo_typetable_bgcolor_S=%@",cloudemo_typetable_bgcolor_S)
            if (cloudemo_typetable_bgcolor_S != "null") {
                let cloudemo_typetable_bgcolor:UIColor? = 主题参数转对象.color(cloudemo_typetable_bgcolor_S) //cloudemo_typetable_bgcolor_S
                if (cloudemo_typetable_bgcolor != nil) {
                    分类表格.backgroundColor = cloudemo_typetable_bgcolor
                }
            }
            //图片文件名：云颜文字左侧分类列表背景图片
            let cloudemo_typetable_bgimage_S:String = 全局_皮肤设置.objectForKey("cloudemo_typetable_bgimage") as! String
            NSLog("[Skin]cloudemo_typetable_bgimage_S=%@",cloudemo_typetable_bgimage_S)
            if (cloudemo_typetable_bgimage_S != "null") {
                let cloudemo_typetable_bgimage:UIImage? = 主题参数转对象.image(cloudemo_typetable_bgimage_S) //cloudemo_typetable_bgimage_S
                if (cloudemo_typetable_bgimage != nil) {
                    bgpview.image = cloudemo_typetable_bgimage
                }
            }
            //RGBA色值：云颜文字左侧分类列表文字颜色
            let cloudemo_typetable_textcolor_S:String = 全局_皮肤设置.objectForKey("cloudemo_typetable_textcolor") as! String
            NSLog("[Skin]cloudemo_typetable_textcolor_S=%@",cloudemo_typetable_textcolor_S)
            if (cloudemo_typetable_textcolor_S != "null") {
                let cloudemo_typetable_textcolor:UIColor? = 主题参数转对象.color(cloudemo_typetable_textcolor_S) //cloudemo_typetable_textcolor_S
                if (cloudemo_typetable_textcolor != nil) {
                    云颜文字左侧分类列表文字颜色 = cloudemo_typetable_textcolor!
                }
            }
            //RGBA色值：云颜文字左侧分类列表选中行背景色
            let cloudemo_typetable_selectcolor_S:String = 全局_皮肤设置.objectForKey("cloudemo_typetable_selectcolor") as! String
            NSLog("[Skin]cloudemo_typetable_selectcolor_S=%@",cloudemo_typetable_selectcolor_S)
            if (cloudemo_typetable_selectcolor_S != "null") {
                let cloudemo_typetable_selectcolor:UIColor? = 主题参数转对象.color(cloudemo_typetable_selectcolor_S) //cloudemo_typetable_selectcolor_S
                if (cloudemo_typetable_selectcolor != nil) {
                    云颜文字左侧分类列表选中行背景色 = cloudemo_typetable_selectcolor!
                }
            }
            //图片文件名：云颜文字左侧分类列表选中行背景图片
            let cloudemo_typetable_selectimage_S:String = 全局_皮肤设置.objectForKey("cloudemo_typetable_selectimage") as! String
            NSLog("[Skin]cloudemo_typetable_selectimage_S=%@",cloudemo_typetable_selectimage_S)
            if (cloudemo_typetable_selectimage_S != "null") {
                let cloudemo_typetable_selectimage:UIImage? = 主题参数转对象.image(cloudemo_typetable_selectimage_S) //cloudemo_typetable_selectimage_S
                if (cloudemo_typetable_selectimage != nil) {
                    云颜文字左侧分类列表选中行背景图片 = cloudemo_typetable_selectimage
                }
            }
            
            //RGBA色值：搜索框背景颜色
//            let cloudemo_search_bgcolor_S:String = 全局_皮肤设置.objectForKey("cloudemo_search_bgcolor") as! String
//            NSLog("[Skin]cloudemo_search_bgcolor_S=%@",cloudemo_search_bgcolor_S)
//            if (cloudemo_search_bgcolor_S != "null") {
//                let cloudemo_search_bgcolor:UIColor? = 主题参数转对象.color(cloudemo_search_bgcolor_S) //cloudemo_search_bgcolor_S
//                if (cloudemo_search_bgcolor != nil) {
//                    搜索输入框.backgroundColor = cloudemo_search_bgcolor
//                }
//            }
            //RGBA色值：搜索框文字颜色
            let cloudemo_search_tintcolor_S:String = 全局_皮肤设置.objectForKey("cloudemo_search_tintcolor") as! String
            NSLog("[Skin]cloudemo_search_tintcolor_S=%@",cloudemo_search_tintcolor_S)
            
            if (cloudemo_search_tintcolor_S != "null") {
                let cloudemo_search_tintcolor:UIColor? = 主题参数转对象.color(cloudemo_search_tintcolor_S) //cloudemo_search_tintcolor_S
                if (cloudemo_search_tintcolor != nil) {
                    let 搜索输入框:UITextField = 搜索颜文字.valueForKey("searchField") as! UITextField
//                    搜索颜文字.barTintColor = cloudemo_search_tintcolor
                    搜索颜文字.tintColor = cloudemo_search_tintcolor
                    搜索输入框.textColor = cloudemo_search_tintcolor
                }
            }
            //RGBA色值：下拉刷新文字颜色
            let cloudemo_downrefresh_textcolor_S:String = 全局_皮肤设置.objectForKey("cloudemo_downrefresh_textcolor") as! String
            NSLog("[Skin]cloudemo_downrefresh_textcolor_S=%@",cloudemo_downrefresh_textcolor_S)
            if (cloudemo_downrefresh_textcolor_S != "null") {
                let cloudemo_downrefresh_textcolor:UIColor? = 主题参数转对象.color(cloudemo_downrefresh_textcolor_S) //cloudemo_downrefresh_textcolor_S
                if (cloudemo_downrefresh_textcolor != nil) {
                    下拉刷新提示文本颜色 = cloudemo_downrefresh_textcolor!
                    if (下拉刷新提示 != nil) {
                        下拉刷新提示?.textColor = 下拉刷新提示文本颜色
                    }
                }
            }
            //背景图
            刷新背景图()
            分类表格.reloadData()
            颜文字表格.reloadData()
        }
    }
    
    func 刷新背景图() {
        let 启用修改背景:Bool = NSUserDefaults.standardUserDefaults().boolForKey("diybg")
        if (启用修改背景) {
            NSLog("[Skin]背景图被用户替换")
            let bg:UIImage? = loadbg()
            bgpview.image = bgimage
            颜文字表格背景.image = bgimage
            if(bg != defaultimage){
                bgpview.contentMode = UIViewContentMode.ScaleAspectFill
                颜文字表格背景.contentMode = UIViewContentMode.ScaleAspectFill
            } else {
                bgpview.contentMode = UIViewContentMode.ScaleAspectFit
                颜文字表格背景.contentMode = UIViewContentMode.ScaleAspectFit
            }
            bgpview.alpha = loadopc()
            颜文字表格背景.alpha = loadopc()
        } else {
            let 主题参数转对象:Skin2Object = Skin2Object()
            let 取背景图:String = 主题参数转对象.判断应该显示的背景图()
            let background_image_S:String? = 全局_皮肤设置.objectForKey(取背景图) as? String
            if (background_image_S != nil && background_image_S != "null") {
                NSLog("[Skin]%@_S=%@",取背景图,background_image_S!)
                let background_image:UIImage? = 主题参数转对象.image(background_image_S) //background_image_S
                if (background_image != nil) {
                    颜文字表格背景.image = background_image!
                }
            }

            //图片文件名：云颜文字左侧分类列表背景图片
            let cloudemo_typetable_bgimage_S:String? = 全局_皮肤设置.objectForKey("cloudemo_typetable_bgimage") as? String
            if (cloudemo_typetable_bgimage_S != nil && cloudemo_typetable_bgimage_S != "null") {
                NSLog("[Skin]cloudemo_typetable_bgimage_S=%@",cloudemo_typetable_bgimage_S!)
                let cloudemo_typetable_bgimage:UIImage? = 主题参数转对象.image(cloudemo_typetable_bgimage_S) //cloudemo_typetable_bgimage_S
                if (cloudemo_typetable_bgimage != nil) {
                    bgpview.image = cloudemo_typetable_bgimage
                }
            }
        }
    }
    
    func 载入视图() {
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "widget2.png"), forBarMetrics: UIBarMetrics.Default)
        sortBtn.title = lang.uage("分类")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "屏幕旋转:", name: "屏幕旋转通知", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadwebdataoks:", name: "loaddataoks", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "load:", name: "loaddataok", object: nil)
        
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
        
        颜文字表格背景.frame = CGRectMake(颜文字表格.frame.origin.x, 颜文字表格.frame.origin.y + 64, 颜文字表格.frame.width, 颜文字表格.frame.height - 113)
        颜文字表格背景.backgroundColor = UIColor.whiteColor()
        颜文字表格背景.contentMode = UIViewContentMode.ScaleAspectFill
        颜文字表格背景.layer.masksToBounds = true
        
        用户登录视图.frame = CGRectMake(0, 0, 分类表格.frame.size.width, 80)
//        userimg.frame = CGRectMake(10, 20, 80, 80)
        当前源文字框.frame = CGRectMake(10, 100, 分类表格.frame.size.width - 10, 20)
        
//        用户登录视图.addSubview(userimg)
//        username.frame = CGRectMake(userimg.frame.origin.x + userimg.frame.size.width + 5, userimg.frame.origin.y, 用户登录视图.frame.size.width - userimg.frame.origin.x - userimg.frame.size.width - 5, userimg.frame.size.height)
//        username.text = lang.uage("未登录")
//        username.font = UIFont.systemFontOfSize(13)
        当前源文字框.text = 当前源 as String
        当前源文字框.font = UIFont.systemFontOfSize(13)
        当前源文字框.textColor = UIColor.grayColor()
//        NSLog("当前文字框内容为[%@]", 当前源文字框.text!)
        
//        用户登录视图.addSubview(username)
//        用户登录视图.addSubview(当前源文字框)
        
        分类表格.tableHeaderView = 用户登录视图
        用户登录视图.代理 = self
        //        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.automaticallyAdjustsScrollViewInsets = false
        if (self.view.frame.height > self.view.frame.width || UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
            分类表格.contentInset = UIEdgeInsetsMake(64, 0, 48, 0)
        } else {
            分类表格.contentInset = UIEdgeInsetsMake(32, 0, 48, 0)
        }
        
        颜文字表格.contentInset = 分类表格.contentInset
        
        //在真机中似乎影响性能，暂时关闭阴影功能。
//        颜文字表格.layer.shadowColor = UIColor.grayColor().CGColor
//        颜文字表格.layer.shadowOffset = CGSizeMake(-5, 0)
//        颜文字表格.layer.shadowOpacity = 0.9
//        颜文字表格.layer.masksToBounds = false
        
        搜索颜文字.delegate = self
        搜索颜文字.autocapitalizationType = UITextAutocapitalizationType.None
        搜索颜文字.sizeToFit()
        颜文字表格.tableHeaderView = 搜索颜文字
        颜文字表格.setContentOffset(CGPointMake(0, -20), animated: true)
        
        self.view.addSubview(分类表格)
        self.view.addSubview(颜文字表格背景)
        self.view.addSubview(颜文字表格)
    }

    func loaddata()
    {
        var y_emoarr:NSArray = NSArray()
        var p_emoweb:NSArray? = p_emodata
        if(p_emoweb != nil && p_emodata.count >= 3)
        {
            let p_emoary:NSArray = p_emoweb!
            y_emoarr = p_emoary.objectAtIndex(3) as! NSArray
        } else {
            let 内置源路径:NSString = NSBundle.mainBundle().pathForResource("default", ofType: "plist")!
            var p_emo:NSArray! = NSArray(contentsOfFile: 内置源路径 as String)
            y_emoarr = p_emo.objectAtIndex(3) as! NSArray
        }
        
        搜索结果.removeAllObjects()
        搜索结果的名称.removeAllObjects()
        for g_emoobj in y_emoarr
        {
            var g_emoarr:NSArray = g_emoobj as! NSArray
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
        搜索颜文字.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        搜索颜文字.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        loaddata()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let str:NSString = searchText
        if (str.isEqualToString("")) {
            openSortData(当前分类)
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
                i++
            }
            颜文字表格.reloadData()
        }
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
            loaddata()
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
    
    func load(notification:NSNotification)
    {
        载入本地数据()
    }
    
    func loadwebdataoks(notification:NSNotification)
    {
        let urlArr:NSArray = notification.object as! NSArray
        let urlStr:NSString = urlArr.objectAtIndex(0) as! NSString
        let downloadModeIntNB:NSNumber = urlArr.objectAtIndex(1) as! NSNumber
        let downloadModeInt:Int = downloadModeIntNB.integerValue
        let nowDownloadMode:NetDownloadTo = NetDownloadTo(rawValue: downloadModeInt)!
        if (nowDownloadMode == NetDownloadTo.CLOUDEMOTICON || nowDownloadMode == NetDownloadTo.CLOUDEMOTICONREFRESH) {
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
                self.颜文字表格背景.frame = CGRectMake(self.颜文字表格.frame.origin.x, self.颜文字表格.frame.origin.y + 64, self.颜文字表格.frame.width, self.颜文字表格.frame.height - 113)
            })
        }
    }
    
    func openSortData(row:Int)
    {
        ceData.removeAllObjects()
        let y_emoarr:NSArray = p_emodata.objectAtIndex(3) as! NSArray
        let emogroup_o:NSArray = y_emoarr.objectAtIndex(row) as! NSArray
        ceData.addObjectsFromArray(emogroup_o  as [AnyObject])
        ceData.removeObjectAtIndex(0)
        颜文字表格.reloadData()
    }
    
    func 手势执行(recognizer:UITapGestureRecognizer)
    {
        let 手指当前坐标:CGPoint = recognizer.locationInView(self.view)
        if (recognizer.state == UIGestureRecognizerState.Ended || recognizer.state == UIGestureRecognizerState.Cancelled || recognizer.state == UIGestureRecognizerState.Failed) {
            NSNotificationCenter.defaultCenter().postNotificationName("允许单元格接收手势通知", object: nil)
            手势起始位置X坐标 = 0
            var x:CGFloat = 0
            if (颜文字表格.frame.origin.x > 滑动最大X坐标 * 0.5) {
                x = 滑动最大X坐标
                if (isCanAutoHideSortView()) {
                    NSNotificationCenter.defaultCenter().postNotificationName("取消单元格左滑通知", object: nil)
                    搜索颜文字.resignFirstResponder()
                }
            }
            手势中 = false
            self.view.layer.removeAllAnimations()
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
            UIView.animateWithDuration(0.15, animations: {
                self.颜文字表格.frame = CGRectMake(x, self.颜文字表格.frame.origin.y, self.颜文字表格.frame.size.width, self.颜文字表格.frame.size.height)
                self.颜文字表格背景.frame = CGRectMake(self.颜文字表格.frame.origin.x, self.颜文字表格.frame.origin.y + 64, self.颜文字表格.frame.width, self.颜文字表格.frame.height - 113)
                }, completion: {
                    (completion) in
                    if completion {
                        self.菜单滑动中 = false
                    }
            })
        } else {
            let 手指当前X坐标:CGFloat = 手指当前坐标.x
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
                    self.颜文字表格背景.frame = CGRectMake(self.颜文字表格.frame.origin.x, self.颜文字表格.frame.origin.y + 64, self.颜文字表格.frame.width, self.颜文字表格.frame.height - 113)
                }
            }
        }
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if (isCanAutoHideSortView()) {
            if (颜文字表格.frame.origin.x != 0) {
                菜单滑动中 = true
            }
        }
        手势中 = true
        let 手指当前坐标:CGPoint = gestureRecognizer.locationInView(self.view)
        手势起始位置X坐标 = 手指当前坐标.x
        return true
    }
    
    func isCanAutoHideSortView() -> Bool
    {
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone && self.view.frame.width < self.view.frame.height ) {
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
        
        if (tableView.tag == 100) { //左表
            var cell:UITableViewCell? = 分类表格.dequeueReusableCellWithIdentifier(CellIdentifier as String)
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier as String)
                cell?.backgroundColor = UIColor.clearColor()
                let 选中行背景视图:UIImageView = UIImageView(frame: cell!.frame)
//                选中行背景视图.backgroundColor = UIColor.redColor()
                cell?.selectedBackgroundView = 选中行背景视图
            }
            let 选中行背景视图:UIImageView = cell?.selectedBackgroundView as! UIImageView
            选中行背景视图.backgroundColor = 云颜文字左侧分类列表选中行背景色
            选中行背景视图.image = 云颜文字左侧分类列表选中行背景图片
            cell?.textLabel?.textColor = 云颜文字左侧分类列表文字颜色
            let groupname:NSString = sortData.objectAtIndex(indexPath.row) as! NSString
            cell!.textLabel?.text  = groupname as String
            return cell!
        } else {
            
            var cell:CETableViewCell? = 分类表格.dequeueReusableCellWithIdentifier(CellIdentifier as String) as? CETableViewCell
            if (cell == nil) {
                cell = CETableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier as String)
                cell?.backgroundColor = UIColor.clearColor()
                cell!.selectionStyle = UITableViewCellSelectionStyle.Blue
                cell!.初始化单元格样式(CETableViewCell.cellMode.CEVIEWCONTROLLER)
                cell!.代理 = self
                let 选中行背景视图:UIImageView = UIImageView(frame: cell!.frame)
//                选中行背景视图.backgroundColor = UIColor.orangeColor()
                cell?.selectedBackgroundView = 选中行背景视图
            }
            let 选中行背景视图:UIImageView = cell?.selectedBackgroundView as! UIImageView
            选中行背景视图.backgroundColor = 列表当前选中的行背景色
            选中行背景视图.image = 列表当前选中的行背景图片
            cell?.主文字.textColor = 列表文字颜色
            cell?.副文字.textColor = 副标题列表文字颜色
            cell!.单元格在表格中的位置 = indexPath
            let emoobj:NSArray = ceData.objectAtIndex(indexPath.row) as! NSArray
            let emo:NSString = emoobj.objectAtIndex(0) as! NSString
            cell!.主文字.text = emo as String
//            cell!.textLabel.text = emo
            if (emoobj.count > 1) {
                let name:NSString = emoobj.objectAtIndex(1) as! NSString
                cell!.副文字.text = name as String
            } else {
                cell!.副文字.text = ""
            }
            
//            cell?.textLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
//            cell?.textLabel.numberOfLines = 0
            cell?.主文字.lineBreakMode = NSLineBreakMode.ByCharWrapping
            cell?.主文字.numberOfLines = 0
            
//            let 主文字框高度:CGFloat = heightForString(cell!.主文字.text!, FontSize: 17, andWidth: cell!.frame.size.width) + 8
//            cell!.主文字.frame = CGRectMake(20, 0, cell!.frame.size.width - 20, 主文字框高度)
//            if (emoobj.count > 1) {
//                let 副文字框高度:CGFloat = heightForString(cell!.副文字.text!, FontSize: 12, andWidth: cell!.frame.size.width) - 13
//                cell!.副文字.frame = CGRectMake(20, cell!.主文字.frame.size.height - 7, cell!.frame.size.width - 20, 副文字框高度)
//                当前单元格高度 = 主文字框高度 + 副文字框高度
//            } else {
//                当前单元格高度 = 主文字框高度
//            }
            
            cell!.修正元素位置(self.颜文字表格.frame.size.width)
            return cell!
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        搜索颜文字.resignFirstResponder()
        NSNotificationCenter.defaultCenter().postNotificationName("取消单元格左滑通知", object: nil)
        if (tableView.tag == 100) {
            搜索颜文字.text = ""
            openSortData(indexPath.row)
            当前分类 = indexPath.row
            sortBtn(sortBtn)
        } else {
            let 颜文字数组:NSArray = ceData.objectAtIndex(indexPath.row) as! NSArray
//            let 颜文字:NSString = emoobj.objectAtIndex(0) as NSString
//            let 颜文字名称:NSString = emoobj.objectAtIndex(1) as NSString
            NSNotificationCenter.defaultCenter().postNotificationName("复制到剪贴板通知", object: 颜文字数组, userInfo: nil)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String?
    {
        return lang.uage("删掉喵")
    }
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
                var 文字高度:CGFloat = 44
                let emoobj:NSArray = ceData.objectAtIndex(indexPath.row) as! NSArray
                let 主文字内容:NSString = emoobj.objectAtIndex(0) as! NSString
                var 副文字内容:NSString = ""
                let 主文字框高度:CGFloat = 计算单元格高度(主文字内容, 字体大小: 17, 单元格宽度: tableView.frame.width - 20) + 8
                if (emoobj.count > 1) {
                    副文字内容 = emoobj.objectAtIndex(1) as! NSString
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
        return 44
    }

    func 屏幕旋转(notification:NSNotification)
    {
//        println("收到屏幕旋转")
        let newScreenSizeArr:NSArray = notification.object as! NSArray
        let newScreenSize:CGSize = CGSizeMake(newScreenSizeArr.objectAtIndex(0) as! CGFloat, newScreenSizeArr.objectAtIndex(1) as! CGFloat)
    
        分类表格.frame = CGRectMake(0, 0, 滑动最大X坐标, newScreenSize.height)
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone && newScreenSize.width < newScreenSize.height) {
            sortBtn.title = lang.uage("分类")
            颜文字表格.frame = CGRectMake(分类表格.frame.size.width, 0, newScreenSize.width, newScreenSize.height)
            self.颜文字表格背景.frame = CGRectMake(self.颜文字表格.frame.origin.x, self.颜文字表格.frame.origin.y + 64, self.颜文字表格.frame.width, self.颜文字表格.frame.height - 113)
        } else {
            sortBtn.title = ""
            颜文字表格.frame = CGRectMake(分类表格.frame.size.width, 0, newScreenSize.width - 分类表格.frame.size.width, newScreenSize.height)
            self.颜文字表格背景.frame = CGRectMake(self.颜文字表格.frame.origin.x, self.颜文字表格.frame.origin.y + 32, self.颜文字表格.frame.width, self.颜文字表格.frame.height - 81)
        }
        
        if (newScreenSize.width < newScreenSize.height || UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
            分类表格.contentInset = UIEdgeInsetsMake(64, 0, 48, 0)
            if(调整搜索栏位置){
            颜文字表格.setContentOffset(CGPointMake(0, -20), animated: false)
            }
        } else {
            分类表格.contentInset = UIEdgeInsetsMake(32, 0, 48, 0)
            if(调整搜索栏位置){
            颜文字表格.setContentOffset(CGPointMake(0, 12), animated: false)
            }
        }
        颜文字表格.contentInset = 分类表格.contentInset
        let 新的宽度:CGFloat = 颜文字表格.frame.size.width
        NSNotificationCenter.defaultCenter().postNotificationName("修正单元格尺寸通知", object: 新的宽度)
        颜文字表格.reloadData()
    }
    
    func 源管理页面代理：退出源管理页面时()
    {
        载入数据(NetDownloadTo.CLOUDEMOTICON)
        loaddata()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        搜索颜文字.resignFirstResponder()
        let 表格滚动位置:CGPoint = scrollView.contentOffset
        let 表格竖向滚动:CGFloat = 表格滚动位置.y
        let 表格滚动距离:CGFloat = 0 - 表格滚动位置.y - 表格初始滚动位置
        if (下拉刷新提示 != nil) {
            let 当前表格:UITableView = scrollView as! UITableView
            下拉刷新提示!.frame = CGRectMake(当前表格.frame.origin.x, 表格初始滚动位置, 当前表格.frame.size.width, 表格滚动距离)
            下拉刷新提示?.textColor = 下拉刷新提示文本颜色
            if (下拉刷新动作中) {
                if (表格竖向滚动 < -100.0) {
                    下拉刷新提示!.text = lang.uage("松开手指刷新")
                } else {
                    下拉刷新提示!.text = lang.uage("下拉刷新")
                }
            }
        }
//        if((表格竖向滚动 > -20 && self.view.frame.size.width < self.view.frame.size.height) || (self.view.frame.size.width > self.view.frame.size.height && 表格竖向滚动 > 12 )){
//            调整搜索栏位置 = false
//        } else {
//            调整搜索栏位置 = true
//        }
        if(表格竖向滚动 > -20 && self.view.frame.width < self.view.frame.height){
            调整搜索栏位置 = false
        } else if(表格竖向滚动 > 12 && self.view.frame.width > self.view.frame.height && UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
            调整搜索栏位置 = false
        } else {
            调整搜索栏位置 = true
        }
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
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
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        下拉刷新动作中 = false
        let 表格滚动位置:CGPoint = scrollView.contentOffset
        let 表格竖向滚动:CGFloat = 表格滚动位置.y
        if (表格竖向滚动 < -100.0) {
            下拉刷新提示?.text = lang.uage("正在刷新")
            if (全局_网络繁忙 == false) {
                载入数据(NetDownloadTo.CLOUDEMOTICONREFRESH)
                loaddata()
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName("允许单元格接收手势通知", object: nil)
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        下拉刷新提示?.removeFromSuperview()
        下拉刷新提示 = nil
    }
    
    func 单元格代理：点击滑出的按钮时(点击按钮的ID:Int, 单元格在表格中的位置:NSIndexPath)
    {
        NSNotificationCenter.defaultCenter().postNotificationName("取消单元格左滑通知", object: nil)
        let 当前单元格:CETableViewCell = 颜文字表格.cellForRowAtIndexPath(单元格在表格中的位置) as! CETableViewCell
        let 颜文字:NSString = 当前单元格.主文字.text!
        let 颜文字名称:NSString? = 当前单元格.副文字.text
        if (点击按钮的ID == 1) { //收藏
            let 文件管理器:FileManager = FileManager()
            var 文件中的数据:NSArray? = 文件管理器.LoadArrayFromFile(FileManager.saveMode.FAVORITE)
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
                var 颜文字数组:NSMutableArray = [颜文字]
                if (颜文字名称 != nil) {
                    颜文字数组.addObject(颜文字名称!)
                }
                var 收藏:NSMutableArray = NSMutableArray()
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
            NSNotificationCenter.defaultCenter().postNotificationName("显示自动关闭的提示框通知", object: 提示文字!)
        } else { //分享 颜文字
            var 二维码分享按钮入:[QRActivity]? = nil
            if (颜文字.length <= 64) {
                let 二维码分享按钮:QRActivity = QRActivity()
                二维码分享按钮.代理 = self
                二维码缓存 = QRCodeGenerator.qrImageForString(颜文字 as String, imageSize: 200.0)
                二维码分享按钮.设置二维码图片(二维码缓存)
                二维码分享按钮入 = [二维码分享按钮]
            }
            let 分享视图:UIActivityViewController = UIActivityViewController(activityItems: [颜文字], applicationActivities: 二维码分享按钮入)
            分享视图.modalTransitionStyle = UIModalTransitionStyle.CoverVertical;
            分享视图.excludedActivityTypes = [UIActivityTypeCopyToPasteboard];
            self.presentViewController(分享视图, animated: true, completion: nil)
        }
    }
    
    func 显示二维码() {
        //QRViewDelegate
        let 二维码视图:QRView = QRView()
        二维码视图.显示二维码(二维码缓存)
        self.view.addSubview(二维码视图)
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
    
    func 显示用户登录框() {
        let 登录画面:LoginViewController = storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        登录画面.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(登录画面, animated: true)
    }

}
