//
//  ViewController.swift
//  TestPQSlider
//
//  Created by 盘国权 on 2019/11/5.
//  Copyright © 2019 pgq. All rights reserved.
//

import UIKit
import PQSlider

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let slider = PQSlider(frame: CGRect(x: 20, y: 200, width: 300, height: 30))
        slider.colors = [UIColor.red, UIColor.black]
        slider.locations  = [0.0, 1.0]
        slider.borderColor = .green
        slider.borderWidth = 2
        slider.colorHeight = 30
        slider.listen { progress in
            print(CFAbsoluteTimeGetCurrent(), progress)
        }
        view.addSubview(slider)
//        slider.reloadUI()
    }


}

