//
//  Network.swift
//  Localizable
//
//  Created by Ivan Bruel on 23/02/16.
//  Copyright © 2016 Localizable. All rights reserved.
//

import Foundation

class Network: NSObject {

  private static let baseURL = "http://localhost:8080/api/v1/"
  private static let timeout = 60.0
  private static let jsonHeader = "application/json"

  static var sharedInstance = Network()

  private let session = NSURLSession(configuration:
    NSURLSessionConfiguration.defaultSessionConfiguration())

  func performRequest(api: API, token: String,
    completion: (([String: AnyObject]?, NSError?) -> Void)? = nil) {
      let url = Network.urlFromPath(api.path)
      performRequest(api.method, url: url, token: token, sampleData: api.sampleData, json: api.json,
        completion: completion)
  }

}

private extension Network {

  private class func urlFromPath(path: String) -> String {
    return "\(baseURL)\(path)"
  }

  private func performRequest(method: Method = .GET, url: String, token: String,
    sampleData: [String: AnyObject]?, json: [String: AnyObject]? = nil,
    completion: (([String: AnyObject]?, NSError?) -> Void)? = nil) {

      var url = url

      if let json = json where method == .GET {
        let queryString = json.map { "\($0.0)=\($0.1.description)"}.joinWithSeparator("&")
        if queryString.characters.count > 0 {
          url = "\(url)?\(queryString)"
        }
      }

      guard let requestURL = NSURL(string: url) else {
        Logger.logError("Invalid url \(url)")
        return
      }

      let request = NSMutableURLRequest(URL: requestURL, cachePolicy: .UseProtocolCachePolicy,
        timeoutInterval: Network.timeout)
      request.addValue(Network.jsonHeader, forHTTPHeaderField: "Content-Type")
      request.addValue(Network.jsonHeader, forHTTPHeaderField: "Accept")
      request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
      request.HTTPMethod = method.rawValue

      if let json = json where method != .GET {
        do {
          request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
        } catch {
          Logger.logError("Could not serialize \(json.description) into JSON")
        }
      }

      Logger.logHttp("\(method.rawValue) to \(url) with token \(token)")
      let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
        if let sampleData = sampleData {
          completion?(sampleData, nil)
          return
        }

        if let error = error {
          completion?(nil, error)
        } else if let data = data {
          let jsonString = String(data: data, encoding: NSUTF8StringEncoding)

          do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
              as? [String: AnyObject] {
                completion?(json, nil)
            } else {
              Logger.logError("Could not cast \(jsonString) into [String: AnyObject]")
              completion?([:], nil)
            }
          } catch {
            Logger.logError("Could not deserialize \(jsonString) into [String: AnyObject]")
            completion?([:], nil)
          }
        }
      }

      task.resume()
  }

}
