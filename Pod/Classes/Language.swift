//
//  Language.swift
//  Localizable
//
//  Created by Ivan Bruel on 23/02/16.
//  Copyright © 2016 Localizable. All rights reserved.
//

import Foundation

// MARK: Properties and Initializer
class Language {

  private static let baseLanguage = "Base"
  private static let defaultLanguage = "en"

  let code: String
  var version: Int
  var localizedStrings: [String: String]

  init(code: String, version: Int, localizedStrings: [String: String]) {
    self.code = code
    self.version = version
    self.localizedStrings = localizedStrings
  }
}

// MARK: Strings
extension Language {

  func stringForKey(key: String) -> String {
    return localizedStrings[key] ?? fallbackStringForKey(key) ?? key
  }

  subscript(key: String) -> String {
    get {
      return stringForKey(key)
    }
  }

  private func fallbackStringForKey(key: String) -> String? {
    return AppHelper.stringForKey(key, languageCode: code) ??
      AppHelper.stringForKey(key, languageCode: Language.baseLanguage)
  }

}

// MARK: Storage
private extension Language {

  private func save(fromApp: Bool = false) {
    let name = fromApp ? "app_\(code)" : code
    StorageHelper.saveObject(json, filename: name)
  }

  private class func loadLanguageFromDisk(code: String, fromApp: Bool = false) -> Language {
    let name = fromApp ? "app_\(code)" : code
    guard let json: [String: AnyObject] = StorageHelper.loadObject(name) else {
      return Language(code: code, version: 0, localizedStrings: [:])
    }
    return Language(json: json) ?? Language(code: code, version: 0, localizedStrings: [:])
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

    guard availableLanguageCodes().contains(preferredLanguage) else {
      return Language.defaultLanguage
    }

    return preferredLanguage
  }

}

// MARK: App
extension Language {

  private class func languageDiff() -> [String: AnyObject]? {
    let appLanguages = Language.appLanguages()
    let oldAppLanguages = Language.oldAppLanguages()

    // pair up same languages
    let languageDifferences = appLanguages.flatMap { language -> (Language, Language)? in
      guard let olderLanguage =
        oldAppLanguages.filter({ _ in language.code == language.code }).first else {
          return nil
      }
      return (language, olderLanguage)
      }.flatMap { $0.0.diff($0.1) }

    let newLanguages = appLanguages.filter { language in
      oldAppLanguages.filter { $0.code == language.code }.count == 0
    }

    guard languageDifferences.count > 0 || newLanguages.count > 0 else {
      return nil
    }

    var languages: [[String: AnyObject]] = newLanguages.map {
      ["code": $0.code, "update": $0.localizedStrings]
    }
    languages += languageDifferences.map { $0.json }

    return ["languages": languages]
  }

  private class func saveAppLanguages() {
    appLanguages().forEach { $0.save(true) }
  }

  private class func appLanguages() -> [Language] {
    return availableLanguageCodes()
      .map {
        Language(code: $0, version: 0, localizedStrings: AppHelper.stringsForLanguageCode($0))
    }
  }

  private class func oldAppLanguages() -> [Language] {
    return availableLanguageCodes().map { loadLanguageFromDisk($0, fromApp: true) }
  }

}

// MARK: Comparing
extension Language {

  private func diff(olderLanguage: Language) -> Diff? {
    guard code == olderLanguage.code else {
      return nil
    }

    let update = localizedStrings.flatMap { (key, value) in
      olderLanguage[key] == value ? nil : (key, value)
      }.reduce([String: String]()) { (var dict, pair) in
        dict[pair.0] = pair.1
        return dict
    }

    let remove = olderLanguage.localizedStrings.flatMap { (key, value) in
      self.localizedStrings[key] == nil ? key : nil
    }

    return Diff(code: code, update: update, remove: remove)
  }

}

// MARK: Networking
extension Language {

  convenience init?(json: [String: AnyObject]) {
    guard let code = json["code"] as? String, version = json["version"] as? Int else {
      return nil
    }

    let localizedStrings = json["localized_strings"] as? [String: String] ?? [:]

    self.init(code: code, version: version, localizedStrings: localizedStrings)
  }

  var json: [String: AnyObject] {
    return [
      "code": code,
      "version": version,
      "localized_strings": localizedStrings
    ]
  }

  func update(token: String, completion: ((NSError?) -> Void)?) {
    Network.sharedInstance.performRequest(.UpdateLanguage(language: self), token: token) {
      (json, error) in

      guard let localizedStrings = json?["localized_strings"] as? [String: String],
        version = json?["version"] as? Int, code = json?["code"] as? String
        where code == self.code else {
          completion?(error)
          return
      }

      self.version = version
      self.localizedStrings = localizedStrings
      self.save()
      completion?(error)
    }
  }

  class func upload(token: String) {
    guard let diff = languageDiff() else {
      return
    }
    saveAppLanguages()
    Network.sharedInstance.performRequest(.UploadLanguages(diff: diff), token: token) {
      (_, error) -> Void in

    }
  }
  
}
