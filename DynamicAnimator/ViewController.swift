//
//  ViewController.swift
//  DynamicAnimator
//
//  Created by Citizen on 9/13/18.
//  Copyright © 2018 Citizen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var squareViews = [UIDynamicItem]()
    var animator = UIDynamicAnimator()
    
    var squareViewMove = UIView()
    var pushBehavior = UIPushBehavior()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        let numberOfView = 2
        squareViews.reserveCapacity(numberOfView)
        
        var colors = [UIColor.red, UIColor.green]
        var currentCenterPosition = CGPoint()
        let eachViewSize = CGSize(width: 50, height: 50)
        
        for count in 0..<numberOfView {
            let newView = UIView(frame: CGRect(x: 0, y: 0, width: eachViewSize.width, height: eachViewSize.height))
            newView.backgroundColor = colors[count]
            newView.center = self.view.center
            currentCenterPosition.y += eachViewSize.height + 50
            self.view.addSubview(newView)
            squareViews.append(newView)
        }
        
        animator = UIDynamicAnimator(referenceView: view)
        let gravity = UIGravityBehavior(items: squareViews)
        animator.addBehavior(gravity)
        
        let collision = UICollisionBehavior(items: squareViews)
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: CGPoint(x: 0, y: view.bounds.height - 100), to: CGPoint(x: view.bounds.size.width, y: view.bounds.size.height - 100))
        collision.collisionDelegate = self
        animator.addBehavior(collision)
        
        createGestureRecognazer()
        createSmallSquareView()
        createAnimationAndBehaviors()
        
    }
    
    func createSmallSquareView() {
        squareViewMove = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        squareViewMove.center = self.view.center
        squareViewMove.backgroundColor = UIColor.orange
        self.view.addSubview(squareViewMove)
    }
    
    func createGestureRecognazer() {
        let tapGestureRecognazer = UITapGestureRecognizer(target: self, action: #selector(hendlertap(paramTap:)))
        self.view.addGestureRecognizer(tapGestureRecognazer)
    }
    
    func createAnimationAndBehaviors() {
        let collision = UICollisionBehavior(items: [squareViewMove])
        collision.translatesReferenceBoundsIntoBoundary = true
        pushBehavior = UIPushBehavior(items: [squareViewMove], mode: .continuous)
        animator.addBehavior(collision)
        animator.addBehavior(pushBehavior)
    }
    
    @objc func hendlertap(paramTap: UITapGestureRecognizer) {
        let tapPoint: CGPoint = paramTap.location(in: view)
        let squareViewCenterPoint: CGPoint = squareViewMove.center
        let deltaX: CGFloat = tapPoint.x - squareViewCenterPoint.x
        let deltaY: CGFloat = tapPoint.y - squareViewCenterPoint.y
        let angle: CGFloat = atan2(deltaY, deltaX)
        pushBehavior.angle = angle
        
        let distanceBetweenPints: CGFloat = sqrt(pow(tapPoint.x - squareViewCenterPoint.x, 2.0) + pow(tapPoint.y - squareViewCenterPoint.y, 2.0))
        pushBehavior.magnitude = distanceBetweenPints / 200
    }
    
}

extension ViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let identifier = identifier as? String
        let kBottomBoundary = "bottomBoundary"
        if identifier == kBottomBoundary {
            UIView.animate(withDuration: 1.0, animations: {
                let view = item as? UIView
                view?.backgroundColor = UIColor.red
                view?.alpha = 0.0
                view?.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            }, completion: {(finished) in
                let view = item as? UIView
                behavior.removeItem(item)
                view?.removeFromSuperview()
            })
        }
    }
}

