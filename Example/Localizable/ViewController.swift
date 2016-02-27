//
//  ViewController.swift
//  Localizable
//
//  Created by Ivan Bruel on 02/24/2016.
//  Copyright (c) 2016 Ivan Bruel. All rights reserved.
//

import UIKit
import Localizable

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    print(Localizable.stringForKey("Testing"))
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func clicked() {
    Localizable.update { () -> Void in
      print(Localizable.stringForKey("Testing"))
    }
  }

}

enum Localized {
  case Testing

  var string: String {
    switch self {
    case .Testing:
      return Localizable.stringForKey("Testing")
    }
  }
}
