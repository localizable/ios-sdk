//
//  Array+Unique.swift
//  Pods
//
//  Created by Ivan Bruel on 12/09/16.
//
//

import Foundation

extension Array where Element: Equatable {

  /**
   Returns a copy of the array with only its unique elements.
   This will keep the first available copy and discard the rest.

   e.g. [A, B, A] -> [A, B]

   - returns: The array with only the unique elements.
   */
  func unique() -> [Element] {
    var uniqueValues: [Element] = []
    forEach { item in
      if !uniqueValues.contains(item) {
        uniqueValues += [item]
      }
    }
    return uniqueValues
  }
}
