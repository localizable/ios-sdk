//
//  Diff.swift
//  Pods
//
//  Created by Ivan Bruel on 27/02/16.
//
//

import Foundation

struct AppLanguageDelta: JSONConvertible {
  
  let code: String
  let updated: [String: String]
  let removed: [String]

  init?(newLanguage: AppLanguage, oldLanguage: AppLanguage?) {

    guard let oldLanguage = oldLanguage else {
      return nil
    }

    let updated = newLanguage.strings.flatMap { (key, value) in
      oldLanguage.strings[key] == value ? nil : (key, value)
      }.reduce([String: String]()) { (var dict, pair) in
        dict[pair.0] = pair.1
        return dict
    }

    let removed = oldLanguage.strings.flatMap { (key, value) in
      newLanguage.strings[key] == nil ? key : nil
    }

    self.init(code: newLanguage.code, updated: updated, removed: removed)
  }

  init?(code: String, updated: [String: String], removed: [String]) {
    guard updated.count > 0 || removed.count > 0 else {
      return nil
    }
    self.code = code
    self.updated = updated
    self.removed = removed
  }

  var json: [String: AnyObject] {
    return [
      "code": code,
      "updated": updated,
      "removed": removed
    ]
  }
}
