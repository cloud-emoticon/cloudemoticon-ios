//
//  ColorViewController.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂紫喵 on 14/8/26.
//  Copyright (c) 2014年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var selectbutton: UIButton!
    @IBOutlet weak var restorebutton: UIButton!
    @IBOutlet weak var nowbgtext: UITextView!

    @IBAction func restorebutton(sender: AnyObject) {
        deletebgimage()
    }
    @IBAction func selectbutton(sender: AnyObject) {
        selectimage()
    }
    @IBOutlet weak var bgimageviewer: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectbutton.setTitle(lang.uage("修改背景图片"), forState: UIControlState.Normal)
        restorebutton.setTitle(lang.uage("还原背景"), forState: UIControlState.Normal)

        nowbgtext.text = lang.uage("当前背景")
        self.title = lang.uage("个性化")
        let bg:UIImage? = UIImage(contentsOfFile: userbgimgfullpath)
        
        if(bg != nil) {
            bgimageviewer.image = bg
            bgimageviewer.contentMode = UIViewContentMode.ScaleAspectFill
            bgimageviewer.layer.masksToBounds = true
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if (isDup){
            NSFileManager.defaultManager().removeItemAtPath(fullpathtofile, error: nil)
        }
        
        
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
