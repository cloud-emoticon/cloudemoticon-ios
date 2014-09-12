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
    
    var list:NSMutableArray = NSMutableArray.array()

    var bgimageviewer: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "transition:", name: "transition", object: nil)
        
        list.addObject(lang.uage("修改背景图片"))
        list.addObject(lang.uage("还原背景"))

        背景管理.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        背景管理.delegate = self
        背景管理.dataSource = self
        
        self.title = lang.uage("背景")
        
        let bg:UIImage? = UIImage(contentsOfFile: userbgimgfullpath)
        if(bg != nil) {
            bgimageviewer.image = bg
            bgimageviewer.contentMode = UIViewContentMode.ScaleAspectFill
        } else {
            bgimage = UIImage(contentsOfFile:NSBundle.mainBundle().pathForResource("basicbg", ofType: "png")!)
            bgimageviewer.image = bgimage
            bgimageviewer.contentMode = UIViewContentMode.ScaleAspectFit
        }
        
        bgimageviewer.layer.masksToBounds = true
        bgimageviewer.frame = CGRectMake(self.view.frame.width / 4, 10, self.view.frame.width / 2, self.view.frame.height / 2)

        self.view.addSubview(背景管理)

        // Do any additional setup after loading the view.
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
        return 3
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
            cell?.addSubview(bgimageviewer)
            cell?.selectionStyle = .None
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if(indexPath.row == 2){
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
