//
//  JSONRepresentable.swift
//  Pods
//
//  Created by Ivan Bruel on 10/04/16.
//
//

import Foundation

protocol JSONFailableRepresentable: JSONConvertible {

  init?(json: [String: AnyObject])

}
