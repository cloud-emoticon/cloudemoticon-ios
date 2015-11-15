//
//  YashiZip.swift
//  CloudEmoticon2iOS
//
//  Created by 神楽坂雅詩 on 15/5/23.
//  Copyright (c) 2015年 神楽坂雅詩 & 神楽坂紫喵. All rights reserved.
//

import UIKit

protocol YashiZipDelegate{
    func 正在准备解压缩文件路径(压缩文件路径:String,压缩文件信息:unz_global_info)
    func 正在解压缩文件路径(压缩文件路径:String,压缩文件信息:unz_global_info,解压后文件路径:String)
    func 正在准备解压缩文件(当前文件:Int,总计文件:Int,压缩文件路径:String,文件信息:unz_file_info)
    func 正在解压缩文件(当前文件:Int,总计文件:Int,压缩文件路径:String,文件信息:unz_file_info)
}

class YashiZip: NSObject, SSZipArchiveDelegate {
    var 代理:YashiZipDelegate?
    var 解压缩程序:SSZipArchive?
    
    // MARK: - 解压缩
    
    func 解压缩文件(压缩文件路径:String,解压缩目标文件夹:String) -> Bool {
        let path:String = 压缩文件路径
        let destination:String = 解压缩目标文件夹
        let isok:Bool = SSZipArchive.unzipFileAtPath(path, toDestination: destination)
        return isok
    }
    
    func 解压缩文件(压缩文件路径:String,解压缩目标文件夹:String,覆盖目标文件:Bool,解压缩密码:String) throws {
        let 错误回馈变量指针: NSError = NSError(domain: "Migrator", code: 0, userInfo: nil)
        let path:String = 压缩文件路径
        let destination:String = 解压缩目标文件夹
        let overwrite:Bool = 覆盖目标文件
        let password:String = 解压缩密码
        let error:NSErrorPointer = 错误回馈变量指针
        let isok:Bool
        do {
            try SSZipArchive.unzipFileAtPath(path, toDestination: destination, overwrite: overwrite, password: password)
            isok = true
        } catch let error1 as NSError {
            error.memory = error1
            isok = false
        }
        if isok {
            return
        }
        throw 错误回馈变量指针
    }
    
    func 解压缩文件(压缩文件路径:String,解压缩目标文件夹:String,代理接收类:YashiZipDelegate) -> Bool {
        let path:String = 压缩文件路径
        let destination:String = 解压缩目标文件夹
        let dele:SSZipArchiveDelegate = self
        let isok:Bool = SSZipArchive.unzipFileAtPath(path, toDestination: destination, delegate: dele)
        return isok
    }
    
    func 解压缩文件(压缩文件路径:String,解压缩目标文件夹:String,覆盖目标文件:Bool,解压缩密码:String,代理接收类:YashiZipDelegate) throws {
        var 错误回馈变量指针: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
        let path:String = 压缩文件路径
        let destination:String = 解压缩目标文件夹
        let overwrite:Bool = 覆盖目标文件
        let password:String = 解压缩密码
        let error:NSErrorPointer = 错误回馈变量指针
        let dele:SSZipArchiveDelegate = self
        let isok:Bool
        do {
            try SSZipArchive.unzipFileAtPath(path, toDestination: destination, overwrite: overwrite, password: password, error: <#T##NSErrorPointer#>, delegate: dele)
            isok = true
        } catch var error1 as NSError {
            error.memory = error1
            isok = false
        }
        if isok {
            return
        }
        throw 错误回馈变量指针
    }
    
    // MARK: - 压缩
    
    func 创建压缩文件(压缩文件路径:String,来源文件路径数组:NSArray) -> Bool {
        let zippath:String = 压缩文件路径
        let paths:[AnyObject] = 来源文件路径数组 as [AnyObject]
        let isok:Bool = SSZipArchive.createZipFileAtPath(zippath, withFilesAtPaths: paths)
        return isok
    }
    
    func 初始化压缩文件(压缩文件路径:String) {
        let zippath:String = 压缩文件路径
        解压缩程序 = SSZipArchive(path: zippath)
    }
    
    func 打开压缩文件() -> Bool {
        var isok:Bool = false
        if (解压缩程序 != nil) {
            isok = 解压缩程序!.open()
        }
        return isok
    }
    
    func 写入文件(要写入的文件路径:String) -> Bool {
        var isok:Bool = false
        if (解压缩程序 != nil) {
            let filepath:String = 要写入的文件路径
            isok = 解压缩程序!.writeFile(filepath)
        }
        return isok
    }
    
    func 写入数据(要写入的数据:NSData,文件名:String) -> Bool {
        var isok:Bool = false
        if (解压缩程序 != nil) {
            let data:NSData = 要写入的数据
            let filename:String = 文件名
            isok = 解压缩程序!.writeData(data, filename: filename)
        }
        return isok
    }
    
    func 关闭压缩文件() -> Bool {
        var isok:Bool = false
        if (解压缩程序 != nil) {
            isok = 解压缩程序!.close()
        }
        if (isok) {
            强行释放压缩文件()
        }
        return isok
    }
    
    func 强行释放压缩文件() {
        解压缩程序 = nil
    }
    
    // MARK: - 代理方法
    
    func zipArchiveWillUnzipArchiveAtPath(path: String!, zipInfo: unz_global_info) {
        代理?.正在准备解压缩文件路径(path, 压缩文件信息: zipInfo)
    }
    
    func zipArchiveDidUnzipArchiveAtPath(path: String!, zipInfo: unz_global_info, unzippedPath: String!) {
        代理?.正在解压缩文件路径(path, 压缩文件信息: zipInfo, 解压后文件路径: unzippedPath)
    }
    
    func zipArchiveWillUnzipFileAtIndex(fileIndex: Int, totalFiles: Int, archivePath: String!, fileInfo: unz_file_info) {
        代理?.正在准备解压缩文件(fileIndex, 总计文件: totalFiles, 压缩文件路径: archivePath, 文件信息: fileInfo)
    }
    
    func zipArchiveDidUnzipFileAtIndex(fileIndex: Int, totalFiles: Int, archivePath: String!, fileInfo: unz_file_info) {
        代理?.正在解压缩文件(fileIndex, 总计文件: totalFiles, 压缩文件路径: archivePath, 文件信息: fileInfo)
    }
    
}
