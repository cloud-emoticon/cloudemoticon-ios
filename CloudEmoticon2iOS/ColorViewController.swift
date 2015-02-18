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
    
    var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var bgopacity:Float? = NSUserDefaults.standardUserDefaults().valueForKey("bgopacity") as Float?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "transition:", name: "transition", object: nil)
        
        list.addObject(lang.uage("修改背景图片"))
        list.addObject(lang.uage("还原背景"))
        list.addObject(lang.uage("背景不透明度"))

        背景管理.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        背景管理.delegate = self
        背景管理.dataSource = self
        
        self.title = lang.uage("背景")
        
        let bg:UIImage? = UIImage(contentsOfFile: userbgimgfullpath)
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

    func transition(notification:NSNotification)
    {
        let newScreenSizeArr:NSArray = notification.object as NSArray
        let newScreenSize:CGSize = CGSizeMake(newScreenSizeArr.objectAtIndex(0) as CGFloat, newScreenSizeArr.objectAtIndex(1) as CGFloat)
        
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
        return 4
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
        return lang.uage("背景")
        }
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CellIdentifier:NSString = "Cell"
        var cell:UITableViewCell? = 背景管理.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        }
        if(indexPath.row <= 1) {
        cell?.textLabel?.text = list.objectAtIndex(indexPath.row) as NSString
        }
        if(indexPath.row == 2){
            cell?.textLabel?.text = list.objectAtIndex(indexPath.row) as NSString
            cell?.selectionStyle = .None
            设置背景不透明度.frame = CGRectMake(90, 13, self.view.frame.size.width - 100, 20)
            设置背景不透明度.minimumValue = 0
            设置背景不透明度.maximumValue = 100
            设置背景不透明度.value = bgopacity!

            cell?.addSubview(设置背景不透明度)
        }
        if(indexPath.row == 3){
            cell?.addSubview(bgimageviewer)
            cell?.selectionStyle = .None
        }
        return cell!
    }
    
    func loadSetting()
    {
        设置背景不透明度.value = defaults.floatForKey("bgopacity")
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
           selectimage()
            break
        case 1:
           deletebgimage()
            break
        default:
            break
        }
    }
    
    func selectimage() {
        var actionsheet:UIActionSheet = UIActionSheet(title: lang.uage("选择背景图片加载位置"), delegate: self, cancelButtonTitle: lang.uage("取消"), destructiveButtonTitle: nil, otherButtonTitles:lang.uage("拍照"),lang.uage("相册"),lang.uage("图片库"))
        actionsheet.actionSheetStyle = UIActionSheetStyle.Default
        actionsheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        var picker:UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
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
    
    func imagePickerController(picker: UIImagePickerController!,
    didFinishPickingMediaWithInfo info: NSDictionary!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image:UIImage = info.objectForKey(UIImagePickerControllerEditedImage) as UIImage
        if(picker.sourceType == UIImagePickerControllerSourceType.Camera){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        saveImage(image, WithName: userbgimgname)
    }
    
    func saveImage(tempImage:UIImage, WithName imageName:NSString){
        let imageData:NSData = UIImagePNGRepresentation(tempImage)
        let fullpathttofile:NSString = documentDirectoryAddress.stringByAppendingPathComponent(imageName)
        imageData.writeToFile(fullpathttofile, atomically: false)
        bgimageviewer.image = tempImage
        bgimageviewer.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    func deletebgimage(){
        let fullpathtofile:NSString = documentDirectoryAddress.stringByAppendingPathComponent(userbgimgname)
        let isDup:Bool = FileManager().ChkDupFile(fullpathtofile)
        NSFileManager.defaultManager().removeItemAtPath(fullpathtofile, error: nil)
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
