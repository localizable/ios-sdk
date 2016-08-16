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