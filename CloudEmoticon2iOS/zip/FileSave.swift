import Foundation


public struct FileSave {
    
    
    public static func saveData(_ fileData:Data, directory:Foundation.FileManager.SearchPathDirectory, path:String, subdirectory:String?) -> Bool
    {
        
        let savePath = buildPath(path, inDirectory: directory, subdirectory: subdirectory)
        // Save the file and see if it was successful
        let ok:Bool = Foundation.FileManager.default.createFile(atPath: savePath,contents:fileData, attributes:nil)
        
        // Return status of file save
        return ok
        
    }
    
    public static func saveDataToTemporaryDirectory(_ fileData:Data, path:String, subdirectory:String?) -> Bool
    {
        
        let savePath = buildPathToTemporaryDirectory(path, subdirectory: subdirectory)
        // Save the file and see if it was successful
        let ok:Bool = Foundation.FileManager.default.createFile(atPath: savePath,contents:fileData, attributes:nil)
        
        // Return status of file save
        return ok
    }
    
    
    // string methods
    
    public static func saveString(_ fileString:String, directory:Foundation.FileManager.SearchPathDirectory, path:String, subdirectory:String) -> Bool {
        let savePath = buildPath(path, inDirectory: directory, subdirectory: subdirectory)
        var error:NSError?
        // Save the file and see if it was successful
        let ok:Bool
        do {
            try fileString.write(toFile: savePath, atomically:false, encoding:String.Encoding.utf8)
            ok = true
        } catch let error1 as NSError {
            error = error1
            ok = false
        }
        
        if (error != nil) {print(error)}
        
        // Return status of file save
        return ok
        
    }
    public static func saveStringToTemporaryDirectory(_ fileString:String, path:String, subdirectory:String) -> Bool {
        
        let savePath = buildPathToTemporaryDirectory(path, subdirectory: subdirectory)
        
        var error:NSError?
        // Save the file and see if it was successful
        var ok:Bool
        do {
            try fileString.write(toFile: savePath, atomically:false, encoding:String.Encoding.utf8)
            ok = true
        } catch let error1 as NSError {
            error = error1
            ok = false
        }
        
        if (error != nil) {
            print(error)
        }
        
        // Return status of file save
        return ok;
        
    }
    
    
    
    
    // private methods
    public static func buildPath(_ path:String, inDirectory directory:Foundation.FileManager.SearchPathDirectory, subdirectory:String?) -> String  {
        // Remove unnecessary slash if need
        let newPath = FileHelper.stripSlashIfNeeded(path)
        var newSubdirectory:String?
        if let sub = subdirectory {
            newSubdirectory = FileHelper.stripSlashIfNeeded(sub)
        }
        // Create generic beginning to file save path
        var savePath:String = ""
        let direct = FileDirectory.applicationDirectory(directory),
            path = direct?.path
                savePath = path! + "/"
        
        
        if (newSubdirectory != nil) {
            //NSCharacterSet *character= [NSCharacterSet whitespaceCharacterSet];
            //return [self stringByTrimmingCharactersInSet:character];
            //savePath.extend(newSubdirectory!)
            
            //修正:去除特殊字符
            savePath = newSubdirectory!.trimmingCharacters(in: CharacterSet.whitespaces)
            //
            FileHelper.createSubDirectory(savePath)
            savePath += "/"
        }
        
        // Add requested save path
        savePath += newPath
        
        return savePath
    }
    
    public static func buildPathToTemporaryDirectory(_ path:String, subdirectory:String?) -> String {
        // Remove unnecessary slash if need
        let newPath = FileHelper.stripSlashIfNeeded(path)
        var newSubdirectory:String?
        if let sub = subdirectory {
            newSubdirectory = FileHelper.stripSlashIfNeeded(sub)
        }
        
        // Create generic beginning to file save path
        var savePath = ""
        let direct = FileDirectory.applicationTemporaryDirectory(),
            path = direct?.path
                savePath = path! + "/"
        
        
        if let sub = newSubdirectory {
            savePath += sub
            FileHelper.createSubDirectory(savePath)
            savePath += "/"
        }
        
        // Add requested save path
        savePath += newPath
        return savePath
    }
    
    
    
    
}
