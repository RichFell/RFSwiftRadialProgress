//
//  ViewController.swift
//  RFSwiftRadialProgress
//
//  Created by Rich Fellure on 5/18/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var demoProgress: RFProgressView!

    var count = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "draw", userInfo: nil, repeats: true)
    }

    func draw() {

        if count <= 10 {
            demoProgress.changeProgressByNominator(CGFloat(count++), byDenominator: 10.0, andWithAnimationDuration: 0.5)
        }
        else {
            demoProgress.changeProgressByNominator(0, byDenominator: 10.0, andWithAnimationDuration: 0.0)
            count = 0
        }
    }
}
