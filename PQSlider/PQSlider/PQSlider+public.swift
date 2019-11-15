//
//  PQSlider+public.swift
//  PQSlider
//
//  Created by 盘国权 on 2019/11/15.
//  Copyright © 2019 pgq. All rights reserved.
//

import UIKit

extension PQSlider {
    convenience init(frame: CGRect, colors: [UIColor], locations: [CGFloat]) {
        self.init(frame: frame)
        self.colors = colors
        self.locations = locations
    }
}
