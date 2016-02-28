//
//  UserDefaults.swift
//  Localizable
//
//  Created by Ivan Bruel on 24/02/16.
//  Copyright © 2016 Localizable. All rights reserved.
//

import Foundation

class UserDefaultsHelper: NSObject {

  private static let domain = "Localizable"
  private static let userDefaults = NSUserDefaults.standardUserDefaults()

  class func saveString(string: String, key: String) {
    userDefaults.setObject(string, forKey: userDefaultsKey(key))
    userDefaults.synchronize()
  }

  class func stringForKey(key: String) -> String? {
    return userDefaults.objectForKey(userDefaultsKey(key)) as? String
  }

}

extension UserDefaultsHelper {

  private class func userDefaultsKey(key: String) -> String {
    return "\(domain).\(key)"
  }

}