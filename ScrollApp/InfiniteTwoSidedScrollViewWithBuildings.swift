

//
//  InfiniteTwoSidedScrollViewWithBuildings.swift
//  ScrollApp
//
//  Created by Szymon Haponiuk on 30/03/2018.
//  Copyright © 2018 Szymon Haponiuk. All rights reserved.
//

import UIKit

class InfiniteTwoSidedFullscreenScrollViewWithBuildings: InfiniteTwoSidedScrollView<BuildingView> {
    required init() {
        // The view needs to fit the screen
        let size = CGSize(width: UIScreen.main.bounds.width,
                          height: UIScreen.main.bounds.height)
        let frame = CGRect(origin: .zero, size: size)
        super.init(frame: frame, height: BuildingView.maxBuildingHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(frame: CGRect, height: CGFloat) {
        super.init(frame: frame, height: height)
    }
    
    override func newView() -> BuildingView {
        return BuildingView.randomBuilding()
    }
}
