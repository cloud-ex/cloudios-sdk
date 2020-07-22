//
//  AppDelegateInit.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/15.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    func initWindow() -> UIWindow{
        let nav = initNavBarV()
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        window!.rootViewController = nav
        window!.makeKeyAndVisible()
        return window!
    }
    
    func initNavBarV() -> UINavigationController{
        let navBar = KRNavController()
        let tabbar = initTabbarV()
        navBar.isNavigationBarHidden = true
        navBar.viewControllers = [tabbar]
        navController = navBar
        return navBar
    }
    
    func initTabbarV() -> UITabBarController {
        
        var viewContrllers : [UIViewController] = []
        
        // 根据配置对应的控制器
        viewContrllers = [KRHomeVc(),KRSwapVc(),KRAssetVc()]
        
        let tabbarController = TabbarController()
        tabbarController.tabBar.isHidden = true
        tabbarController.selectedIndex = 0
        tabbarController.viewControllers = viewContrllers
        
        let tabbarView = KRTabbarView(tabbarController)
        tabbarView.backgroundColor = UIColor.ThemeTab.bg
        tabbarController.view.addSubview(tabbarView)
        tabbarView.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT - TABBAR_HEIGHT, width: SCREEN_WIDTH, height: TABBAR_HEIGHT)
        return tabbarController
    }
}
