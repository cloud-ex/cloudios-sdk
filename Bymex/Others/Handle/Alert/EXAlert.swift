//
//  EXAlert.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/9.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import SwiftEntryKit
import SKPhotoBrowser
import SwiftyDrop

enum DropMessageType {
    case success
    case fail
    case warning
}

class EXAlert: NSObject {
    
    public typealias EXCompletionHandler = () -> Void
    
    static func resignFirstResponder(){
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    static func showPhotoBrowser(urls:[String]) {
        var images = [SKPhoto]()
        for imgUrl in urls {
            let photo = SKPhoto.photoWithImageURL(imgUrl, holder: nil)
            images.append(photo)
        }
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        let topVc = KRCommom.topViewController()
        if topVc.isKind(of: UIViewController.classForCoder()) {
            topVc.present(browser, animated: true, completion: {})
        }
    }
    
    //actionsheet弹
    static func showSheet(sheetView:UIView,animated:Bool = true){
        self.resignFirstResponder()
        var attributes = EKAttributes()
        attributes.name = "ExSheet"
        attributes.windowLevel = .normal
        attributes.position = .bottom
        attributes.displayDuration = .infinity
        
        attributes.entranceAnimation = .init(translate: .init(duration:animated ? 0.2 : 0.0, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: animated ? 0.05 : 0.0, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.lifecycleEvents.willDisappear = {
            NotificationCenter.default.post(name: NSNotification.Name.init("EXSheetDissmissed"), object: nil)
        }
        attributes.positionConstraints.verticalOffset = isiPhoneX ? -34 : 0
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 0, screenEdgeResistance: NAV_TOP + 20)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        attributes.positionConstraints.keyboardRelation = keyboardRelation
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.screenBackground = .color(color: EKColor.init(UIColor.ThemeView.mask))
//        attributes.screenBackground = .color(color: UIColor.ThemeView.mask)
//        attributes.entryBackground = .color(color: UIColor.ThemeView.mask)
        attributes.scroll = .disabled
        SwiftEntryKit.display(entry: sheetView, using: attributes, presentInsideKeyWindow: true, rollbackWindow: .main)
    }
    
    //弹窗
    static func showAlert(alertView:UIView) {
        self.resignFirstResponder()
        var attributes = EKAttributes()
        attributes = .centerFloat
        attributes.name = "ExAlert"
        attributes.windowLevel = .alerts
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .intrinsic)

        attributes.entranceAnimation = .init(scale: .init(from: 0.9, to: 1, duration: 0.2, spring: .init(damping: 1, initialVelocity: 0)), fade: .init(from: 0, to: 1, duration: 0.3))
        attributes.exitAnimation = .init(fade: .init(from: 1, to: 0, duration: 0.2))
        attributes.displayDuration = .infinity
//        attributes.screenInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.screenBackground = .color(color: EKColor.init(UIColor.ThemeView.mask))
//        attributes.entryBackground = .color(color: UIColor.ThemeView.mask)
        attributes.scroll = .disabled
//        SwiftEntryKit.display(entry: alertView, using: attributes)
        SwiftEntryKit.display(entry: alertView, using: attributes, presentInsideKeyWindow: true, rollbackWindow: .main)
    }
    
    //show DatePicker
    static func showDatePicker(dateView:UIView){
        self.resignFirstResponder()
        var attributes = EKAttributes()
        attributes.name = "ExSheet"
        attributes.windowLevel = .normal
        attributes.position = .bottom
        attributes.displayDuration = .infinity
        attributes.entranceAnimation = .init(translate: .init(duration: 0.25, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.25, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.positionConstraints.verticalOffset = isiPhoneX ? -34 : 0
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 0, screenEdgeResistance: NAV_SCREEN_HEIGHT)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        attributes.positionConstraints.keyboardRelation = keyboardRelation
//        attributes.screenInteraction = .absorbTouches
//        attributes.entryInteraction = .absorbTouches
        attributes.screenBackground = .color(color: EKColor.init(UIColor.ThemeView.mask))
//        attributes.entryBackground = .color(color: UIColor.ThemeView.mask)
        attributes.scroll = .disabled
        SwiftEntryKit.display(entry: dateView, using: attributes)
    }
    
    //顶部下降
    static func showSuccess(msg:String) {
        self.showDrop(message: msg, msgType: .success)
    }
    
    @objc static func showFail(msg:String) {
        self.showDrop(message: msg, msgType: .fail)
    }
    
    static func showWarning(msg:String) {
        self.showDrop(message: msg, msgType: .warning)
    }
    
    static func showDrop(message:String,msgType:DropMessageType) {
        
        self.resignFirstResponder()
        var bgcolor = UIColor.ThemeState.normal80
        if msgType == .fail {
            bgcolor = UIColor.ThemeState.fail80
        }else if msgType == .warning {
            bgcolor = UIColor.ThemeState.warning80
        }
        Drop.down(message, state: .color(bgcolor), duration: 1.5, action: nil)
    }
    
    static func dismiss() {
        SwiftEntryKit.dismiss {
        }
    }

    static func dismissEnd(complete: @escaping () -> Void){
        SwiftEntryKit.dismiss(.displayed, with: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                complete()
            }
        })
        
    }
    
    static func showMessageAlert(_ message : String) {
        let alert = KRNormalAlert.init(frame: CGRect.init(x: 0, y: 0, width:  280, height: 140))
        alert.configMessage(message: message)
        self.showAlert(alertView: alert)
    }
    
}
