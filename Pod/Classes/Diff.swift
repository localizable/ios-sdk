//
//  Diff.swift
//  Pods
//
//  Created by Ivan Bruel on 27/02/16.
//
//

import Foundation

struct Diff {
  let code: String
  let update: [String: String]
  let remove: [String]

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
}
