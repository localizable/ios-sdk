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
  private static var language: Language = Language.currentLanguage()

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
      Language.detectMissingStrings()
      Language.upload(token)
    }
  }

  public class func update(completion: (() -> Void)? = nil) {
    guard let token = token else {
      Logger.logError("Cannot refresh without setting a token")
      return
    }
    language.update(token) { _ in
      completion?()
    }
  }

  public class func setLanguageWithCode(code: String) {
    guard let language = Language.languageForCode(code) else {
      Logger.logError("Cannot set language to \(code) because it's not one of the available " +
        "languages: \(Language.availableLanguageCodes().joinWithSeparator(", "))")
      return
    }
    self.language = language
  }

  public class func stringForKey(key: String, _ arguments: String...) -> String {
    guard arguments.count > 0 else {
      return language.stringForKey(key)
    }
    return String(format: language.stringForKey(key),
      arguments: arguments.map { $0 as CVarArgType} )
  }
  
}
