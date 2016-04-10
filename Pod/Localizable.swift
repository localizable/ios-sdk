//
//  Localizable.swift
//  Localizable
//
//  Created by Ivan Bruel on 23/02/16.
//  Copyright © 2016 Localizable. All rights reserved.
//

import Foundation

public class Localizable: NSObject {

  private static var token: String?

  private static var localizableLanguage: LocalizableLanguage = {
    return LocalizableLanguage(code: Localizable.currentLanguageCode)
  }()

  private static var appLanguage: AppLanguage = {
    return AppLanguage(code: Localizable.currentLanguageCode)
  }()

  public class func setup() {
    guard let token = AppHelper.localizableToken else {
      Logger.logError("Cannot initialize the SDK without a token, set 'LocalizableToken' on your "
        + "Info.plist file or call Localizable.setup(token: token)")
      return
    }
    setup(token: token)
  }

  public class func setup(token token: String) {
    self.token = token
    update()
    if AppHelper.debugMode {
      AppLanguage.printMissingStrings()
      AppLanguage.upload(token)
    }
  }

  public class func update(completion: (() -> Void)? = nil) {
    guard let token = token else {
      Logger.logError("Cannot refresh without setting a token")
      return
    }
    localizableLanguage.update(token) { _ in
      completion?()
    }
  }

  public class func setLanguageWithCode(code: String) {
    guard AppLanguage.availableLanguageCodes.contains(code) else {
        Logger.logError("Cannot set language to \(code) because it's not one of the available " +
          "languages: \(AppLanguage.availableLanguageCodes.joinWithSeparator(", "))")
        return
    }

    UserDefaultsHelper.currentLanguageCode = code
    self.appLanguage = AppLanguage(code: code)
    self.localizableLanguage = LocalizableLanguage(code: code)
  }

  public class func stringForKey(key: String, _ arguments: String...) -> String {
    let arguments = arguments.map { $0 as CVarArgType }

    if localizableLanguage.containsStringForKey(key) {
      return localizableLanguage.stringForKey(key, arguments)
    }

    return appLanguage.stringForKey(key, arguments)
  }

}

// MARK: Accessors
extension Localizable {

  private static let defaultLanguage = "en"

  static var currentLanguageCode: String {
    guard let currentLanguageCode = UserDefaultsHelper.currentLanguageCode else {
      return defaultLanguageCode
    }
    return currentLanguageCode
  }

  static var defaultLanguageCode: String {
    guard let preferredLanguageCode = NSBundle.mainBundle().preferredLocalizations.first
      where AppLanguage.availableLanguageCodes.contains(preferredLanguageCode) else {
        return defaultLanguage
    }
    return preferredLanguageCode
  }
  
}
