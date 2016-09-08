//
//  FileList.swift
//  SwiftFilesZip
//
//  Created by Anthony Levings on 30/04/2015.
//  Copyright (c) 2015 Gylphi. All rights reserved.
//

import Foundation
// see here for Apple's ObjC Code https://developer.apple.com/library/mac/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/AccessingFilesandDirectories/AccessingFilesandDirectories.html
open class FileList {
    open static func allFilesAndFolders(inDirectory directory:Foundation.FileManager.SearchPathDirectory, subdirectory:String?) -> [URL]? {
        
        // Create load path
        if let loadPath = buildPathToDirectory(directory, subdirectory: subdirectory) {
            
            let url = URL(fileURLWithPath: loadPath)
            var error:NSError?
            
            let properties = [URLResourceKey.localizedNameKey,
                URLResourceKey.creationDateKey, URLResourceKey.localizedTypeDescriptionKey]
            if url == url{
                let array = try? Foundation.FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: properties, options:Foundation.FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                return array
            }
        }
        return nil
    }
    
    open static func allFilesAndFoldersInTemporaryDirectory(_ subdirectory:String?) throws -> [URL]? {
        
        // Create load path
        let loadPath = buildPathToTemporaryDirectory(subdirectory)
        
        let url = URL(fileURLWithPath: loadPath)
        var error:NSError?
        
        let properties = [URLResourceKey.localizedNameKey,
            URLResourceKey.creationDateKey, URLResourceKey.localizedTypeDescriptionKey]
        if url == url{
            let array = try? Foundation.FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: properties, options:Foundation.FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                return array
        }
        return nil
    }
    
    
    // private methods
    
    fileprivate static func buildPathToDirectory(_ directory:Foundation.FileManager.SearchPathDirectory, subdirectory:String?) -> String?  {
        // Remove unnecessary slash if need
        // Remove unnecessary slash if need
        var subDir = ""
        if let sub = subdirectory {
            subDir = FileHelper.stripSlashIfNeeded(sub)
        }
        
        // Create generic beginning to file delete path
        var buildPath = ""
        
        let direct = FileDirectory.applicationDirectory(directory),
            path = direct?.path
                buildPath = path! + "/"
        
        
        buildPath += subDir
        buildPath += "/"
        
        
        var dir:ObjCBool = true
        let dirExists = Foundation.FileManager.default.fileExists(atPath: buildPath, isDirectory:&dir)
        if dir.boolValue == false {
            return nil
        }
        if dirExists == false {
            return nil
        }
        return buildPath
    }
    open static func buildPathToTemporaryDirectory(_ subdirectory:String?) -> String {
        // Remove unnecessary slash if need
        
        var subDir:String?
        if let sub = subdirectory {
            subDir = FileHelper.stripSlashIfNeeded(sub)
        }
        
        // Create generic beginning to file load path
        var loadPath = ""
        
        let direct = FileDirectory.applicationTemporaryDirectory(),
            path = direct?.path
                loadPath = path! + "/"
        
        if let sub = subDir {
            loadPath += sub
            loadPath += "/"
        }
        
        
        // Add requested save path
        return loadPath
    }
    
    
    
}
