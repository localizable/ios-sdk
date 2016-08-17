//
//  NetworkAPI.swift
//  Localizable
//
//  Created by Ivan Bruel on 23/02/16.
//  Copyright © 2016 Localizable. All rights reserved.
//

import Foundation

enum API {

  case UpdateLanguage(language: LocalizableLanguage)
  case UploadLanguages(languageDeltas: [AppLanguageDelta])
  case Usage(code: String)

  var method: Method {
    switch self {
    case .UpdateLanguage:
      return .GET
    case .Usage, .UploadLanguages:
      return .POST
    }
  }

  var path: String {
    switch self {
    case .UpdateLanguage(let language):
      return "languages/\(language.code)"
    case .Usage(let code):
      return "usage/\(code)"
    case .UploadLanguages:
      return "languages"
    }
  }

  var json: [String: AnyObject]? {
    switch self {
    case .UpdateLanguage(let language):
      return ["modified_at": language.modifiedAt]
    case .Usage:
      return nil
    case .UploadLanguages(let diff):
      return [
        "languages": diff.map { $0.json },
        "app": AppHelper.json,
        "platform": "ios"]
    }
  }

  var sampleData: [String: AnyObject]? {
    switch self {
    case .UpdateLanguage(let language):
      return [
        "code": language.code,
        "modified_at": language.modifiedAt + 1,
        "localized_strings": [
          "Testing": "Ay ay ay caramba \(language.modifiedAt)"
        ]
      ]
    case .Usage, .UploadLanguages:
      return nil
    }
  }

}
