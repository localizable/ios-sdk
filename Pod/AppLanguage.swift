//
//  AppLanguage.swift
//  Pods
//
//  Created by Ivan Bruel on 10/04/16.
//
//

import Foundation

final class AppLanguage: Language {

  private struct JSONKeys {
    static let code = "code"
    static let strings = "keywords"
  }

  private static let directory = "AppLanguage"
  private static let baseLanguageCode = "Base"

  let code: String
  let strings: [String: String]

  init(code: String, strings: [String: String]) {
    self.code = code
    self.strings = strings
  }

  convenience init(code: String) {
    self.init(code: code, strings: AppHelper.stringsForLanguageCode(code))
  }

  func save() {
    StorageHelper.saveObject(json, directory: AppLanguage.directory, filename: code)
  }

}

// MARK: Accessors
extension AppLanguage {

  static var availableLanguageCodes: [String] {
    return NSBundle.mainBundle().localizations
  }

  static var allLanguages: [AppLanguage] {
    return availableLanguageCodes.flatMap { AppLanguage(code: $0) }
  }

}

// MARK: Helpers
extension AppLanguage {

  static func printMissingStrings() {
    let allLanguages = AppLanguage.allLanguages
    let allKeys = Set(allLanguages.map { $0.strings.keys }.flatten())

    let missing = allLanguages.flatMap { language -> (AppLanguage, [String])? in
      let missingKeys = allKeys.filter { !language.strings.keys.contains($0) }
      guard missingKeys.count > 0 else {
        return nil
      }
      return (language, missingKeys)
    }

    guard missing.count > 0 else {
      return
    }

    Logger.logInfo("Missing strings:")
    missing.forEach { (language, keys) -> () in
      Logger.logInfo("Language: \(language.code)")
      let strings = keys.map { "  \"\($0)\""}.joinWithSeparator("\n")
      Logger.logInfo(strings)
    }
  }
}


// MARK: JSONRepresentable
extension AppLanguage: JSONRepresentable {

  convenience init?(json: [String: AnyObject]) {
    guard let code = json[JSONKeys.code] as? String,
      strings = json[JSONKeys.strings] as? [String: String] else {
        return nil
    }

    self.init(code: code, strings: strings)
  }

  var json: [String: AnyObject] {
    return [
      JSONKeys.code: code,
      JSONKeys.strings: strings
    ]
  }
}

// MARK: Delta
extension AppLanguage {

  private var oldLanguage: AppLanguage? {
    guard let json: [String: AnyObject]
      = StorageHelper.loadObject(AppLanguage.directory, filename: code) else {
        return nil
    }
    return AppLanguage(json: json)
  }

  var delta: AppLanguageDelta? {
    return AppLanguageDelta(newLanguage: self, oldLanguage: oldLanguage)
  }

  static var languageDeltas: [AppLanguageDelta]? {
    let languageDifferences = AppLanguage.allLanguages.flatMap { $0.delta }

    guard languageDifferences.count > 0 else {
      return nil
    }

    return languageDifferences
  }

  static func saveAppLanguages() {
    AppLanguage.allLanguages.forEach { $0.save() }
  }

}

// MARK: Networking
extension AppLanguage {

  static func upload(token: String) {
    guard let languageDeltas = languageDeltas else { return }

    Logger.logWarning("Detected string changes:")
    languageDeltas.forEach { Logger.logWarning($0.description) }

    Network.sharedInstance
      .performRequest(.UploadLanguages(languageDeltas: languageDeltas), token: token) {
        (_, error) -> Void in
        guard error == nil else {
          return
        }
        saveAppLanguages()
    }
  }
}
