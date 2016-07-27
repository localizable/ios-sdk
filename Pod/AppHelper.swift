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

  class var localizableToken: String? {
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

  class var debugMode: Bool {
    guard !DeviceHelper.isSimulator else {
      return true
    }

    guard let embeddedMobileProvision = embeddedMobileProvision else {
      return false
    }

    return embeddedMobileProvision.containsString("<key>get-task-allow</key><true/>")
  }

  class var name: String? {
    return stringFromPlist("CFBundleName")
  }

  class var bundle: String? {
    return NSBundle.mainBundle().bundleIdentifier
  }

  class var version: String? {
    return stringFromPlist("CFBundleShortVersionString")
  }

  class var build: String? {
    return stringFromPlist("CFBundleVersion")
  }

  class var json: [String: AnyObject] {
    var json = [String: AnyObject]()

    if let name = name {
      json["name"] = name
    }

    if let bundle = bundle {
      json["bundle"] = bundle
    }

    if let version = version {
      json["version"] = version
    }

    if let build = build {
      json["build"] = build
    }

    return json
  }

}

private extension AppHelper {

  private static var embeddedMobileProvision: String? = {
    guard let path = NSBundle.mainBundle().pathForResource("embedded", ofType: "mobileprovision"),
      data = NSData(contentsOfFile: path) else {
        return nil
    }
    let bytes = UnsafePointer<CChar>(data.bytes)
    var profile = ""
    for index in 0..<data.length {
      profile += String(format: "%c", bytes[index])
    }

    return profile.componentsSeparatedByCharactersInSet(.whitespaceAndNewlineCharacterSet())
      .joinWithSeparator("")

  }()

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