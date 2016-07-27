//
//  main.swift
//  Localizable
//
//  Created by Ivan Bruel on 07/03/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/// This will make sure only the right delegate is compiled when the app runs or the tests run.
let isRunningTests = NSClassFromString("XCTestCase") != nil

if isRunningTests {
  UIApplicationMain(Process.argc, Process.unsafeArgv, nil, "Localizable_Example.TestingAppDelegate")
} else {
  UIApplicationMain(Process.argc, Process.unsafeArgv, nil, "Localizable_Example.AppDelegate")
}
