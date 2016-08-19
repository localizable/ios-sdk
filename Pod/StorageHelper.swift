//
//  StorageHelper.swift
//  Localizable
//
//  Created by Ivan Bruel on 24/02/16.
//  Copyright © 2016 Localizable. All rights reserved.
//

import Foundation

class StorageHelper: NSObject {

  private static let domain = "Localizable"

  class func saveObject(object: AnyObject?, directory: String? = nil, filename: String) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
      guard let path = pathForFilename(directory, filename: filename) else {
        return
      }

      guard let object = object else {
        do {
          try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch {
          Logger.logError("Could not delete file at path \(path)")
        }
        return
      }

      let data = NSKeyedArchiver.archivedDataWithRootObject(object)
      data.writeToFile(path, atomically: true)
    }
  }

  class func loadObject<T>(directory: String? = nil, filename: String) -> T? {
    guard let path = pathForFilename(directory, filename: filename) else {
      return nil
    }

    guard let data = NSData(contentsOfFile: path) else {
      return nil
    }

    return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? T
  }

}

// MARK: Helpers
private extension StorageHelper {

  private class func pathForFilename(directory: String? = nil, filename: String) -> String? {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)

    guard let userDirectory = paths.first else {
      return nil
    }

    var fileDirectory = "\(userDirectory)/\(StorageHelper.domain)"
    if let directory = directory {
      fileDirectory = fileDirectory.stringByAppendingString("/\(directory)")
    }

    if !NSFileManager.defaultManager().fileExistsAtPath(fileDirectory) {
      do {
      try NSFileManager.defaultManager()
        .createDirectoryAtPath(fileDirectory, withIntermediateDirectories: true, attributes: nil)
      } catch {
        Logger.logError("Could not create folder \(fileDirectory)")
      }
    }

    return "\(fileDirectory)/\(filename)"

  }

}
