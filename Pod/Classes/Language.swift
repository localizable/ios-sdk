//
//  Language.swift
//  Localizable
//
//  Created by Ivan Bruel on 23/02/16.
//  Copyright © 2016 Localizable. All rights reserved.
//

import Foundation

// MARK: Properties and Initializer
class Language: NSObject {

  private static let baseBundle = "Base"
  private static let defaultLanguage = "en"

  let code: String
  var localizedStrings: [String: String]

  init(code: String, localizedStrings: [String: String]) {
    self.code = code
    self.localizedStrings = localizedStrings
  }

  func stringForKey(key: String) -> String {
    return localizedStrings[key] ?? fallbackStringForKey(key) ?? key
  }

  private func fallbackStringForKey(key: String) -> String? {
    if let path = NSBundle.mainBundle().pathForResource(code, ofType: "lproj"),
      bundle = NSBundle(path: path) {
        return bundle.localizedStringForKey(key, value: nil, table: nil)
    }
    else if let path = NSBundle.mainBundle().pathForResource(Language.baseBundle, ofType: "lproj"),
      bundle = NSBundle(path: path) {
        return bundle.localizedStringForKey(key, value: nil, table: nil)
    }

    return nil
  }
}

// MARK: Storage
extension Language {

  func save() {
    StorageHelper.saveObject(["code": self.code, "localized_strings": localizedStrings], filename: code)
  }

  private class func loadLanguageFromDisk(code: String) -> Language {
    guard let json: [String: AnyObject] = StorageHelper.loadObject(code) else {
      return Language(code: code, localizedStrings: [:])
    }
    return Language(json: json) ?? Language(code: code, localizedStrings: [:])
  }

}

// MARK: Defaults
extension Language {

  class func currentLanguage() -> Language {
    return loadLanguageFromDisk(defaultLanguageCode())
  }

  private class func availableLanguageCodes() -> [String] {
    return NSBundle.mainBundle().localizations
  }

  private class func defaultLanguageCode() -> String {
    guard let preferredLanguage = NSBundle.mainBundle().preferredLocalizations.first else {
      return Language.defaultLanguage
    }

    if availableLanguageCodes().contains(preferredLanguage) {
      return preferredLanguage
    }

    return Language.defaultLanguage
  }

}

// MARK: Networking
extension Language {

  convenience init?(json: [String: AnyObject]) {

    guard let code = json["code"] as? String else {
      return nil
    }

    let localizedStrings = json["localized_strings"] as? [String: String] ?? [:]

    self.init(code: code, localizedStrings: localizedStrings)
  }

  func refresh(token: String, completion: ((NSError?) -> Void)?) {
    Network.sharedInstance.performRequest(.Language(code: code), token: token) { (json, error) in
      guard let localizedStrings = json?["localized_strings"] as? [String: String] else {
        completion?(error)
        return
      }
      self.localizedStrings = localizedStrings
      self.save()
      completion?(error)
    }
  }

}
