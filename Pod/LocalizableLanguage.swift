//
//  Language.swift
//  Localizable
//
//  Created by Ivan Bruel on 23/02/16.
//  Copyright © 2016 Localizable. All rights reserved.
//

import Foundation

// MARK: Properties and Initializer
final class LocalizableLanguage: Language {

  private struct JSONKeys {
    static let code = "code"
    static let modifiedAt = "modified_at"
    static let strings = "keywords"
  }

  private static let directory = "LocalizableLanguage"

  let code: String
  var modifiedAt: Int
  var strings: [String: String]

  init(code: String, modifiedAt: Int, strings: [String: String]) {
    self.code = code
    self.modifiedAt = modifiedAt
    self.strings = strings
  }

  convenience init(code: String) {
    guard let json: [String: AnyObject] =
      StorageHelper.loadObject(LocalizableLanguage.directory, filename: code) else {
        self.init(code: code, modifiedAt: 0, strings: [:])
        return
    }

    let code = json[JSONKeys.code] as? String ?? code
    let version = json[JSONKeys.modifiedAt] as? Int ?? 0
    let strings = json[JSONKeys.strings] as? [String: String] ?? [:]

    self.init(code: code, modifiedAt: version, strings: strings)
  }
}

// MARK: JSONRepresentable
extension LocalizableLanguage: JSONRepresentable {

  convenience init?(json: [String: AnyObject]) {
    guard let code = json[JSONKeys.code] as? String,
      modifiedAt = json[JSONKeys.modifiedAt] as? Int,
      strings = json[JSONKeys.strings] as? [String: String] else {
        return nil
    }

    self.init(code: code, modifiedAt: modifiedAt, strings: strings)
  }

  var json: [String: AnyObject] {
    return [
      JSONKeys.code: code,
      JSONKeys.modifiedAt: modifiedAt,
      JSONKeys.strings: strings
    ]
  }

}

// MARK: Storage
extension LocalizableLanguage {

  private func save() {
    StorageHelper.saveObject(json, directory: LocalizableLanguage.directory, filename: code)
  }

}

// MARK: Networking
extension LocalizableLanguage {

  func update(token: String, completion: ((NSError?) -> Void)?) {
    Network.sharedInstance
      .performRequest(.UpdateLanguage(language: self), token: token) { [weak self] (json, error) in

      guard let `self` = self,
        code = json?[JSONKeys.code] as? String,
        modifiedAt = json?[JSONKeys.modifiedAt] as? String,
        strings = json?[JSONKeys.strings] as? [String: String]
        where code == self.code else {
          completion?(error)
          return
      }

      self.modifiedAt = Int(modifiedAt) ?? 0
      self.strings += strings
      self.save()
      completion?(error)
    }
  }
}
