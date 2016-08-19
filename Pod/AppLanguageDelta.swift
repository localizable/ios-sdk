//
//  AppLanguageDelta.swift
//  Pods
//
//  Created by Ivan Bruel on 27/02/16.
//
//

import Foundation

struct AppLanguageDelta: JSONConvertible, CustomStringConvertible {

  private struct JSONKeys {
    static let code = "code"
    static let update = "update"
    static let remove = "remove"
  }

  let code: String
  let update: [String: String]
  let remove: [String]

  init?(newLanguage: AppLanguage, oldLanguage: AppLanguage?) {

    let oldLanguageStrings = oldLanguage?.strings ?? [:]

    let update = newLanguage.strings.flatMap { (key, value) in
      oldLanguageStrings[key] == value ? nil : (key, value)
      }.reduce([String: String]()) { (dict, pair) in
        var dict = dict
        dict[pair.0] = pair.1
        return dict
    }

    let remove = oldLanguageStrings.flatMap { (key, value) in
      newLanguage.strings[key] == nil ? key : nil
    }

    self.init(code: newLanguage.code, update: update, remove: remove)
  }

  init?(code: String, update: [String: String], remove: [String]) {
    guard update.count > 0 || remove.count > 0 else {
      return nil
    }
    self.code = code
    self.update = update
    self.remove = remove
  }

  var json: [String: AnyObject] {
    return [
      JSONKeys.code: code,
      JSONKeys.update: update,
      JSONKeys.remove: remove
    ]
  }

  var description: String {
    var buffer = [String]()
    buffer.append("Language: \(code)")
    if update.count > 0 {
      buffer.append("  Updated:")
      buffer += update.map { "    \"\($0.0)\" = \"\($0.1)\"" }
    }
    if remove.count > 0 {
      buffer.append("  Removed:")
      buffer += remove.map { "    \"\($0)\""}
    }
    return buffer.joinWithSeparator("\n")
  }
}
