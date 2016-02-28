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

  class func saveObject(object: AnyObject?, filename: String) {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { () -> Void in
      guard let path = pathForFilename(filename) else {
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

  class func loadObject<T>(filename: String) -> T? {
    guard let path = pathForFilename(filename) else {
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

  private class func pathForFilename(filename: String) -> String? {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)

    guard let userDirectory = paths.first else {
      return nil
    }

    let directory = "\(userDirectory)/\(StorageHelper.domain)"

    if !NSFileManager.defaultManager().fileExistsAtPath(directory) {
      do {
      try NSFileManager.defaultManager()
        .createDirectoryAtPath(directory, withIntermediateDirectories: false, attributes: nil)
      } catch {
        Logger.logError("Could not create folder \(directory)")
      }
    }

    return "\(directory)/\(filename)"

  }

}
