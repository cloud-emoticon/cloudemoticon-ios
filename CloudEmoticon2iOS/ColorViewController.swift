//
//  ColorViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫喵 on 14/8/26.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    var 背景管理: UITableView = UITableView(frame: CGRectZero, style: .Grouped)
    var list:NSMutableArray = NSMutableArray()
    var bgimageviewer: UIImageView = UIImageView()
    var 设置背景不透明度:UISlider = UISlider()
    var 启用修改背景:Bool = false
    
    var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var bgopacity:Float? = NSUserDefaults.standardUserDefaults().valueForKey("bgopacity") as! Float?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ColorViewController.transition(_:)), name: "屏幕旋转通知", object: nil)
        list.addObject(lang.uage("替换主题中的背景图片"))
//        list.addObject(lang.uage("修改背景图片"))
//        list.addObject(lang.uage("背景不透明度"))

        背景管理.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        背景管理.delegate = self
        背景管理.dataSource = self
        
        self.title = lang.uage("背景")
        
        let bg:UIImage? = UIImage(contentsOfFile: userbgimgfullpath as String)
        if(bg != nil) {
            bgimageviewer.image = bg
            bgimageviewer.contentMode = UIViewContentMode.ScaleAspectFill
        } else {
            bgimage = UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("basicbg", ofType: "png")!)!
            bgimageviewer.image = bgimage
            bgimageviewer.contentMode = UIViewContentMode.ScaleAspectFit
        }
        
        bgimageviewer.layer.masksToBounds = true
        bgimageviewer.frame = CGRectMake(self.view.frame.width / 4, 10, self.view.frame.width / 2, self.view.frame.height / 2)

        self.view.addSubview(背景管理)
        loadSetting()
    }
    
    override func viewDidDisappear(animated: Bool) {
        saveSetting()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName("切换主题通知", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("显示自动关闭的提示框通知", object: lang.uage("正在切换主题..."))
    }

    func transition(notification:NSNotification)
    {
        let newScreenSizeArr:NSArray = notification.object as! NSArray
        let newScreenSize:CGSize = CGSizeMake(newScreenSizeArr.objectAtIndex(0) as! CGFloat, newScreenSizeArr.objectAtIndex(1) as! CGFloat)
        
        背景管理.frame = CGRectMake(0, 0, newScreenSize.width, newScreenSize.height)
        
        bgimageviewer.frame = CGRectMake(newScreenSize.width / 4, 10, newScreenSize.width / 2, newScreenSize.height / 2)
        背景管理.reloadData()
        bgimageviewer.reloadInputViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return list.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
        return lang.uage("背景")
        }
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier:NSString = "Cell"
        var cell:UITableViewCell? = 背景管理.dequeueReusableCellWithIdentifier(CellIdentifier as String)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier as String)
        }
        if (indexPath.row == 0) {
            if (启用修改背景) {
                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell?.accessoryType = UITableViewCellAccessoryType.None
            }
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        if(indexPath.row <= 1) {
        cell?.textLabel?.text = list.objectAtIndex(indexPath.row) as? String
        }
        if(indexPath.row == 2){
            cell?.textLabel?.text = list.objectAtIndex(indexPath.row) as? String
            cell?.selectionStyle = .None
            设置背景不透明度.frame = CGRectMake(90, 13, self.view.frame.size.width - 100, 20)
            设置背景不透明度.minimumValue = 0
            设置背景不透明度.maximumValue = 100
            设置背景不透明度.value = bgopacity!
            bgimageviewer.alpha = CGFloat(设置背景不透明度.value / 200)
            设置背景不透明度.addTarget(self, action: #selector(ColorViewController.即时预览透明度(_:)), forControlEvents: UIControlEvents.ValueChanged)
            cell?.addSubview(设置背景不透明度)
        }
        if(indexPath.row == 3){
            cell?.addSubview(bgimageviewer)
            cell?.selectionStyle = .None
        }
        return cell!
    }
    
    func 即时预览透明度(sender:UISlider) {
        bgimageviewer.alpha = CGFloat(设置背景不透明度.value / 200)
    }
    
    func loadSetting()
    {
        设置背景不透明度.value = defaults.floatForKey("bgopacity")
        启用修改背景 = defaults.boolForKey("diybg")
        if (启用修改背景 == true && list.count == 1) {
            list.addObject(lang.uage("修改背景图片"))
            list.addObject(lang.uage("背景不透明度"))
            list.addObject("")
            list.addObject("")
        }
    }
    func saveSetting()
    {
        defaults.setFloat(设置背景不透明度.value, forKey: "bgopacity")
        defaults.synchronize()
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if(indexPath.row == 3){
            return (bgimageviewer.frame.height + 20)
        }
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = self.storyboard
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
           启用修改背景 = !启用修改背景
           if (启用修改背景 == true && list.count == 1) {
            list.addObject(lang.uage("修改背景图片"))
            list.addObject(lang.uage("背景不透明度"))
            list.addObject("")
            list.addObject("")
           } else if (启用修改背景 == false && list.count > 1) {
            list.removeLastObject()
            list.removeLastObject()
            list.removeLastObject()
            list.removeLastObject()
           }
           defaults.setBool(启用修改背景, forKey: "diybg")
           defaults.synchronize()
           tableView.reloadData()
            break
        case 1:
           selectimage() //deletebgimage()
            break
        default:
            break
        }
    }
    
    func selectimage() {
        let actionsheet:UIActionSheet = UIActionSheet(title: lang.uage("选择背景图片加载位置"), delegate: self, cancelButtonTitle: lang.uage("取消"), destructiveButtonTitle: nil, otherButtonTitles:lang.uage("拍照"),lang.uage("相册"),lang.uage("图片库"))
        actionsheet.actionSheetStyle = UIActionSheetStyle.Default
        actionsheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let picker:UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        
        switch(buttonIndex)
        {
        case 0:
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
            {
                picker.sourceType = UIImagePickerControllerSourceType.Camera
            } else {
                return
            }
            break
        case 1:
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
            {
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            }
            break
        case 2:
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum))
            {
                picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            }
            break
        default:
            break
        }
        
        picker.modalPresentationStyle = .Popover
        let popover = picker.popoverPresentationController
        popover?.sourceRect = CGRectMake(0, 100, 0, 0)
        popover?.permittedArrowDirections = .Any
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        let image:UIImage = (editingInfo.indexForKey(UIImagePickerControllerEditedImage) as? UIImage)!
        if(picker.sourceType == UIImagePickerControllerSourceType.Camera){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        }
        saveImage(image, WithName: userbgimgname)
        picker.dismissViewControllerAnimated(true, completion: nil)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    func saveImage(tempImage:UIImage, WithName imageName:NSString){
        let imageData:NSData = UIImagePNGRepresentation(tempImage)!
        let fullpathttofile:NSString = 全局_文档文件夹.stringByAppendingString(imageName as String) //stringByAppendingPathComponent(imageName as String)
        imageData.writeToFile(fullpathttofile as String, atomically: false)
        bgimageviewer.image = tempImage
        bgimageviewer.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    func deletebgimage(){
        //于是暂时注释掉了
//        let fullpathtofile:String = 全局_文档文件夹.stringByAppendingString(imageName as String) //噗，这啥？这个错误未修   这个是删除背景图的喵…… 感觉上应该改成开关……
//        let isDup:Bool = FileManager().ChkDupFile(fullpathtofile)
//        do {
//            try NSFileManager.defaultManager().removeItemAtPath(fullpathtofile)
//        } catch _ {
//        }
        bgimageviewer.image = UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("basicbg", ofType: "png")!)
        bgimageviewer.contentMode = UIViewContentMode.ScaleAspectFit
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
