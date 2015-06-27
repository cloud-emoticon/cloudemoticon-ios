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
    
    let 通知中心:NSNotificationCenter = NSNotificationCenter.defaultCenter()
    
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
                self.通知中心.postNotificationName("同步:未能存储数据", object: nil)
            } else {
                NSLog("[ParseLink]成功存储数据“%@”。",对象名称)
                self.通知中心.postNotificationName("同步:成功存储数据", object: nil)
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
                self.通知中心.postNotificationName("同步:查询对象失败", object: nil)
            } else {
                NSLog("[ParseLink]成功查询数据“%@”(ID:%@)。",对象名称,对象ID)
                self.通知中心.postNotificationName("同步:查询对象完成", object: 返回字典对象!)
            }
        })
    }
    
    func 获取返回对象的值(信息对象:PFObject, 变量名称:String) -> AnyObject? {
        //若要从 PFObject 获取值，您可以使用 objectForKey: 方法或通过 [] 访问下标：
        let 变量内容:AnyObject? = 信息对象.objectForKey(变量名称)
        if (变量内容 == nil) {
            NSLog("[ParseLink]找不到变量名称“%@”。",变量名称)
        }
        return 变量内容
    }
    
    func 获取返回对象的属性(信息对象:PFObject) -> NSDictionary {
        //有三个特殊的属性值：
        var 返回属性字典:NSMutableDictionary = NSMutableDictionary()
        var 对象ID:String? = 信息对象.objectId
        if (对象ID == nil) {
            NSLog("[ParseLink]找不到对象ID。")
        } else {
            返回属性字典.setObject(对象ID!, forKey: "对象ID")
        }
        var 更新时间:NSDate? = 信息对象.updatedAt
        if (更新时间 == nil) {
            NSLog("[ParseLink]找不到对象更新日期。")
        } else {
            返回属性字典.setObject(更新时间!, forKey: "更新时间")
        }
        var 创建时间:NSDate? = 信息对象.createdAt
        if (创建时间 == nil) {
            NSLog("[ParseLink]找不到对象更新日期。")
        } else {
            返回属性字典.setObject(创建时间!, forKey: "创建时间")
        }
        return 返回属性字典
    }
    
    func 重新获取已有对象(信息对象:PFObject) {
        //若您需要用 Parse 云中的最新数据刷新已有对象，您可以像这样调用 refresh 方法：
//        信息对象.refresh //咦？没有？
    }
    
    func 离线保存对象(对象名称:String, 参数字典:NSDictionary) {
        //大多数保存函数会立即执行，并在完成保存后通知您的应用。如果您不需要知道何时保存结束，您可以使用 saveEventually 代替。其优势在于如果用户当前没有网络连接，saveEventually 会将更新保存在设备上，直到重新建立网络连接。如果您的应用在连接恢复之前关闭，Parse 将在下次应用打开时重试。对 saveEventually（以及 deleteEventually）的所有调用均按调用顺序执行，因此针对一个对象调用多次 saveEventually 是安全的。
        let 参数:[NSObject : AnyObject] = 参数字典 as [NSObject : AnyObject]
        var 要上传的对象:PFObject = PFObject(className: 对象名称, dictionary: 参数)
        要上传的对象.saveEventually()
    }
    
    func 对象更新(对象名称:String, 对象ID:String, 要变更内容的字典:NSDictionary) {
        //进行对象更新非常简单。只需在对象上设置一些新的数据并调用其中一种保存方法即可。假设您已保存对象并有 objectId，您可以使用 PFQuery 检索 PFObject 和更新其数据：
        let 查询:PFQuery = PFQuery(className: 对象名称)
        查询.getObjectInBackgroundWithId(对象ID, block: { (返回字典对象:PFObject?, 错误信息:NSError?) -> Void in
            if (错误信息 != nil && 返回字典对象 != nil) {
                NSLog("[ParseLink]未能查询数据“%@”(ID:%@)，因为：%@。",对象名称,对象ID,错误信息!.localizedDescription)
                let 要变更内容的字典的所有键:NSArray = 要变更内容的字典.allKeys
                for 当前键 in 要变更内容的字典的所有键 {
                    let 当前值:AnyObject = 要变更内容的字典.objectForKey(当前键)!
                    返回字典对象!.setObject(当前值, forKey: 当前键 as! String)
                    返回字典对象!.saveInBackground()
                }
            } else {
                NSLog("[ParseLink]成功查询数据“%@”(ID:%@)。",对象名称,对象ID)
            }
        })
        //客户端会自动找出修改的数据，并只向 Parse 发送包含修改的字段。您不需要担心其中会包含您不想更新的数据。
    }
    
    /*
    计数器
    上面的例子包含一种常见的使用案例。“score”（得分）字段是个计数器，需要用玩家的最新得分进行连续更新。上面的方法虽然有用，但是繁琐，如果您有多个客户端在尝试更新同一个计数器就可能会产生一些问题。
    为帮助储存计数器类型的数据，Parse 提供了能够以原子递增（或递减）操作任何数字字段的方法。因此，这项更新可以重写为：
    [gameScore incrementKey:@"score"];
    [gameScore saveInBackground];
    您还可以使用 incrementKey:byAmount: 实现任何数量的递增。
    
    数组
    为帮助存储数组数据，有三种操作可用于以原子级方式更改数组字段：
    addObject:forKey: 和 addObjectsFromArray:forKey: 将给定对象附加在数组字段末端。
    addUniqueObject:forKey: 和 addUniqueObjectsFromArray:forKey: 仅将尚未包含在数组字段中的给定对象添加至该字段。插入位置是不确定的。
    removeObject:forKey: 和 removeObjectsInArray:forKey: 会从数组字段中删除每个给定对象的所有实例。
    例如，我们可以像这样将项目添加到类似于设置的“skills”（技能）字段中：
    [gameScore addUniqueObjectsFromArray:@[@"flying", @"kungfu"] forKey:@"skills"];
    [gameScore saveInBackground];
    注意：目前不能从位于同一保存位置的数组中进行原子级的项目添加和删除操作。在不同类型的数组操作之间，您必须调用 save。
    */
    
    func 删除对象(信息对象:PFObject, 要删除的值:String?) {
        if (要删除的值 == nil) {
            //若要从云中删除对象：
            信息对象.deleteInBackgroundWithBlock { (是否成功: Bool, 错误信息: NSError?) -> Void in
                if (错误信息 != nil && 是否成功 == true) {
                    NSLog("[ParseLink]未能删除对象，因为：%@。",错误信息!.localizedDescription)
                    self.通知中心.postNotificationName("同步:未能删除对象", object: nil)
                } else {
                    NSLog("[ParseLink]成功删除对象。")
                    self.通知中心.postNotificationName("同步:成功删除对象", object: nil)
                }
            }
            //如果想要在确认删除后执行回调，可以使用 deleteInBackgroundWithBlock: 或 deleteInBackgroundWithTarget:selector: 方法。如果想要阻塞调用线程，您可以使用 delete 方法。
        } else {
            //您可以使用 removeObjectForKey 方法从对象中删除单一字段：
            信息对象.removeObjectForKey(要删除的值!)
            信息对象.saveInBackground()
        }
    }
    
    //此处忽略：关系数据，数据类型，子类
    
    // ※ ※ ※ ※ ※ 查 询 ※ ※ ※ ※ ※
    
}
