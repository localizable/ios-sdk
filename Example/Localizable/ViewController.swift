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
    print(localized(.Testing))
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func clicked() {
    Localizable.setLanguageWithCode("de")
    Localizable.update { () -> Void in
      print(localized(.Testing))
    }
  }

}