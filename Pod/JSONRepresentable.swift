//
//  JSONRepresentable.swift
//  Pods
//
//  Created by Ivan Bruel on 10/04/16.
//
//

import Foundation

protocol JSONRepresentable: JSONConvertible {

  init?(json: [String: AnyObject])

}
