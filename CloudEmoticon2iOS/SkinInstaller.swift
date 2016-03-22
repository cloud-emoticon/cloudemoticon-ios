//
//  SkinInstaller.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/4/19.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

protocol SkinInstallerDelegate{
    func 显示安装提示框(显示:Bool,标题:NSString,内容:NSString,按钮:NSString?)
    func 主题安装完成()
}

class SkinInstaller: NSObject, YashiNetworkKitDelegate {
    var 代理:SkinInstallerDelegate?
    var 网络下载器:YashiNetworkKit?
    var 当前下载网址:String?
    var skin文件夹:String?
    
    func 启动安装任务(下载文件网址:String) {
        if (预先校验下载路径(下载文件网址)) {
            let 主题管理器:SkinManager = SkinManager()
            当前下载网址 = 下载文件网址
            //下载文件网址, 输入网络请求模式: NetworkHTTPMethod.GET, 是否要用文件缓存: true, 是否要异步: true, 是否要断点续传: false, 输入超时时间: 20, 输入系统缓存模式: nil, 输入代理: self
            skin文件夹 = 主题管理器.取skin文件夹路径()
            网络下载器 = YashiNetworkKit()
            网络下载器!.传输模式 = 传输模式为.下载文件
            网络下载器!.网址 = 下载文件网址
            网络下载器!.下载到文件 = nil
            网络下载器!.代理 = self
            //网络下载器 = YashiNetworkDownload(输入下载地址: 下载文件网址, 输入网络请求模式: NetworkHTTPMethod.GET, 是否要用文件缓存: true, 是否要异步: true, 是否要断点续传: false, 输入超时时间: 20, 输入系统缓存模式: nil, 输入代理: self)
            全局_网络繁忙 = true
            网络下载器!.开始请求()
        } else {
            self.代理?.显示安装提示框(true, 标题: lang.uage("主题安装失败"), 内容: lang.uage("下载路径不正确"), 按钮: lang.uage("取消"))
        }
    }
    
    func YashiNetworkKit实时汇报进度(已下载字节数:Int64, 总计字节数:Int64, 当前进度百分比:Int64) {
        let 信息字符串:NSString = NSString(format: "%d%@/%d%@，%f%%",已下载字节数,lang.uage("字节"),总计字节数,lang.uage("字节"),当前进度百分比)
        NSLog("[皮肤安装器]正在下载%@。",信息字符串)
        显示安装提示框(true,标题: lang.uage("正在下载"),内容: 信息字符串,按钮: nil)
    }
    func YashiNetworkKit下载结束(当前下载类:YashiNetworkKit) {
        
    }
    func YashiNetworkKit网络操作结束(当前下载类:YashiNetworkKit, 发生错误:NSError?) {
        
    }
    func YashiNetworkKit请求结果(当前下载类:YashiNetworkKit, 返回的网址:NSURL?, 返回的数据:NSData?, 返回的文件:String?, 返回的状态码:NSURLResponse?, 错误信息:NSError?) {
        全局_网络繁忙 = false
        if (错误信息 != nil) {
            NSLog("[皮肤安装器]下载失败。%@",错误信息!.localizedDescription)
            显示安装提示框(true,标题: lang.uage("下载失败"),内容: lang.uage("请检查网络后重试"),按钮: lang.uage("取消"))
        } else {
            let 下载的临时文件路径:String = 当前下载类.临时文件!
            NSLog("[皮肤安装器]下载到%@完毕，开始解压缩。",下载的临时文件路径)
            //显示安装提示框(true,标题: lang.uage("正在下载"),内容: 网络下载器对象.信息字符串,按钮: nil)
            //显示安装提示框(true,标题: lang.uage("已下载到临时文件"),内容: 网络下载器对象.临时文件路径,按钮: lang.uage("确定"))
            解压缩临时文件(下载的临时文件路径)
        }
    }
    
    func 显示安装提示框(显示:Bool,标题:NSString,内容:NSString,按钮:NSString?) {
        self.代理?.显示安装提示框(显示, 标题: 标题, 内容: 内容, 按钮: 按钮)
    }
    
