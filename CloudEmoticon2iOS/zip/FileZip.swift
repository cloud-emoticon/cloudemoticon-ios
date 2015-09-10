//
//  FileZip.swift
//  SwiftFilesZip
//
//  Created by Anthony Levings on 30/04/2015.
//  Copyright (c) 2015 Gylphi. All rights reserved.
//

import Foundation

public class FileZip {
    
    public static func unzipFile(path:String, toDirectory directory:NSSearchPathDirectory, subdirectory:String?) {
        // Remove unnecessary slash if need
        let newPath = stripSlashIfNeeded(path)
        var subDir:String?
        if let sub = subdirectory {
            subDir = stripSlashIfNeeded(sub)
        }
        
        // Create generic beginning to file save path
        var savePath = ""
        
        if let direct = applicationDirectory(directory),
            savingPath = direct.path {
                savePath = savingPath + "/"
        }
        
        if let sub = subDir {
            savePath += sub
            savePath += "/"
        }
        
        // Add requested save path

        SSZipArchive.unzipFileAtPath(path, toDestination: savePath)
    }
    public static func unzipFileToTemporaryDirectory(path:String, subdirectory:String?) {
        // Remove unnecessary slash if need
        // Remove unnecessary slash if need
        let newPath = stripSlashIfNeeded(path)
        var subDir:String?
        if let sub = subdirectory {
            subDir = stripSlashIfNeeded(sub)
        }
        
        // Create generic beginning to file save path
        var savePath = ""
        
        if let direct = applicationTemporaryDirectory(),
            savingPath = direct.path {
                savePath = savingPath + "/"
        }
        
        if let sub = subDir {
            savePath += sub
            savePath += "/"
        }
        

        SSZipArchive.unzipFileAtPath(path, toDestination: savePath)
    }
    
    public static func unzipEPUB(path:String, subdirectory:String?) -> [NSURL] {
        
        let subD = subdirectory ?? ""
        // TODO: this works but don't force unwrap here!
        unzipFileToTemporaryDirectory(path, subdirectory: "EPUB/" + subD)
        
        
        var subDir:String?
        if let sub = subdirectory {
            subDir = stripSlashIfNeeded(sub)
        }

        var savePath = ""
        
        if let direct = applicationTemporaryDirectory(),
            savingPath = direct.path {
                savePath = savingPath + "/EPUB/"
        }
        
        if let sub = subDir {
            savePath += sub
            savePath += "/"
        }
        return EPUBContainerParser().parseXML(NSURL(fileURLWithPath: savePath))
    }
    
    
    
    // private methods
    
    //directories
    private static func applicationDirectory(directory:NSSearchPathDirectory) -> NSURL? {
        
        var appDirectory:String?
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(directory, NSSearchPathDomainMask.UserDomainMask, true);
        if paths.count > 0 {
            if let pathString = paths[0] as? String {
                appDirectory = pathString
            }
        }
        if let dD = appDirectory {
            return NSURL(string:dD)
        }
        return nil
    }
    
    
    
    
    private static func applicationTemporaryDirectory() -> NSURL? {
        
        if let tD = NSTemporaryDirectory() {
            return NSURL(string:tD)
        }
        
        return nil
        
    }
    
    //pragma mark - strip slashes
    
    private static func stripSlashIfNeeded(stringWithPossibleSlash:String) -> String {
        var stringWithoutSlash:String = stringWithPossibleSlash
        // If the file name contains a slash at the beginning then we remove so that we don't end up with two
        if stringWithPossibleSlash.hasPrefix("/") {
            stringWithoutSlash = stringWithPossibleSlash.substringFromIndex(stringWithoutSlash.startIndex.advancedBy(1))
        }
        // Return the string with no slash at the beginning
        return stringWithoutSlash
    }
    
    
}