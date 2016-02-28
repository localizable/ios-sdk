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
    print(localized(.AtuaMaeDe4("wtf")))
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func clicked() {
    Localizable.update { () -> Void in
      print(localized(.Testing))
      print(localized(.AtuaMaeDe4("wtf")))
    }
  }

}