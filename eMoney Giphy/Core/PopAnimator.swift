//
//  PopAnimator.swift
//  eMoney Giphy
//
//  Created by Nikoloz Tatunashvili on 23.08.18.
//  Copyright © 2018 Nikoloz Tatunashvili. All rights reserved.
//


import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.35
    var presenting = true
    var originFrame = CGRect.zero
    
    var dismissCompletion: (() -> ())?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let herbView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame = presenting ? originFrame : herbView.frame
        let finalFrame = presenting ? herbView.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
    
        if presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint( x: initialFrame.midX, y: initialFrame.midY)
            herbView.clipsToBounds = true
            herbView.alpha = 0
        }
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: herbView)
        
        UIView.animate(withDuration: duration,
                       animations: {
                        herbView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
                        herbView.alpha = self.presenting ? 1.0 : 0.0
                        herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        })
    }
}
