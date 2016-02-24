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
    guard let token = AppHelper.localizableToken() else {
      Logger.logError("Cannot initialize the SDK without a token, set 'LocalizableToken' on your "
        + "Info.plist file or call Localizable.setup(token: token)")
      return
    }
    setup(token: token)
  }

  public class func setup(token token: String) {
    self.token = token
  }

  public class func refresh(completion: (() -> Void)? = nil) {
    guard let token = token else {
      Logger.logError("Cannot refresh without setting a token")
      return
    }
    language.refresh(token) { _ in
      completion?()
    }
  }

  public class func stringForKey(key: String) -> String {
    return language.stringForKey(key)
  }

}
