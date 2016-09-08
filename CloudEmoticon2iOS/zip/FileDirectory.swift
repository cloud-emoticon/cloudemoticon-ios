import Foundation

public struct FileDirectory {
    public static func applicationDirectory(_ directory:Foundation.FileManager.SearchPathDirectory) -> URL? {
        
        var appDirectory:String?
        var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(directory, Foundation.FileManager.SearchPathDomainMask.userDomainMask, true) as [AnyObject];
        if paths.count > 0 {
            if let pathString = paths[0] as? String {
                appDirectory = pathString
            }
        }
        if let dD = appDirectory {
            return URL(string:dD)
        }
        return nil
    }
    
    public static func applicationTemporaryDirectory() -> URL? {
        
        if let tD:String = NSTemporaryDirectory() {
            return URL(string:tD)
        }
        
        return nil
        
    }
}