    func 预先校验下载路径(下载文件路径:NSString) -> Bool {
        if (下载文件路径.length > 11) {
            let 后缀:NSString = 下载文件路径.substringFromIndex(下载文件路径.length-4)
            if (!后缀.isEqualToString(".zip")) {
                return false
            }
            let 前缀:NSString = 下载文件路径.substringToIndex(7)
            if (!前缀.isEqualToString("http://") && !前缀.isEqualToString("https:/")) {
                return false
            }
            return true
        }
        return false
    }
    func 解压缩临时文件(临时文件路径:String) {
        显示安装提示框(true,标题: lang.uage("正在安装"),内容: NSString(format: "%@: %ld",lang.uage("文件大小"),网络下载器!.下载文件总大小),按钮: nil)
        let 目标文件夹特征码:String = md5(当前下载网址!)
        let 目标文件夹路径:String = NSString(format: "%@/%@", skin文件夹!,目标文件夹特征码) as String
        NSLog("[皮肤安装器]解压缩... %@ -> %@",临时文件路径,目标文件夹路径)
        let 文件管理器:NSFileManager = NSFileManager.defaultManager()
        if (文件管理器.fileExistsAtPath(目标文件夹路径)) {
            do {
                try 文件管理器.removeItemAtPath(目标文件夹路径)
            } catch _ {
            }
        }
        let 压缩文件处理:YashiZip = YashiZip()
        var 解压缩错误信息:String? = nil
        for _ in 0...1 { //如果失败则重试一次
            let 错误信息:NSErrorPointer = nil
            let 本次解压缩成功:Bool
            do {
                try 压缩文件处理.解压缩文件(临时文件路径, 解压缩目标文件夹: 目标文件夹路径, 覆盖目标文件: true, 解压缩密码: "ce")
                本次解压缩成功 = true
            } catch let error as NSError {
                错误信息.memory = error
                本次解压缩成功 = false
            }
            if (本次解压缩成功 && 错误信息 == nil) {
                let INI文件路径:String = String(format: "%@/index.ini", 目标文件夹路径)
                let INI读取器:INIReader = INIReader()
                let INI读取状态码:Int = INI读取器.载入INI文件(INI文件路径)
                switch INI读取状态码 {
                case 0:
                    let INI字典:NSMutableDictionary = INI读取器.INI文件内容字典!
                    INI字典.setObject(目标文件夹特征码, forKey: "md5")
//                    NSLog("INI字典 = %@",INI字典)
                    break
                case 1:
                    解压缩错误信息 = lang.uage("找不到文件")
                    break
                case 2:
                    解压缩错误信息 = lang.uage("密码或编码不正确")
                    break
                case 3:
                    解压缩错误信息 = lang.uage("解析失败")
                    break
                case 4:
                    解压缩错误信息 = lang.uage("皮肤包版本错误或配置缺失")
                    break
                default:
                    break
                }
                do {
                    try 文件管理器.removeItemAtPath(临时文件路径)
                } catch _ {
                }
                if (INI读取状态码 > 0) {
                    do {
                        try 文件管理器.removeItemAtPath(目标文件夹路径)
                    } catch _ {
                    }
                }
                break
            } else {
                解压缩错误信息 = String(format: "%@", 错误信息)
            }
        }
        if (解压缩错误信息 == nil) {
            do {
                try 文件管理器.removeItemAtPath(临时文件路径)
            } catch _ {
            }
            显示安装提示框(true,标题: lang.uage("安装完毕"),内容: "",按钮: lang.uage("确定"))
            NSLog("[皮肤安装器]安装成功。")
            代理!.主题安装完成()
        } else {
            显示安装提示框(true,标题: lang.uage("安装失败"),内容: 解压缩错误信息!,按钮: lang.uage("取消"))
            NSLog("[皮肤安装器]安装失败。")
        }
    }
    
    deinit {
        NSLog("[皮肤安装器]释放内存。")
    }
}
