//
//  ViewController.swift
//  TeamworkDemo
//
//  Created by Dave Hannan on 08/10/2017.
//  Copyright © 2017 Gro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.hexToUIColor(hex: "#26282f")
        navigationController?.navigationBar.isTranslucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

