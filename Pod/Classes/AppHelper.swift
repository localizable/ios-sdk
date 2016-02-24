//
//  AppHelper.swift
//  Localizable
//
//  Created by Ivan Bruel on 23/02/16.
//  Copyright © 2016 Localizable. All rights reserved.
//

import Foundation

class AppHelper: NSObject {

  private static let tokenKey = "LocalizableToken"

  private static let defaultLanguage = "en"

  class func localizableToken() -> String? {
    return stringFromPlist(AppHelper.tokenKey)
  }

}

private extension AppHelper {

  private class func stringFromPlist(key: String) -> String? {
    guard let infoPlist = NSBundle.mainBundle().infoDictionary else {
      return nil
    }
    return infoPlist[key] as? String
  }

}