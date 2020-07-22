//
//  KRSwapLightView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/17.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class KRSideTransitioningDelegate: NSObject,UIViewControllerTransitioningDelegate {
    
    var presentationInteractiveTransition: KRSidePercentInteractiveTransition?
    var dismissalInteractiveTransition: KRSidePercentInteractiveTransition!
    var config: KRSideConfig!
    
    init(config:KRSideConfig?) {
        self.config = config
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return KRSideAnimatedTransitioning(showType: .show, config: config)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return KRSideAnimatedTransitioning(showType: .hidden, config: config)
    }
    
    // present交互的百分比
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if presentationInteractiveTransition == nil {
            return nil
        }else {
            return (presentationInteractiveTransition?.isInteractive)! ? presentationInteractiveTransition : nil
        }
    }
    
    // dismiss交互的百分比
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissalInteractiveTransition.isInteractive ? dismissalInteractiveTransition : nil
    }
    deinit {
//        print( NSStringFromClass(self.classForCoder) + " 销毁了---->3")
    }
    
}

