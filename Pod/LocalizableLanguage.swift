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

  private static let directory = "LocalizableLanguage"

  let code: String
  var version: Int
  var strings: [String: String]

  init(code: String, version: Int, strings: [String: String]) {
    self.code = code
    self.version = version
    self.strings = strings
  }

  convenience init(code: String) {
    guard let json: [String: AnyObject] =
      StorageHelper.loadObject(LocalizableLanguage.directory, filename: code) else {
        self.init(code: code, version: 0, strings: [:])
        return
    }

    let code = json["code"] as? String ?? code
    let version = json["version"] as? Int ?? 0
    let strings = json["strings"] as? [String: String] ?? [:]

    self.init(code: code, version: version, strings: strings)
  }
}

// MARK: JSONRepresentable
extension LocalizableLanguage: JSONRepresentable {

  convenience init?(json: [String: AnyObject]) {
    guard let code = json["code"] as? String,
      version = json["version"] as? Int,
      strings = json["strings"] as? [String: String] else {
        return nil
    }

    self.init(code: code, version: version, strings: strings)
  }

  var json: [String: AnyObject] {
    return [
      "code": code,
      "version": version,
      "strings": strings
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
    Network.sharedInstance.performRequest(.UpdateLanguage(language: self), token: token) {
      (json, error) in

      guard let strings = json?["strings"] as? [String: String],
        version = json?["version"] as? Int,
        code = json?["code"] as? String where code == self.code else {
          completion?(error)
          return
      }

      self.version = version
      self.strings = strings
      self.save()
      completion?(error)
    }
  }
  
}
