//
//  DeviceHelper.swift
//  Pods
//
//  Created by Ivan Bruel on 02/03/16.
//
//

import Foundation

#if os(watchOS)
  import WatchKit
#endif

class DeviceHelper {

  class var isSimulator: Bool {
    #if (os(iOS) || os(tvOS))
      return UIDevice.currentDevice().name.containsString("Simulator")
    #elseif os(watchOS)
      return WKInterfaceDevice.currentDevice().model.containsString("Simulator")
    #else
      return false
    #endif
  }
}
