//
//  Diff.swift
//  Pods
//
//  Created by Ivan Bruel on 27/02/16.
//
//

import Foundation

struct Diff: CustomStringConvertible {
  let code: String
  let update: [String: String]
  let remove: [String]

  init?(newLanguage: Language, oldLanguage: Language) {
    let update = newLanguage.localizedStrings.flatMap { (key, value) in
      oldLanguage.localizedStrings[key] == value ? nil : (key, value)
      }.reduce([String: String]()) { (var dict, pair) in
        dict[pair.0] = pair.1
        return dict
    }

    let remove = oldLanguage.localizedStrings.flatMap { (key, value) in
      newLanguage.localizedStrings[key] == nil ? key : nil
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
      "code": code,
      "update": update,
      "remove": remove
    ]
  }

  var description: String {
    return "\(code) updated: \(update) removed:\(remove)"
  }
}
