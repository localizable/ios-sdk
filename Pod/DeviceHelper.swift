//
//  DeviceHelper.swift
//  Pods
//
//  Created by Ivan Bruel on 02/03/16.
//
//

import Foundation

class DeviceHelper {

  class var isSimulator: Bool {
    return UIDevice.currentDevice().name.containsString("Simulator")
  }

}
