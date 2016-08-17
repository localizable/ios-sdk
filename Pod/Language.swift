//
//  Language.swift
//  Pods
//
//  Created by Ivan Bruel on 10/04/16.
//
//

import Foundation

protocol Language {

  var code: String { get }
  var strings: [String: String] { get }

  subscript(key: String) -> String { get }

  func stringForKey(key: String) -> String
  func stringForKey(key: String, _ arguments: [CVarArgType]) -> String
  func containsStringForKey(key: String) -> Bool

}

extension Language {

  subscript(key: String) -> String {
    return stringForKey(key)
  }

  func stringForKey(key: String) -> String {
    return strings[key] ?? key
  }

  func stringForKey(key: String, _ arguments: [CVarArgType]) -> String {
    return String(format: stringForKey(key), arguments: arguments)
  }

  func containsStringForKey(key: String) -> Bool {
    return strings.keys.contains(key)
  }

}
