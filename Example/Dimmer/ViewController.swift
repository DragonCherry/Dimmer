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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spaceView.setGradient(.fromTop, start: 0, end: 1, color: .blue)
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

