//
//  FileLoad.swift
//
//  Created by Anthony Levings on 25/06/2014.

//

import Foundation

public struct FileLoad {
    
    
    public static func loadData(_ path:String, directory:Foundation.FileManager.SearchPathDirectory, subdirectory:String?) -> Data?
    {
        
        let loadPath = buildPath(path, inDirectory: directory, subdirectory: subdirectory)
        // load the file and see if it was successful
        let data = Foundation.FileManager.default.contents(atPath: loadPath)
        // Return data
        return data
        
    }
    
    
    public static func loadDataFromTemporaryDirectory(_ path:String, subdirectory:String?) -> Data?
    {
        
        
        let loadPath = buildPathToTemporaryDirectory(path, subdirectory: subdirectory)
        // Save the file and see if it was successful
        let data = Foundation.FileManager.default.contents(atPath: loadPath)
        
        // Return status of file save
        return data
        
        
    }
    
    
    // string methods
    
    public static func loadString(_ path:String, directory:Foundation.FileManager.SearchPathDirectory, subdirectory:String?, encoding enc:String.Encoding = String.Encoding.utf8) -> String?
    {
        let loadPath = buildPath(path, inDirectory: directory, subdirectory: subdirectory)
        
        var error:NSError?
        print(loadPath)
        // Save the file and see if it was successful
        let text:String?
        do {
            text = try String(contentsOfFile:loadPath, encoding:enc)
        } catch let error1 as NSError {
            error = error1
            text = nil
        }
        
        
        return text
        
    }
    
    
    public static func loadStringFromTemporaryDirectory(_ path:String, subdirectory:String?, encoding enc:String.Encoding = String.Encoding.utf8) -> String? {
        
        let loadPath = buildPathToTemporaryDirectory(path, subdirectory: subdirectory)
        
        var error:NSError?
        print(loadPath)
        // Save the file and see if it was successful
        var text:String?
        do {
            text = try String(contentsOfFile:loadPath, encoding:enc)
        } catch let error1 as NSError {
            error = error1
            text = nil
        }
        
        
        return text
        
    }
    
    
    
    // private methods
    
    fileprivate static func buildPath(_ path:String, inDirectory directory:Foundation.FileManager.SearchPathDirectory, subdirectory:String?) -> String  {
        // Remove unnecessary slash if need
        let newPath = FileHelper.stripSlashIfNeeded(path)
        var subDir:String?
        if let sub = subdirectory {
            subDir = FileHelper.stripSlashIfNeeded(sub)
        }
        
        // Create generic beginning to file load path
        var loadPath = ""
        
        let direct = FileDirectory.applicationDirectory(directory),
            path = direct?.path
                loadPath = path! + "/"
        
        
        if let sub = subDir {
            loadPath += sub
            loadPath += "/"
        }
        
        
        // Add requested load path
        loadPath += newPath
        return loadPath
    }
    public static func buildPathToTemporaryDirectory(_ path:String, subdirectory:String?) -> String {
        // Remove unnecessary slash if need
        let newPath = FileHelper.stripSlashIfNeeded(path)
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
        loadPath += newPath
        return loadPath
    }
    
    
    
    
    
}
