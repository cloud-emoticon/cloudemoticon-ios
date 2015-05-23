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
}

class SkinInstaller: NSObject, YashiDownloadDelegate {
    var 代理:SkinInstallerDelegate?
    var 网络下载器:YashiNetworkDownload?
    var 当前下载网址:String?
    var skin文件夹:String?
    
    func 启动安装任务(下载文件网址:String) {
        if (预先校验下载路径(下载文件网址)) {
            let 主题管理器:SkinManager = SkinManager()
            当前下载网址 = 下载文件网址
            //下载文件网址, 输入网络请求模式: NetworkHTTPMethod.GET, 是否要用文件缓存: true, 是否要异步: true, 是否要断点续传: false, 输入超时时间: 20, 输入系统缓存模式: nil, 输入代理: self
            skin文件夹 = 主题管理器.取skin文件夹路径()
            网络下载器 = YashiNetworkDownload(输入下载地址: 下载文件网址, 输入网络请求模式: NetworkHTTPMethod.GET, 是否要用文件缓存: true, 是否要异步: true, 是否要断点续传: false, 输入超时时间: 20, 输入系统缓存模式: nil, 输入代理: self)
            全局_网络繁忙 = true
            网络下载器?.启动连接()
        } else {
            self.代理?.显示安装提示框(true, 标题: lang.uage("主题安装失败"), 内容: lang.uage("下载路径不正确"), 按钮: lang.uage("取消"))
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
    
    func 网络下载收到数据(网络下载器对象:YashiNetworkDownload) {
        let 信息字符串:NSString = 网络下载器对象.信息字符串
        NSLog("[皮肤安装器]正在下载%@。",信息字符串)
        显示安装提示框(true,标题: lang.uage("正在下载"),内容: 信息字符串,按钮: nil)
    }
    func 网络下载数据接收完毕(网络下载器对象:YashiNetworkDownload) {
        全局_网络繁忙 = false
        let 下载的临时文件路径:String = 网络下载器对象.临时文件路径
        NSLog("[皮肤安装器]下载完毕。%@",下载的临时文件路径)
//        显示安装提示框(true,标题: lang.uage("正在下载"),内容: 网络下载器对象.信息字符串,按钮: nil)
//        显示安装提示框(true,标题: lang.uage("已下载到临时文件"),内容: 网络下载器对象.临时文件路径,按钮: lang.uage("确定"))
        解压缩临时文件(下载的临时文件路径)
    }
    func 网络下载遇到错误(网络下载器对象:YashiNetworkDownload) {
        全局_网络繁忙 = false
        NSLog("[皮肤安装器]下载失败。%@",网络下载器对象.网络错误描述)
        显示安装提示框(true,标题: lang.uage("下载失败"),内容: lang.uage("请检查网络后重试"),按钮: lang.uage("取消"))
    }
    func 解压缩临时文件(临时文件路径:String) {
        显示安装提示框(true,标题: lang.uage("正在安装"),内容: NSString(format: "%@: %ld",lang.uage("文件大小"),网络下载器!.总文件大小),按钮: nil)
        let 目标文件夹特征码:String = md5(当前下载网址!)
        let 目标文件夹路径:String = NSString(format: "%@/%@", skin文件夹!,目标文件夹特征码) as String
        NSLog("[皮肤安装器]解压缩... %@ -> %@",临时文件路径,目标文件夹路径)
        let 文件管理器:NSFileManager = NSFileManager.defaultManager()
        if (文件管理器.isExecutableFileAtPath(目标文件夹路径)) {
            文件管理器.removeItemAtPath(目标文件夹路径, error: nil)
        }
        let 压缩文件处理:YashiZip = YashiZip()
        var 错误信息:NSErrorPointer = NSErrorPointer()
        let 解压缩成功:Bool = 压缩文件处理.解压缩文件(临时文件路径, 解压缩目标文件夹: 目标文件夹路径, 覆盖目标文件: true, 解压缩密码: "ce", 错误回馈变量指针: 错误信息)
        if (解压缩成功 && 错误信息 == nil) {
            文件管理器.removeItemAtPath(临时文件路径, error: nil)
            
            NSLog("[皮肤安装器]解压缩成功。《《此处是否成功判断还没有写完")
            显示安装提示框(false,标题: lang.uage("安装完毕"),内容: "",按钮: lang.uage("确定"))
        } else {
            NSLog("[皮肤安装器]解压缩失败：%@",错误信息)
        }
    }
    
    deinit {
        NSLog("[皮肤安装器]释放内存。")
    }
}
