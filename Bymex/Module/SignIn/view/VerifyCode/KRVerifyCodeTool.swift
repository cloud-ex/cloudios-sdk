//
//  KRVerifyCodeTool.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/20.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRVerifyCodeTool:NSObject {
    
    typealias CancelVerifyBlock = ()->()
    var cancelVerifyBlock : CancelVerifyBlock?
    
    typealias FinishVerifyBlock = (Bool,String,String)->()
    var finishVerifyBlock : FinishVerifyBlock?
    
    var manager: NTESVerifyCodeManager = NTESVerifyCodeManager.getInstance()
    
    public static var sharedInstance : KRVerifyCodeTool{
        struct Static {
            static let instance : KRVerifyCodeTool = KRVerifyCodeTool()
        }
        return Static.instance
    }
}

extension KRVerifyCodeTool : NTESVerifyCodeManagerDelegate {
    func showNetsVerifyCodeOnView(_ v : UIView) {
        self.manager.delegate = self
        self.manager.configureVerifyCode(NetDefine.CaptchID, timeout: 10.0)
        if KRBasicParameter.isHan() {
            self.manager.lang = .CN
        } else {
            self.manager.lang = .EN
        }
        self.manager.alpha = 0.3;
        // 设置颜色
        self.manager.color = UIColor.ThemeView.mask;
        // 设置frame
        self.manager.frame = CGRect.null;
        // 显示验证码
        self.manager.openVerifyCodeView()
    }
    
    //MARK:-完成验证之后的回调
    func verifyCodeValidateFinish(_ result: Bool, validate: String!, message: String!) {
        self.finishVerifyBlock?(result,validate,message)
    }
    
    func verifyCodeCloseWindow() {
        self.cancelVerifyBlock?()
    }
}

