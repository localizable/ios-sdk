//
//  AppHelper.swift
//  Localizable
//
//  Created by Ivan Bruel on 23/02/16.
//  Copyright © 2016 Localizable. All rights reserved.
//

import Foundation

class AppHelper {

  private static let tokenKey = "LocalizableToken"
  private static let localizableFileName = "Localizable"
  private static let localizableFileExtension = "strings"

  private static let defaultLanguage = "en"

  class func localizableToken() -> String? {
    return stringFromPlist(AppHelper.tokenKey)
  }

  class func stringsForLanguageCode(code: String) -> [String: String] {
    guard let bundle = bundleForLanguageCode(code),
      path = bundle.pathForResource(AppHelper.localizableFileName,
        ofType: AppHelper.localizableFileExtension) else {
          return [:]
    }
    return NSDictionary(contentsOfFile: path) as? [String: String] ?? [:]
  }

  class func stringForKey(key: String, languageCode code: String) -> String? {
    return AppHelper.bundleForLanguageCode(code)?.localizedStringForKey(key, value: nil, table: nil)
  }

}

private extension AppHelper {

  private class func stringFromPlist(key: String) -> String? {
    guard let infoPlist = NSBundle.mainBundle().infoDictionary else {
      return nil
    }
    return infoPlist[key] as? String
  }

  private class func bundleForLanguageCode(code: String) -> NSBundle? {
    guard let path = NSBundle.mainBundle().pathForResource(code, ofType: "lproj") else {
      return nil
    }
    return NSBundle(path: path)
  }

}