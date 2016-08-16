//
//  Localizable.swift
//  Localizable
//
//  Created by Ivan Bruel on 23/02/16.
//  Copyright © 2016 Localizable. All rights reserved.
//

import Foundation

// MARK: Instance Properties
public class Localizable: NSObject {

  private static let sharedInstance = Localizable()

  private var token: String?

  private var localizableLanguage: LocalizableLanguage =
    LocalizableLanguage(code: Localizable.currentLanguageCode)

  private var appLanguage: AppLanguage = AppLanguage(code: Localizable.currentLanguageCode)
}

// MARK: API
public extension Localizable {

  public class func setup() {
    Localizable.sharedInstance.setup()
  }

  public class func setup(token: String) {
    Localizable.sharedInstance.setup(token)
  }

  public class func updateLanguage(completion: (NSError? -> Void)? = nil) {
    Localizable.sharedInstance.updateLanguage(completion)
  }

  public class func setLanguageCode(code: String) {
    Localizable.sharedInstance.setLanguageCode(code)
  }

  public class func string(key: String, _ arguments: String...) -> String {
    return Localizable.sharedInstance.string(key, arguments.map { $0 as CVarArgType})
  }

}

// MARK: Setup
extension Localizable {

  func setup() {
    guard let token = AppHelper.localizableToken else {
      Logger.logError("Cannot initialize the SDK without a token, set 'LocalizableToken' on your "
        + "Info.plist file or call Localizable.setup(token: token)")
      return
    }
    setup(token)
  }

  func setup(token: String) {
    self.token = token
    if AppHelper.debugMode {
      AppLanguage.printMissingStrings()
      AppLanguage.upload(token)
    }
    updateLanguage()
  }
}

// MARK: Languages
extension Localizable {

  func updateLanguage(completion: ((NSError?) -> Void)? = nil) {
    guard let token = token else {
      Logger.logError("Cannot refresh without setting a token")
      return
    }
    localizableLanguage.update(token, completion: completion)
  }

  func setLanguageCode(code: String) {
    guard AppLanguage.availableLanguageCodes.contains(code) else {
      Logger.logError("Cannot set language to \(code) because it's not one of the available " +
        "languages: \(AppLanguage.availableLanguageCodes.joinWithSeparator(", "))")
      return
    }

    UserDefaultsHelper.currentLanguageCode = code
    appLanguage = AppLanguage(code: code)
    localizableLanguage = LocalizableLanguage(code: code)
  }
}

// MARK: Strings
extension Localizable {

  func string(key: String, _ arguments: String...) -> String {
    let arguments = arguments.map { $0 as CVarArgType }

    return string(key, arguments)
  }

  func string(key: String, _ arguments: [CVarArgType]) -> String {

    if localizableLanguage.containsStringForKey(key) {
      return localizableLanguage.stringForKey(key, arguments)
    }

    return appLanguage.stringForKey(key, arguments)
  }
}

// MARK: Accessors
private extension Localizable {

  private static let defaultLanguage = "en"

  private static var currentLanguageCode: String {
    guard let currentLanguageCode = UserDefaultsHelper.currentLanguageCode else {
      return defaultLanguageCode
    }
    return currentLanguageCode
  }

  private static var defaultLanguageCode: String {
    guard let preferredLanguageCode = NSBundle.mainBundle().preferredLocalizations.first
      where AppLanguage.availableLanguageCodes.contains(preferredLanguageCode) else {
        return defaultLanguage
    }
    return preferredLanguageCode
  }
}
