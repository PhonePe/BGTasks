//
//  FileManager+BG.swift
//  BGFramework
//
//  Created by Shridhara V on 24/03/21.
//

import Foundation

extension FileManager {
    static func dbDirectory() -> String? {
        guard let documentsFolderPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else {
            return nil
        }
        let path = ((documentsFolderPath as NSString).appendingPathComponent("BGFramework") as NSString).appendingPathComponent("Database")
        return path
    }
    
    static func createDirectoryIfRequired(path: String) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                debugLog("Can't create directory at path=\(path), error=\(error)")
            }
        }
    }
}
