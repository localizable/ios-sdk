//
//  Network.swift
//  Localizable
//
//  Created by Ivan Bruel on 23/02/16.
//  Copyright © 2016 Localizable. All rights reserved.
//

import Foundation

class Network: NSObject {

  private static let defaultApiURL = "https://localizable-api.herokuapp.com/api/v1/"
  private static let timeout = 60.0
  private static let jsonHeader = "application/json"

  var mockData: Bool = false
  var apiURL = Network.defaultApiURL

  static var sharedInstance = Network()

  private let session = NSURLSession(configuration:
    NSURLSessionConfiguration.defaultSessionConfiguration())

  func performRequest(api: API, token: String,
    completion: (([String: AnyObject]?, NSError?) -> Void)? = nil) {
      let url = urlFromPath(api.path)
      performRequest(api.method, url: url, token: token, sampleData: api.sampleData, json: api.json,
        completion: completion)
  }
}

private extension Network {

  private func urlFromPath(path: String) -> String {
    return "\(apiURL)\(path)"
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
        Logger.logHttp("Invalid url \(url)")
        return
      }

      let request = NSMutableURLRequest(URL: requestURL, cachePolicy: .UseProtocolCachePolicy,
        timeoutInterval: Network.timeout)
      request.addValue(Network.jsonHeader, forHTTPHeaderField: "Content-Type")
      request.addValue(Network.jsonHeader, forHTTPHeaderField: "Accept")
      request.addValue(token, forHTTPHeaderField: "X-LOCALIZABLE-TOKEN")
      request.HTTPMethod = method.rawValue

      Logger.logHttp("\(method.rawValue) to \(url) with token \(token)")
      if let json = json where method != .GET {
        do {
          let jsonData = try NSJSONSerialization.dataWithJSONObject(json,
            options: .PrettyPrinted)
          request.HTTPBody = jsonData
          if let jsonString = String(data: jsonData, encoding: NSUTF8StringEncoding) {
            Logger.logHttp(jsonString)
          }
        } catch {
          Logger.logHttp("Could not serialize \(json.description) into JSON")
        }
      }

    if let sampleData = sampleData where self.mockData {
      completion?(sampleData, nil)
      return
    }

    let task = session.dataTaskWithRequest(request) { (data, response, error) in
      self.handleNetworkResponse(data, response: response, error: error, completion: completion)
    }
    task.resume()
  }

  private func handleNetworkResponse(data: NSData?, response: NSURLResponse?, error: NSError?,
                                     completion: (([String: AnyObject]?, NSError?) -> Void)?) {
    if let error = error {
      completion?(nil, error)
    } else if let data = data where data.length > 0 {
      let jsonString = String(data: data, encoding: NSUTF8StringEncoding)

      do {
        if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
          as? [String: AnyObject] {
          completion?(json, nil)
        } else {
          Logger.logHttp("Could not cast \(jsonString) into [String: AnyObject]")
          completion?([:], nil)
        }
      } catch {
        Logger.logHttp("Could not deserialize \(jsonString) into [String: AnyObject]")
        completion?([:], nil)
      }
    } else {
      completion?([:], nil)
    }
  }
}
