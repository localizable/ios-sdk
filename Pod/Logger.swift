//
//  Logger.swift
//  Localizable
//
//  Created by Ivan Bruel on 23/02/16.
//  Copyright © 2016 Localizable. All rights reserved.
//

import Foundation

class Logger: NSObject {

  private static let tag = "Localizable"

  static var logLevel = LogLevel.Info

  class func logHttp(message: String) {
    log(message, logLevel: .Http)
  }

  class func logError(message: String) {
    log(message, logLevel: .Error)
  }

  class func logWarning(message: String) {
    log(message, logLevel: .Warning)
  }

  class func logInfo(message: String) {
    log(message, logLevel: .Info)
  }

}

private extension Logger {

  private class func log(message: String, logLevel: LogLevel) {
    if logLevel.rawValue <= Logger.logLevel.rawValue {
      let messages = message.componentsSeparatedByString("\n")
      messages.forEach {
        print("[\(tag)][\(logLevel.name)]: \($0)")
      }
    }
  }
}
