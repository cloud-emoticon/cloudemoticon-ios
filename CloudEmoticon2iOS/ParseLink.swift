//
//  ParseLink.swift
//  
//
//  Created by 神楽坂雅詩 on 15/6/27.
//
//

import UIKit
import Parse

class ParseLink: NSObject {
    
    // ※ ※ ※ ※ ※ 绑定操作 ※ ※ ※ ※ ※
    
    //https://www.parse.com/apps/quickstart#parse_data/mobile/ios/swift/new
   
    func 启用本地数据存储() {
        Parse.enableLocalDatastore()
    }
    
    func 设置应用程序编号(应用程序编号:String, 应用程序秘钥:String) {
        Parse.setApplicationId(应用程序编号, clientKey: 应用程序秘钥)
    }
    
    func 跟踪应用程序启动设置(应用程序启动设置:[NSObject : AnyObject]?) {
        PFAnalytics.trackAppOpenedWithLaunchOptions(应用程序启动设置)
    }
    
    func 测试SDK() {
        let 测试对象 = PFObject(className: "TestObject")
        测试对象["foo"] = "bar"
        测试对象.saveInBackgroundWithBlock { (是否成功: Bool, 错误信息: NSError?) -> Void in
            if (错误信息 != nil && 是否成功 == true) {
                NSLog("[ParseLink]未能存储测试数据：%@",错误信息!.localizedDescription)
            } else {
                NSLog("[ParseLink]已存储测试数据。")
            }
        }
    }
    
    // ※ ※ ※ ※ ※ 对象操作 ※ ※ ※ ※ ※
    
    func 保存对象(对象名称:String, 参数字典:NSDictionary) {
        /* PFObject:
        Parse 上的数据储存建立在 PFObject 的基础上。每个 PFObject 包含 JSON 兼容数据的键值对。该数据没有计划性，即您不需要事先指定每个 PFObject 上存在的键。您只需随意设置您需要的键值对，我们的后台会储存它们。
        例如，假设您要跟踪游戏的高分。单个 PFObject 可能包括：
        score: 1337, playerName: "Sean Plott", cheatMode: false
        键值必须是字母数字字符串。键值可以是字符串、数字、布尔值或设置是数组和字典 － 只要是能用 JSON 编码的任何内容。
        每个 PFObject 均有可供您用以区分不同数据种类的类名。例如，您可以把高分对象称为 GameScore。我们建议您这样命名类名（如：NameYourClassesLikeThis）和键值（如：nameYourKeysLikeThis），让您的代码看起来整齐美观。
        保存对象:
        假如您想要将上述 GameScore 保存到 Parse 云中。保存接口与 NSMutableDictionary 类似，多了 saveInBackground 方法：
        */
        let 参数:[NSObject : AnyObject] = 参数字典 as [NSObject : AnyObject]
        var 要上传的对象:PFObject = PFObject(className: 对象名称, dictionary: 参数)
        要上传的对象.saveInBackgroundWithBlock { (是否成功: Bool, 错误信息: NSError?) -> Void in
            if (错误信息 != nil && 是否成功 == true) {
                NSLog("[ParseLink]未能存储数据“%@”，因为：%@。",对象名称,错误信息!.localizedDescription)
                NSNotificationCenter.defaultCenter().postNotificationName("同步:未能存储数据", object: nil)
            } else {
                NSLog("[ParseLink]成功存储数据“%@”。",对象名称)
                NSNotificationCenter.defaultCenter().postNotificationName("同步:成功存储数据", object: nil)
            }
        }
        /*
        该代码运行后，您可能不知道是否执行了相关操作。为确保数据正确保存，您可以在 Parse 上查看应用中的数据浏览器。您应该会看到类似于以下的内容：
        objectId: "xWMyZ4YEGZ", score: 1337, playerName: "Sean Plott", cheatMode: false,
        createdAt:"2011-06-10T18:33:42Z", updatedAt:"2011-06-10T18:33:42Z"
        这里要注意两点。在运行这个代码前，您不需要配置或创建名称为 GameScore 的新类别。您的 Parse 应用在第一次遇到这个类别时会为您创建该类别。
        还有几个字段只是为了方便，您不需要指定内容。objectId 是各已存对象的唯一标识符。createdAt 和 updatedAt 分别是各个对象在 Parse 云中的创建时间和最后修改时间。每个字段都由 Parse 填充，所以完成保存操作后，PFObject 上才会存在这些字段。
        您可以用 saveInBackgroundWithBlock 或 saveInBackgroundWithTarget:selector: 方法指定保存完成后运行的额外任务。
        */
    }
    
    func 对象检索(对象名称:String, 对象ID:String) {
        //将数据保存到云中非常有趣，但是更有趣的是从云中获取这些数据。如果您有 objectId，您可以用 PFQuery 检索整个 PFObject。这是一种异步方法，它还有可以使用代码块或回调方法的变体：
        let 查询:PFQuery = PFQuery(className: 对象名称)
        查询.getObjectInBackgroundWithId(对象ID, block: { (返回字典对象:PFObject?, 错误信息:NSError?) -> Void in
            if (错误信息 != nil && 返回字典对象 != nil) {
                NSLog("[ParseLink]未能查询数据“%@”(ID:%@)，因为：%@。",对象名称,对象ID,错误信息!.localizedDescription)
                NSNotificationCenter.defaultCenter().postNotificationName("同步:查询对象失败", object: nil)
            } else {
                NSLog("[ParseLink]成功查询数据“%@”(ID:%@)。",对象名称,对象ID)
                NSNotificationCenter.defaultCenter().postNotificationName("同步:查询对象完成", object: 返回字典对象!)
            }
        })
    }
    
}
