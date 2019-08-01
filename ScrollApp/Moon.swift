//
//  Moon.swift
//  ScrollApp
//
//  Created by Szymon Haponiuk on 28/03/2018.
//  Copyright © 2018 Szymon Haponiuk. All rights reserved.
//

import UIKit

class Moon: UIView {
    
    init(radius: CGFloat, center: CGPoint) {
    
        let origin = CGPoint(x: center.x - radius, y: center.y - radius)
        let size = CGSize(width: radius * 2.0, height: radius * 2.0)
        super.init(frame: CGRect(origin: origin, size: size))
        self.layer.cornerRadius = radius
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
