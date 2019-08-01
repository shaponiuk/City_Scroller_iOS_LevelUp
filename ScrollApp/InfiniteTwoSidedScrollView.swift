//
//  InfiniteScrollView.swift
//  ScrollApp
//
//  Created by Szymon Haponiuk on 28/03/2018.
//  Copyright © 2018 Szymon Haponiuk. All rights reserved.
//

import UIKit

class InfiniteTwoSidedScrollView: UIScrollView {
    
    private let containerView = UIView()
    
    init(frame: CGRect, height: CGFloat) {
        super.init(frame: frame)
        
        selfSetup(height: height)
        
        containerViewSetup()
    }
    
    private func selfSetup(height: CGFloat) {
        contentSize = CGSize(width: 9 * self.bounds.width, height: height)
        contentOffset.x = (contentSize.width - self.bounds.width) / 2.0
    }
    
    private func containerViewSetup() {
        containerView.frame = CGRect(origin: .zero, size: contentSize)
        containerView.backgroundColor = UIColor.randomBrightColor()
        addSubview(containerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateIfHorizontallyPanned()
    }
    
    private func updateIfHorizontallyPanned() {
        let centerOffsetX = (contentSize.width - self.bounds.width) / 2.0
        let horizontalOffsetDifference = contentOffset.x - centerOffsetX
        
        if horizontalOffsetDifference != 0.0 {
            // Shift views
            for view in containerView.subviews {
                view.frame = view.frame.offsetBy(dx: horizontalOffsetDifference, dy: 0)
            }
            containerView.frame = containerView.frame.offsetBy(dx: -horizontalOffsetDifference, dy: 0)
            contentOffset.x = centerOffsetX
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
