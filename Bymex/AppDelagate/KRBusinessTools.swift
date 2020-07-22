//
//  KRBusinessTools.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/27.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import AdSupport
import YYText

let idfa: String = {
    var idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    if idfa == "00000000-0000-0000-0000-000000000000" {
        var idfv = UIDevice.current.identifierForVendor?.uuidString
        if idfv == nil || idfv == "00000000-0000-0000-0000-000000000000" {
            idfv = "NoIDFA_NoIDFV_" + UUID.init().uuidString
        }
        idfa = idfv!
    }
    
    return idfa
}()

class KRBusinessTools : NSObject {
    
    // 弹出登录界面
    class func showLoginVc(_ baseVc : UIViewController?) {
        XHUDManager.show()
        let gestureOpen = XUserDefault.getGesturesPassword()
        let biometricsOpen = XUserDefault.getFaceIdOrTouchIdPassword()
        var vc = UIViewController()
        if gestureOpen != nil && biometricsOpen != nil { // 生物识别跟手势同时打开 (打开手势解锁页面)
            let v : KRGestureVerifyVc = KRGestureVerifyVc.init(.loginVerify)
            v.hasBiometrics = true
            vc = v
        } else if gestureOpen != nil && biometricsOpen == nil { // 只打开了手势密码 (打开手势解锁页面)
            vc = KRGestureVerifyVc.init(.loginVerify)
        } else if gestureOpen == nil && biometricsOpen != nil { // 打开了生物识别登录 (打开生物识别页面)
            vc = KRBiometricsVc.init(.loginFace)
        } else if gestureOpen == nil && biometricsOpen == nil { // 什么都没有打开 (打开普通登录页面)
            vc = KRSignVc()
        } 
        if baseVc?.isKind(of: KRAccountVc.classForCoder()) == true {
            baseVc?.gy_sidePushViewController(viewController: vc)
        } else {
            baseVc?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK:-获取登录状态
    class func loginStatus() -> Bool {
        if let account = XUserDefault.getActiveAccount() {
            if account.token != "" {
                return true
            }
        }
        return false
    }
    
    //MARK:- 调用登录
    class func toLogin(_ vm : KRSignInVM?) {
        if vm == nil {
            return
        }
        guard let accountName = XUserDefault.getAccountName(),let password = XUserDefault.getUserSignPassword() else {
            return
        }
        vm!.requestToSignin(accountName, password, { (result) in
            if result {
            }
        })
    }
}

extension KRBusinessTools {
    
    //MARK:-被强制退出
    class func logoutNet(){
        guard let nav = KRBusinessTools.getRootNavBar()else{
            return
        }
        if let tabbar = KRBusinessTools.getRootTabbar(){
            if XUserDefault.getToken() == nil{
                let vc = tabbar.getCurrentTabbarVC()
                if vc is KRAssetVc{
                    tabbar.selectIndex(0 , showLogin:false)
                }
                if vc is KRSwapVc{
                    // 合约界面重新加载数据
                }
                nav.popToRootViewController(animated: true)
            }
        }
    }
    
    //MARK:获取rootTabbar
    class func getRootTabbar() -> TabbarController?{
        guard let appDelegate = UIApplication.shared.delegate else {
            return nil
        }
        if let tabbarController = appDelegate.window??.rootViewController?.children[0] as? TabbarController{
            return tabbarController
        }
        return nil
    }
    
    //MARK:获取rootNavBar
    class func getRootNavBar() -> KRNavController?{
        guard let appDelegate = UIApplication.shared.delegate else {
            return nil
        }
        if let navController = appDelegate.window??.rootViewController as? KRNavController{
            return navController
        }
        return nil
    }
    
    //MARK: 判断是否为纯数字
    class func number(_ str : String) -> Bool{
        var tmpresult = false
        
        var regex: NSRegularExpression = NSRegularExpression.init()
        
        let linkPattern: String = "^\\d{0,}$"
        
        //构造正则表达式
        do {
            regex = try NSRegularExpression.init(pattern: linkPattern, options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            ProgressHUDManager.showFailWithStatus("正则表达式有问题")
        }
        
        //遍历目标字符串
        regex.enumerateMatches(in: str, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, str.count)) { (result, flags, stop) in
            if result == nil {
                return
            } else {
                tmpresult = true
                return
            }
        }
        return tmpresult
    }
    //MARK: 判断是否为邮箱
    class func isEmail(_ str : String) -> Bool{
        var tmpresult = false
        if str.count < 5 || str.count > 100{
            return tmpresult
        }
        
        var regex: NSRegularExpression = NSRegularExpression.init()
        
        let linkPattern: String = "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$"
        
        //构造正则表达式
        do {
            regex = try NSRegularExpression.init(pattern: linkPattern, options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            ProgressHUDManager.showFailWithStatus("正则表达式有问题")
        }
        
        //遍历目标字符串
        regex.enumerateMatches(in: str, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, str.count)) { (result, flags, stop) in
            if result == nil {
                return
            } else {
                tmpresult = true
                return
            }
        }
        return tmpresult
    }
    
    //MARK:- 重启app
    class func reloadWindow(){
        let window = UIApplication.shared.keyWindow
        let nav = AppDelegate().initNavBarV()
        window?.makeKeyAndVisible()
        window?.rootViewController = nav
    }
}
