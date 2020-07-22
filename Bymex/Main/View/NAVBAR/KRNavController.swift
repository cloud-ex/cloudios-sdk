//
//  KRNavController.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/10.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class KRNavController: UINavigationController , UIGestureRecognizerDelegate {

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.topViewController != viewController {
            super.pushViewController(viewController, animated: animated)
        }
    }
    
    override public var shouldAutorotate: Bool{
        return self.viewControllers.last!.shouldAutorotate
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return self.viewControllers.last!.supportedInterfaceOrientations
    }
    
    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return self.viewControllers.last!.preferredInterfaceOrientationForPresentation
    }
    
}
