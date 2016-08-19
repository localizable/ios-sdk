//
//  Dictionary+Update.swift
//  Pods
//
//  Created by Ivan Bruel on 16/08/16.
//
//

import Foundation

func += <K, V> (inout left: [K: V], right: [K: V]) {
  for (k, v) in right {
    left.updateValue(v, forKey: k)
  }
}

func + <K, V> (left: [K: V], right: [K: V]) -> [K: V] {
  var result = [K: V]()
  for (k, v) in left {
    result.updateValue(v, forKey: k)
  }
  for (k, v) in right {
    result.updateValue(v, forKey: k)
  }
  return result
}

extension Dictionary {

  func filter(isIncluded: (key: Key, value: Value) throws -> Bool) rethrows -> [Key: Value] {
    var d: [Key: Value] = [:]
    for (key, value) in self where try isIncluded(key: key, value: value) {
      d[key] = value
    }
    return d
  }
}
