//
//  ViewController.swift
//  Dimmer
//
//  Created by DragonCherry on 05/12/2017.
//  Copyright (c) 2017 DragonCherry. All rights reserved.
//

import UIKit
import Dimmer

class ViewController: UIViewController {

    @IBOutlet weak var spaceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressedDim(_ sender: Any) {
        if !spaceView.isDimming {
            spaceView.dim()
        } else {
            spaceView.undim()
        }
    }
    @IBAction func pressedDimWithLoading(_ sender: Any) {
        if !spaceView.isLoading {
            spaceView.showLoading(style: .whiteLarge)
        } else {
            spaceView.hideLoading()
        }
    }
}

