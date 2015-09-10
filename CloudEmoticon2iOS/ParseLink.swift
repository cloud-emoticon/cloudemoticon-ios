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
            if (错误信息 != nil || 是否成功 == true) {
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
        let 要上传的对象:PFObject = PFObject(className: 对象名称, dictionary: 参数)
        要上传的对象.saveInBackgroundWithBlock { (是否成功: Bool, 错误信息: NSError?) -> Void in
            if (错误信息 != nil || 是否成功 == true) {
                NSLog("[ParseLink]未能存储数据“%@”，因为：%@。",对象名称,错误信息!.localizedDescription)
                self.通知中心.postNotificationName("P同步:未能存储数据", object: 错误信息!.localizedDescription)
            } else {
                NSLog("[ParseLink]成功存储数据“%@”。",对象名称)
                self.通知中心.postNotificationName("P同步:成功存储数据", object: nil)
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
            if (错误信息 != nil || 返回字典对象 != nil) {
                NSLog("[ParseLink]未能查询数据“%@”(ID:%@)，因为：%@。",对象名称,对象ID,错误信息!.localizedDescription)
                self.通知中心.postNotificationName("P同步:查询对象失败", object: 错误信息!.localizedDescription)
            } else {
                NSLog("[ParseLink]成功查询数据“%@”(ID:%@)。",对象名称,对象ID)
                self.通知中心.postNotificationName("P同步:查询对象完成", object: 返回字典对象!)
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
        let 返回属性字典:NSMutableDictionary = NSMutableDictionary()
        let 对象ID:String? = 信息对象.objectId
        if (对象ID == nil) {
            NSLog("[ParseLink]找不到对象ID。")
        } else {
            返回属性字典.setObject(对象ID!, forKey: "对象ID")
        }
        let 更新时间:NSDate? = 信息对象.updatedAt
        if (更新时间 == nil) {
            NSLog("[ParseLink]找不到对象更新日期。")
        } else {
            返回属性字典.setObject(更新时间!, forKey: "更新时间")
        }
        let 创建时间:NSDate? = 信息对象.createdAt
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
        let 要上传的对象:PFObject = PFObject(className: 对象名称, dictionary: 参数)
        要上传的对象.saveEventually()
    }
    
    func 对象更新(对象名称:String, 对象ID:String, 要变更内容的字典:NSDictionary) {
        //进行对象更新非常简单。只需在对象上设置一些新的数据并调用其中一种保存方法即可。假设您已保存对象并有 objectId，您可以使用 PFQuery 检索 PFObject 和更新其数据：
        let 查询:PFQuery = PFQuery(className: 对象名称)
        查询.getObjectInBackgroundWithId(对象ID, block: { (返回字典对象:PFObject?, 错误信息:NSError?) -> Void in
            if (错误信息 != nil || 返回字典对象 != nil) {
                NSLog("[ParseLink]未能查询数据“%@”(ID:%@)，因为：%@。",对象名称,对象ID,错误信息!.localizedDescription)
            } else {
                NSLog("[ParseLink]成功查询数据“%@”(ID:%@)。",对象名称,对象ID)
                let 要变更内容的字典的所有键:NSArray = 要变更内容的字典.allKeys
                for 当前键 in 要变更内容的字典的所有键 {
                    let 当前值:AnyObject = 要变更内容的字典.objectForKey(当前键)!
                    返回字典对象!.setObject(当前值, forKey: 当前键 as! String)
                    返回字典对象!.saveInBackground()
                }
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
                if (错误信息 != nil || 是否成功 == true) {
                    NSLog("[ParseLink]未能删除对象，因为：%@。",错误信息!.localizedDescription)
                    self.通知中心.postNotificationName("P同步:未能删除对象", object: 错误信息!.localizedDescription)
                } else {
                    NSLog("[ParseLink]成功删除对象。")
                    self.通知中心.postNotificationName("P同步:成功删除对象", object: nil)
                }
            }
            //如果想要在确认删除后执行回调，可以使用 deleteInBackgroundWithBlock: 或 deleteInBackgroundWithTarget:selector: 方法。如果想要阻塞调用线程，您可以使用 delete 方法。
        } else {
            //您可以使用 removeObjectForKey 方法从对象中删除单一字段：
            信息对象.removeObjectForKey(要删除的值!)
            信息对象.saveInBackground()
        }
    }
    
    //跳过：关系数据，数据类型，子类
    
    // ※ ※ ※ ※ ※ 查 询 ※ ※ ※ ※ ※
    //（应用不涉及高级查询，跳过，需要时再添加此处内容）
    
    /* ※ ※ ※ ※ ※ 用 户 ※ ※ ※ ※ ※
    
    许多应用的核心理念是，用户帐户保护应能让用户安全访问他们的信息。我们提供一个类名为 PFUser 的专门用户类，可自动处理用户帐户管理需要的很多功能。
    您可以使用这个用户类在您的应用程序中添加用户帐户功能。
    PFUser 是 PFObject 的一个子类，拥有完全相同的特性，如灵活架构、自动留存和键值接口。PFObject 上的所有方法也存在于 PFUser 中。所不同的是 PFUser 具有针对用户帐户的一些特殊的附加功能。
    
    属性
    PFUser 有几种可以将其与 PFObject 区分开的属性：
    用户名：用户的用户名（必填）。
    密码：用户的密码（注册时必填）。
    电子邮箱：用户的电子邮箱地址（选填）。
    我们在浏览用户的各种用例时，会逐条仔细查看这些信息。请切记，如果您通过这些属性设置 username 和 email，则无需使用 setObject:forKey: 方法进行设置 － 这是自动设置的。
    */
    
    func 用户注册(用户名:String, 密码:String, 邮箱:String) {
        let 用户:PFUser = PFUser()
        用户.username = 用户名
        用户.password = 密码
        用户.email = 邮箱
        //其他资料
        //用户.setObject("10086", forKey: "phone")
        用户.signUpInBackgroundWithBlock { (是否成功: Bool, 错误信息: NSError?) -> Void in
            if (错误信息 != nil || 是否成功 != true) {
                NSLog("[ParseLink]未能注册用户“%@”，因为：%@。",用户名,错误信息!.localizedDescription)
                self.通知中心.postNotificationName("P用户:注册失败", object: 错误信息!.localizedDescription)
            } else {
                NSLog("[ParseLink]成功注册用户“%@”。",用户名)
                self.通知中心.postNotificationName("P用户:注册成功", object: nil)
            }
        }
        /*
        这个调用将在您的 Parse 应用中异步创建一个新的用户。创建前，它还会检查确保用户名和邮箱唯一。此外，它还将密码安全散列在云中。我们从来不以纯文本格式储存密码，也不会以纯文本格式将密码传输回客户端。
        注意，我们使用的是 signUp 方法，而不是 save 方法。应始终使用 signUp 方法创建新的 PFUser。调用 save 可以完成用户的后续更新。
        signUp 方法具有带回传错误功能的各种版本和同步版本。同样，我们强烈建议在可能的情况下使用异步版本，从而防止屏蔽您应用程序中的 UI。要想了解关于这些具体方法的更多信息，请参见我们的 API 文档。
        若未成功注册，您应该查看返回的错误对象。最可能的情况就是该用户名或邮箱已被其他用户使用。你应该将这种情况清楚地告诉用户，并要求他们尝试不同的用户名。
        您可以使用电子邮箱地址作为用户名。只需让您的用户输入他们的电子邮箱，但是需要将它填写在用户名属性中 － PFUser 将可以正常运作。我们将在重置密码部分说明是如何处理这种情况的。
        */
    }
    
    func 用户登录(用户名:String, 密码:String) {
        //当然，您让用户注册后，需要让他们以后登录到他们的帐户。要如此，您可以使用类方法 logInWithUsernameInBackground:password:。
        PFUser.logInWithUsernameInBackground(用户名, password: 密码) { (登录的用户:PFUser?, 错误信息:NSError?) -> Void in
            if (错误信息 != nil || 登录的用户 == nil) {
                NSLog("[ParseLink]未能登录用户“%@”，因为：%@。",用户名,错误信息!.localizedDescription)
                self.通知中心.postNotificationName("P用户:登录失败", object: 错误信息!.localizedDescription)
            } else {
                NSLog("[ParseLink]成功登录用户“%@”。",用户名)
                self.通知中心.postNotificationName("P用户:登录成功", object: nil)
            }
        }
    }
    
    /* 验证电子邮箱:
    在应用程序的设置中启用电子邮箱验证，可以让应用程序将某些使用体验提供给验证过电子邮箱地址的用户。电子邮箱验证会将 emailVerified 键添加到 PFUser 目标中。设置或修改 PFUser 的 email 后，emailVerified 被设置为 false。随后，Parse 会向用户发送一个邮件，其中包含一个链接，可将 emailVerified 设置为 true。
    
    有三种 emailVerified 状态需要考虑：
    
    true － 用户通过点击 Parse 发送给他们的链接确认电子邮箱地址。最初创建用户帐户时，PFUsers 没有 true 值。
    false － PFUser 对象最后一次刷新时，用户未确认其电子邮箱地址。若 emailVerified 为 false，可以考虑调用 PFUser 中的 refresh:。
    缺失 － 电子邮箱验证关闭或 PFUser 没有 email 时创建了 PFUser。
    */
    
    func 当前用户() -> NSDictionary? {
        //若用户每次打开您的应用时都要登录，会很麻烦。您可以用缓存的 currentUser 对象来避免这一繁琐操作。
        //每次您使用任何注册或登录方法时，用户都被缓存到磁盘中。您可以把这个缓存作为一个对话，并自动假设用户已登录：
        let 已登录用户:PFUser? = PFUser.currentUser()
        if (已登录用户 == nil || 已登录用户!.username == nil) {
            NSLog("[ParseLink]还没有用户登录。")
        } else {
            NSLog("[ParseLink]自动登录用户“%@”。",已登录用户!.username!)
            let 已登录用户名:String = 已登录用户!.username!
            let 已登录邮箱:String = 已登录用户!.email!
            let 已登录用户ID:String = 已登录用户!.objectId!
            let 返回信息:NSDictionary = NSDictionary(objectsAndKeys: 已登录用户名,"已登录用户名",已登录邮箱,"已登录邮箱",已登录用户ID,"已登录用户ID")
            return 返回信息
        }
        return nil
    }
    
    func 注销用户() {
        //您可以通过注销用户来清除他们的当前登录状态：
        PFUser.logOut()
        let currentUser:PFUser? = PFUser.currentUser()
    }
    
    func 匿名用户() {
        //能够将数据和对象与具体用户关联非常有价值，但是有时您想在不强迫用户输入用户名和密码的情况下也能达到这种效果。
        //匿名用户是指能在无用户名和密码的情况下创建的但仍与任何其他 PFUser 具有相同功能的用户。登出后，匿名用户将被抛弃，其数据也不能再访问。
        //您可以使用 PFAnonymousUtils 创建匿名用户：
        PFAnonymousUtils.logInWithBlock { (登录的用户:PFUser?, 错误信息:NSError?) -> Void in
            if (错误信息 != nil || 登录的用户 != nil) {
                NSLog("[ParseLink]未能创建匿名用户，因为：%@。",错误信息!.localizedDescription)
                self.通知中心.postNotificationName("P用户:匿名登录失败", object: 错误信息!.localizedDescription)
            } else {
                NSLog("[ParseLink]成功创建匿名用户“%@”。",登录的用户!.username!)
                self.通知中心.postNotificationName("P用户:匿名登录成功", object: nil)
            }
        }
    }
    
    func 是否为匿名用户() -> Bool{
        //您可以通过设置用户名和密码，然后调用 signUp 的方式，或者通过登录或关联 Facebook 或 Twitter 等服务的方式，将匿名用户转换为常规用户。转换的用户将保留其所有数据。想要确定当前用户是否为匿名用户，可以试试 PFAnonymousUtils isLinkedWithUser：
        return PFAnonymousUtils.isLinkedWithUser(PFUser.currentUser())
    }
    
    func 创建本地匿名账户() {
        //在无网络请求的情况下，也可以自动为您创建匿名用户，以便您能在应用程序开启之后立即与您的用户互动。如果您启用在应用程序开启时自动创建匿名用户的功能，则 [PFUser currentUser] 将不会为 nil。首次保存用户或与该用户相关的任何对象时，将在云中自动创建用户。截止此时，该用户的对象 ID 将为 nil。启用自动创建用户功能将使得把数据与您的用户关联变得简单。例如，在您的 application:didFinishLaunchingWithOptions: 函数中，您可以写入：
        PFUser.enableAutomaticUser()
        PFUser.currentUser()?.incrementKey("RunCount")
        PFUser.currentUser()?.saveInBackground()
    }
    
    func 设置当前用户(现有Token:String) {
        //如果您已经创建了自己的身份验证例程，或以其他方式使用户在服务器端登录，您现在可以将会话令牌传递到客户端并使用 become 方法。这种方法将确保会话令牌在设置当前用户之前有效。
        PFUser.becomeInBackground(现有Token, block: { (登录的用户:PFUser?, 错误信息:NSError?) -> Void in
            if (错误信息 != nil || 登录的用户 != nil) {
                NSLog("[ParseLink]未能使用Token登录用户，因为：%@。",错误信息!.localizedDescription)
                self.通知中心.postNotificationName("P用户:Token登录失败", object: 错误信息!.localizedDescription)
            } else {
                NSLog("[ParseLink]成功使用Token登录用户“%@”。",登录的用户!.username!)
                self.通知中心.postNotificationName("P用户:Token登录成功", object: nil)
            }
        })
    }
    
    //用户对象的安全性:忽略
    
    func 其他对象的安全性(对象名称:String) {
        //适用于 PFUser 的安全模型同样适用于其他对象。对于任何对象，您都可以指定哪些用户可以查看该对象，哪些用户可以修改该对象。为支持这类安全性，每个对象都有一个访问控制列表，由 PFACL 类实施。
        //使用 PFACL 的最简单的方法就是规定某个对象只能由某一用户只读或只写。要创建这样一个对象，首先必须有一个已登录的 PFUser。然后，ACLWithUser 方法生成一个限制用户访问权限的 PFACL。像其他属性一样，保存对象时，对象的 ACL 会更新。因此，就会创建一个只能由当前用户访问的专用注释。
        let 要处理的对象:PFObject = PFObject(className: 对象名称)
        let 当前用户:PFUser? = PFUser.currentUser()
        if (当前用户 == nil) {
            NSLog("[ParseLink]当前没有登录用户。")
        } else {
            NSLog("[ParseLink]保存了用户私有对象。")
            要处理的对象.ACL = PFACL(user: 当前用户!)
            要处理的对象.saveInBackground()
        }
        //此方法剩余内容:忽略
    }
    
    func 重置密码(邮箱:String) {
        PFUser.requestPasswordResetForEmailInBackground(邮箱)
    }
    
    //实在写不下去了。到这里应该够用了。以后根据需要慢慢补充吧。
}
