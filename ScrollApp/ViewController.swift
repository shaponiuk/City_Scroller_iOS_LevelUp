//
//  ViewController.swift
//  ScrollApp
//
//  Created by Szymon Haponiuk on 28/03/2018.
//  Copyright © 2018 Szymon Haponiuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
  var scrollView: InfiniteTwoSidedFullscreenScrollViewWithBuildings!
    
    var moon: UIView?
    
    var locationInMoonCenter: CGPoint?
    var moonPositionInView: CGPoint?
    
    // MARK: Methods
    
    private func makeAndPrepareMoon() {
        let initialLocationInViewCoordinates = CGPoint(x: scrollView.contentOffset.x + 100.0,
                                                       y: scrollView.contentOffset.y + 100.0)
        let moon = Moon(radius: 50.0, center: initialLocationInViewCoordinates)
        
        scrollView.containerView.addSubview(moon)
        
        let longPressMoonGestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(longPressMoonHandler(_:)))
        longPressMoonGestureRecogniser.minimumPressDuration = 0.3
        moon.addGestureRecognizer(longPressMoonGestureRecogniser)
        
        self.moon = moon
        moonPositionInView = CGPoint(x: 100.0, y: 100.0)
    }
    
    @objc private func longPressMoonHandler(_ sender: UILongPressGestureRecognizer) {
        let view = sender.view!
        
        switch sender.state {
        case .began: ()
            locationInMoonCenter = sender.location(in: view)
            
            guard locationInMoonCenter != nil else {
                fatalError("Couldn't find longPress location in moon")
            }
            
            locationInMoonCenter?.x -= 50
            locationInMoonCenter?.y -= 50
            
            UIView.animate(withDuration: 0.2, animations: {
                view.alpha = 0.7
                view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            })
        case .changed:
            let locationInView = sender.location(in: self.view)
            
            if let locationInMoonCenter = locationInMoonCenter {
                let newLocation = CGPoint(x: locationInView.x - locationInMoonCenter.x,
                                          y: locationInView.y - locationInMoonCenter.y)
                view.center = CGPoint(x: scrollView.contentOffset.x + newLocation.x,
                                      y: scrollView.contentOffset.y + newLocation.y)
                
                moonPositionInView = newLocation
            }
        case .ended:
            UIView.animate(withDuration: 0.2, animations: {
                view.alpha = 1.0
                view.transform = .identity
            })
        default: ()
        }
    }
    
    private func scrollViewSetup() {
        self.scrollView = InfiniteTwoSidedFullscreenScrollViewWithBuildings(frame: view.frame, height: view.frame.height)
        self.view.addSubview(scrollView)
    }
    
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        scrollViewSetup()
        makeAndPrepareMoon()
        scrollView.initiallySpawnViews()
    }
    
}
