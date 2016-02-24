//
//  NetworkAPI.swift
//  Localizable
//
//  Created by Ivan Bruel on 23/02/16.
//  Copyright © 2016 Localizable. All rights reserved.
//

import Foundation

enum API {

  case Language(code: String)
  case Usage(code: String)

  var method: Method {
    switch self {
    case .Language:
      return .GET
    case .Usage:
      return .POST
    }
  }

  var path: String {
    switch self {
    case .Language(let code):
      return "languages/\(code)"
    case .Usage(let code):
      return "usage/\(code)"
    }
  }

  var json: [String: AnyObject]? {
    switch self {
    case .Language:
      return nil
    case .Usage:
      return nil
    }
  }

  var sampleData: [String: AnyObject]? {
    switch self {
    case .Language:
      return ["code": "en",
      "localized_strings": [
        "Testing": "Ay ay ay caramba \(NSDate().description)"
        ]
      ]
    case .Usage:
      return [:]
    }
  }

}
