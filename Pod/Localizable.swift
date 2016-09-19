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

  private struct JSONKeys {
    static let languages = "languages"
  }

  private static let languagesFileName = "languages"

  /// A private static instance of Localizable for easier testing and still providing easy
  /// integration.
  private static let sharedInstance = Localizable()

  /// The Localizable API Token
  private var token: String?

  /// The LocalizableLanguage object represents the Localizable SDK override of the default
  /// NSLocalizedString behavior for a given language
  private var localizableLanguage: LocalizableLanguage =
    LocalizableLanguage(code: Localizable.currentLanguageCode)

  /// The AppLanguage object represents the default NSLocalizedString behavior for a given language
  private var appLanguage: AppLanguage = AppLanguage(code: Localizable.currentLanguageCode)

  private var automaticSwitching: Bool = true

  private var languageCodes: [String] =
    StorageHelper.loadObject(filename: Localizable.languagesFileName) ?? [] {
    didSet {
      StorageHelper.saveObject(languageCodes, filename: Localizable.languagesFileName)
    }
  }
}

// MARK: API
public extension Localizable {

  /**
   This will setup the SDK with a LocalizableToken from the application's Info.plist file.
   It will also check if the App is in debug mode, in case it is, it will look for languages with
   missing strings and report it in the console. Will also upload language updates from editing
   .string files.
   */
  public class func setup(automaticSwitching: Bool = true) {
    Localizable.sharedInstance.setup(automaticSwitching)
  }

  /**
   This will setup the SDK with a given token.
   It will also check if the App is in debug mode, in case it is, it will look for languages with
   missing strings and report it in the console. Will also upload language updates from editing
   .string files.

   - parameter token: The Localizable API Token.
   */
  public class func setup(token: String, automaticSwitching: Bool = true) {
    Localizable.sharedInstance.setup(token, automaticSwitching: automaticSwitching)
  }

  /**
   Tries to update the language by performing a Network call to the Localizable API and look for
   updated strings.

   - parameter completion: Complition block called upon network request response.
   Receives an NSError in case something went wrong and nil otherwise.
   */
  public class func updateLanguage(completion: (NSError? -> Void)? = nil) {
    Localizable.sharedInstance.updateLanguage(Localizable.sharedInstance.localizableLanguage,
                                              completion: completion)
  }

  /**
   Allows changing of the current language by providing the appropriate language code.
   Will also try to download the most recent language changes.

   - parameter code: The language code in ISO format (http://bit.ly/2byDc6M)
   */
  public class func setLanguageCode(code: String) {
    Localizable.sharedInstance.setLanguageCode(code)
  }

  /**
   Returns the localizable string for a given key and formats it with the provided arguments.

   - parameter key:       The Localizable string token.
   - parameter arguments: The arguments separated by commas.

   - returns: The Localizable String in the current language.
   */
  public class func string(key: String, _ arguments: CVarArgType...) -> String {
    return Localizable.sharedInstance.string(key, arguments)
  }

}

// MARK: Setup
extension Localizable {

  /**
   This will setup the SDK with a LocalizableToken from the application's Info.plist file.
   It will also check if the App is in debug mode, in case it is, it will look for languages with
   missing strings and report it in the console. Will also upload language updates from editing
   .string files.
   */
  func setup(automaticSwitching: Bool = true) {
    guard let token = AppHelper.localizableToken else {
      Logger.logError("Cannot initialize the SDK without a token, set 'LocalizableToken' on your "
        + "Info.plist file or call Localizable.setup(token: token)")
      return
    }
    setup(token, automaticSwitching: automaticSwitching)
  }

  /**
   This will setup the SDK with a given token.
   It will also check if the App is in debug mode, in case it is, it will look for languages with
   missing strings and report it in the console. Will also upload language updates from editing
   .string files.

   - parameter token: The Localizable API Token.
   */
  func setup(token: String, automaticSwitching: Bool = true) {
    self.token = token
    if AppHelper.debugMode {
      AppLanguage.printMissingStrings()
      AppLanguage.upload(token)
    }
    loadLanguageCodes { [weak self] (languageCodes) in
      guard let `self` = self else { return }
      self.languageCodes = languageCodes ?? []
      if automaticSwitching && self.languageCodes.contains(AppLanguage.preferredLanguageCode) {
        self.setLanguageCode(AppLanguage.preferredLanguageCode)
      } else {
        self.updateLanguage(self.localizableLanguage)
      }
    }
  }
}

