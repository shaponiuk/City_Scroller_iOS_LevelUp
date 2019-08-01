//
//  InfiniteTwoSidedScrollView.swift
//  ScrollApp
//
//  Created by Szymon Haponiuk on 28/03/2018.
//  Copyright © 2018 Szymon Haponiuk. All rights reserved.
//

import UIKit

class InfiniteTwoSidedScrollView<T: UIView>: UIScrollView {
    
    // MARK: Properties
    
    let containerView = UIView()
    var specialView: UIView?
    var specialViewPosition: CGPoint?
  
    // MARK: Init
    
    required init(frame: CGRect, height: CGFloat) {
        super.init(frame: frame)
        
        isPagingEnabled = false
        
        selfSetup(height: height)
        
        containerViewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Methods
    
    private func selfSetup(height: CGFloat) {
        contentSize = CGSize(width: 9 * self.bounds.width, height: height)
        contentOffset.x = (contentSize.width - self.bounds.width) / 2.0
    }
    
    private func containerViewSetup() {
        containerView.frame = CGRect(origin: .zero, size: contentSize)
        addSubview(containerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateIfHorizontallyPanned()
        
        buildToTheLeft()
        buildToTheRight()
    }
    
    // Not usable
    // Returns a new view to be used by the class
    func newView() -> T {
        fatalError("used an abstract class - InfiniteTwoSidedScrollView")
    }
    
    // Centers the screen while panning
    // Calls movesAndDeleteViewsOfTypeT with the horizontal offset difference
    private func updateIfHorizontallyPanned() {
        let centerOffsetX = (contentSize.width - self.bounds.width) / 2.0
        let horizontalOffsetDifference = contentOffset.x - centerOffsetX
        
        if abs(horizontalOffsetDifference) > 50.0 {
            contentOffset.x = centerOffsetX
            moveAndDeleteViewsOfTypeT(horizontalOffsetDifference: horizontalOffsetDifference)
        }
          
        if let sv = specialView, let pos = specialViewPosition {
            sv.frame.origin.x = contentOffset.x + pos.x
        }
    }
    
    // Moves the views of type T to make an illusion of scrolling
    // Removes views of type T that fall out of the screen
    private func moveAndDeleteViewsOfTypeT(horizontalOffsetDifference: CGFloat) {
        for view in containerView.subviews {
            if view is T {
                view.frame = view.frame.offsetBy(dx: -horizontalOffsetDifference, dy: 0)
                if view.frame.origin.x > contentOffset.x + UIScreen.main.bounds.width ||
                    view.frame.origin.x + view.bounds.width < contentOffset.x {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    // Places buildings to the left that are visible to the user
    private func buildToTheLeft() {
        var furthestLeftPoint = contentOffset.x + UIScreen.main.bounds.width
        
        for view in containerView.subviews {
            if view is T {
                furthestLeftPoint = min(furthestLeftPoint, view.frame.origin.x)
            }
        }
        
        while furthestLeftPoint > contentOffset.x {
            let view = spawnNewViewHorizontally(onPosXRight: furthestLeftPoint)
            furthestLeftPoint -= view.bounds.width
        }
    }
    
    // Places buildings to the right that are visible for the user
    private func buildToTheRight() {
        var furthestRightPoint = contentOffset.x
        
        for view in containerView.subviews {
            if view is T {
                furthestRightPoint = max(furthestRightPoint, view.frame.origin.x + view.bounds.width)
            }
        }
        
        while furthestRightPoint < contentOffset.x + UIScreen.main.bounds.width {
            let view = spawnNewViewHorizontally(onPosXLeft: furthestRightPoint)
            furthestRightPoint += view.bounds.width
        }
    }
    
    // Fills the screen with buildings from left to right
    // Left corner of the view is the left corner of the leftmost building
    // Screen must be empty
    public func initiallySpawnViews() {
        var currentSpawningPos: CGFloat = contentOffset.x
        
        while currentSpawningPos <= contentOffset.x + UIScreen.main.bounds.width {
            let view = spawnNewViewHorizontally(onPosXLeft: currentSpawningPos)
            currentSpawningPos += view.bounds.width
        }
    }
    
    // Spawns a building with the left corner on a given coordinate
    private func spawnNewViewHorizontally(onPosXLeft pos: CGFloat) -> UIView {
        let view = newView()
        let origin = CGPoint(x: pos, y: contentSize.height - view.bounds.height)
        view.frame.origin = origin
        containerView.addSubview(view)
        return view
    }
    
    // Spawns a building with the right corner on a given coordinate
    private func spawnNewViewHorizontally(onPosXRight pos: CGFloat) -> UIView {
        let view = newView()
        let origin = CGPoint(x: pos - view.bounds.width, y: contentSize.height - view.bounds.height)
        view.frame.origin = origin
        containerView.addSubview(view)
        return view
    }
}
