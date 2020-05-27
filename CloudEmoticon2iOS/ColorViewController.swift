//
//  ColorViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫喵 on 14/8/26.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    var 背景管理: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    var list:NSMutableArray = NSMutableArray()
    var bgimageviewer: UIImageView = UIImageView()
    var 设置背景不透明度:UISlider = UISlider()
    var 启用修改背景:Bool = false
    
    var defaults:UserDefaults = UserDefaults.standard
    var bgopacity:Float? = UserDefaults.standard.value(forKey: "bgopacity") as! Float?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ColorViewController.transition(_:)), name: NSNotification.Name(rawValue: "屏幕旋转通知"), object: nil)
        list.add(lang.uage("替换主题中的背景图片"))
//        list.addObject(lang.uage("修改背景图片"))
//        list.addObject(lang.uage("背景不透明度"))

        背景管理.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        背景管理.delegate = self
        背景管理.dataSource = self
        
        self.title = lang.uage("背景")
        
        let bg:UIImage? = UIImage(contentsOfFile: userbgimgfullpath as String)
        if(bg != nil) {
            bgimageviewer.image = bg
            bgimageviewer.contentMode = UIView.ContentMode.scaleAspectFill
        } else {
            bgimage = UIImage(contentsOfFile:Bundle.main.path(forResource: "basicbg", ofType: "png")!)!
            bgimageviewer.image = bgimage
            bgimageviewer.contentMode = UIView.ContentMode.scaleAspectFit
        }
        
        bgimageviewer.layer.masksToBounds = true
        bgimageviewer.frame = CGRect(x: self.view.frame.width / 4, y: 10, width: self.view.frame.width / 2, height: self.view.frame.height / 2)

        self.view.addSubview(背景管理)
        loadSetting()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveSetting()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "切换主题通知"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "显示自动关闭的提示框通知"), object: lang.uage("正在切换主题..."))
    }

    @objc func transition(_ notification:Notification)
    {
        let newScreenSizeArr:NSArray = notification.object as! NSArray
        let newScreenSize:CGSize = CGSize(width: newScreenSizeArr.object(at: 0) as! CGFloat, height: newScreenSizeArr.object(at: 1) as! CGFloat)
        
        背景管理.frame = CGRect(x: 0, y: 0, width: newScreenSize.width, height: newScreenSize.height)
        
        bgimageviewer.frame = CGRect(x: newScreenSize.width / 4, y: 10, width: newScreenSize.width / 2, height: newScreenSize.height / 2)
        背景管理.reloadData()
        bgimageviewer.reloadInputViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return list.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
        return lang.uage("背景")
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier:NSString = "Cell"
        var cell:UITableViewCell? = 背景管理.dequeueReusableCell(withIdentifier: CellIdentifier as String)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: CellIdentifier as String)
        }
        if ((indexPath as NSIndexPath).row == 0) {
            if (启用修改背景) {
                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            } else {
                cell?.accessoryType = UITableViewCell.AccessoryType.none
            }
        } else {
            cell?.accessoryType = UITableViewCell.AccessoryType.none
        }
        if((indexPath as NSIndexPath).row <= 1) {
        cell?.textLabel?.text = list.object(at: (indexPath as NSIndexPath).row) as? String
        }
        if((indexPath as NSIndexPath).row == 2){
            cell?.textLabel?.text = list.object(at: (indexPath as NSIndexPath).row) as? String
            cell?.selectionStyle = .none
            设置背景不透明度.frame = CGRect(x: 90, y: 13, width: self.view.frame.size.width - 100, height: 20)
            设置背景不透明度.minimumValue = 0
            设置背景不透明度.maximumValue = 100
            设置背景不透明度.value = bgopacity!
            bgimageviewer.alpha = CGFloat(设置背景不透明度.value / 200)
            设置背景不透明度.addTarget(self, action: #selector(ColorViewController.即时预览透明度(_:)), for: UIControl.Event.valueChanged)
            cell?.addSubview(设置背景不透明度)
        }
        if((indexPath as NSIndexPath).row == 3){
            cell?.addSubview(bgimageviewer)
            cell?.selectionStyle = .none
        }
        return cell!
    }
    
    @objc func 即时预览透明度(_ sender:UISlider) {
        bgimageviewer.alpha = CGFloat(设置背景不透明度.value / 200)
    }
    
    func loadSetting()
    {
        设置背景不透明度.value = defaults.float(forKey: "bgopacity")
        启用修改背景 = defaults.bool(forKey: "diybg")
        if (启用修改背景 == true && list.count == 1) {
            list.add(lang.uage("修改背景图片"))
            list.add(lang.uage("背景不透明度"))
            list.add("")
            list.add("")
        }
    }
    func saveSetting()
    {
        defaults.set(设置背景不透明度.value, forKey: "bgopacity")
        defaults.synchronize()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if((indexPath as NSIndexPath).row == 3){
            return (bgimageviewer.frame.height + 20)
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = self.storyboard
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath as NSIndexPath).row {
        case 0:
           启用修改背景 = !启用修改背景
           if (启用修改背景 == true && list.count == 1) {
            list.add(lang.uage("修改背景图片"))
            list.add(lang.uage("背景不透明度"))
            list.add("")
            list.add("")
           } else if (启用修改背景 == false && list.count > 1) {
            list.removeLastObject()
            list.removeLastObject()
            list.removeLastObject()
            list.removeLastObject()
           }
           defaults.set(启用修改背景, forKey: "diybg")
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
        actionsheet.actionSheetStyle = UIActionSheetStyle.default
        actionsheet.show(in: self.view)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        let picker:UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        
        switch(buttonIndex)
        {
        case 0:
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
            {
                picker.sourceType = UIImagePickerController.SourceType.camera
            } else {
                return
            }
            break
        case 1:
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary))
            {
                picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            }
            break
        case 2:
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum))
            {
                picker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            }
            break
        default:
            break
        }
        
        picker.modalPresentationStyle = .popover
        let popover = picker.popoverPresentationController
        popover?.sourceRect = CGRect(x: 0, y: 100, width: 0, height: 0)
        popover?.permittedArrowDirections = .any
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
//        let image:UIImage = (editingInfo.indexForKey(UIImagePickerControllerEditedImage) as? UIImage)!
        if(picker.sourceType == UIImagePickerController.SourceType.camera){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        }
        saveImage(image, WithName: userbgimgname)
        picker.dismiss(animated: true, completion: nil)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    func saveImage(_ tempImage:UIImage, WithName imageName:NSString){
        let imageData:Data = tempImage.pngData()!
        let fullpathttofile = 全局_文档文件夹 + (imageName as String) //stringByAppendingPathComponent(imageName as String)
        try? imageData.write(to: URL(fileURLWithPath: fullpathttofile as String), options: [])
        bgimageviewer.image = tempImage
        bgimageviewer.contentMode = UIView.ContentMode.scaleAspectFill
    }
    
    func deletebgimage(){
        //于是暂时注释掉了
//        let fullpathtofile:String = 全局_文档文件夹.stringByAppendingString(imageName as String) //噗，这啥？这个错误未修   这个是删除背景图的喵…… 感觉上应该改成开关……
//        let isDup:Bool = FileManager().ChkDupFile(fullpathtofile)
//        do {
//            try NSFileManager.defaultManager().removeItemAtPath(fullpathtofile)
//        } catch _ {
//        }
        bgimageviewer.image = UIImage(contentsOfFile:Bundle.main.path(forResource: "basicbg", ofType: "png")!)
        bgimageviewer.contentMode = UIView.ContentMode.scaleAspectFit
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