// MARK: Languages
extension Localizable {

  /**
   Tries to update the language by performing a Network call to the Localizable API and look for
   updated strings.

   - parameter completion: Complition block called upon network request response.
   Receives an NSError in case something went wrong and nil otherwise.
   */
  func updateLanguage(localizableLanguage: LocalizableLanguage,
                      completion: ((NSError?) -> Void)? = nil) {
    guard let token = token else {
      Logger.logError("Cannot refresh without setting a token")
      return
    }
    localizableLanguage.update(token, completion: completion)
  }

  func loadLanguageCodes(completion: ([String]? -> Void)? = nil) {
    guard let token = token else {
      Logger.logError("Cannot load langueage codes without setting a token")
      return
    }
    Network.sharedInstance
      .performRequest(.LanguageCodes, token: token) { [weak self] (json, error) in
        guard let `self` = self,
          languages = json?[JSONKeys.languages] as? [String] else {
            completion?(nil)
            return
        }
        completion?(languages)
    }
  }

  /**
   Allows changing of the current language by providing the appropriate language code.
   Will also try to download the most recent language changes.

   - parameter code: The language code in ISO format (http://bit.ly/2byDc6M)
   */
  func setLanguageCode(code: String) {
    let availableLanguages = (AppLanguage.availableLanguageCodes + languageCodes).unique()
    guard availableLanguages.contains(code) else {

      Logger.logError("Cannot set language to \(code) because it's not one of the available " +
        "languages: \(availableLanguages.joinWithSeparator(", "))")
      return
    }

    let localizableLanguage = LocalizableLanguage(code: code)
    updateLanguage(localizableLanguage) { [weak self] error in
      guard let `self` = self else { return }
      UserDefaultsHelper.currentLanguageCode = code
      self.appLanguage = AppLanguage(code: code)
      self.localizableLanguage = localizableLanguage
    }
  }
}

// MARK: Strings
extension Localizable {

  /**
   Returns the localizable string for a given key and formats it with the provided arguments.

   - parameter key:       The Localizable string token.
   - parameter arguments: The arguments separated by commas.

   - returns: The Localizable String in the current language.
   */
  func string(key: String, _ arguments: CVarArgType...) -> String {
    return string(key, arguments)
  }

  /**
   Returns the localizable string for a given key and formats it with the provided arguments.

   - parameter key:       The Localizable string token.
   - parameter arguments: The arguments in array form.

   - returns: The Localizable String in the current language.
   */
  func string(key: String, _ arguments: [CVarArgType]) -> String {

    if localizableLanguage.containsStringForKey(key) {
      return localizableLanguage.stringForKey(key, arguments)
    }

    return appLanguage.stringForKey(key, arguments)
  }
}

// MARK: Accessors
private extension Localizable {

  /// The default language in case no other language is found in the running App.
  private static let defaultLanguage = "en"

  /// Returns the current language code
  private static var currentLanguageCode: String {
    guard let currentLanguageCode = UserDefaultsHelper.currentLanguageCode else {
      return defaultLanguageCode
    }
    return currentLanguageCode
  }

  /// Returns the default language code for the running App
  /// This will look for the preferred localization first and default for english in case it is not
  /// found.
  private static var defaultLanguageCode: String {
    guard let preferredLanguageCode = NSBundle.mainBundle().preferredLocalizations.first
      where AppLanguage.availableLanguageCodes.contains(preferredLanguageCode) else {
        return defaultLanguage
    }
    return preferredLanguageCode
  }
}

// MARK: Development
extension Localizable {

  /**
   Setting the API URL will override the default API URL in order to test new API versions without
   the need to change the SDKs code or recompile it.

   - parameter apiURL: The API URL, e.g. "http://localizable.io/api/v1/"
   */
  static func setApiRUL(apiURL: String) {
    Network.sharedInstance.apiURL = apiURL
  }
}
