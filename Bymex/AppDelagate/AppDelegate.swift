//
//  AppDelegate.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController : UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        // 初始化键盘
        let IQ = IQKeyboardManager.shared()
        IQ.isEnabled = true       //控制整个功能是否启用
        IQ.shouldResignOnTouchOutside = true      //控制点击背景是否收起键盘
        IQ.shouldToolbarUsesTextFieldTintColor = false       //控制键盘上的工具条文字颜色是否用户自定义
        IQ.isEnableAutoToolbar = true      //控制是否显示键盘上的工具条
        
        // 初始化主题
        KRThemeManager.restoreLastTheme()
        KRThemeManager.switchTo(theme: .night)
        IQ.toolbarTintColor = UIColor.ThemeLabel.colorHighlight
        
        // 初始化语言
        KRLaunguageTools.shareInstance.initUserLanguage()
        
        // 初始化合约配置
        KRSwapSDKManager.shared.configSLContractSDK()
        
        let launchAnimationVC = KRLaunchVc()
        launchAnimationVC.show {[weak self] in
            // 初始化界面
            self?.window = self?.initWindow()
        }
        window?.rootViewController = launchAnimationVC
        window?.makeKeyAndVisible()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        KRSwapSDKManager.shared.krWebSocketClose()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        KRSwapSDKManager.shared.krWebSocketConnect()
        KRSwapSDKManager.shared.krGetAllPosition()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

}

