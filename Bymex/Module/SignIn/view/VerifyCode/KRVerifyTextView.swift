//
//  KRVerifyTextView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRVerifyTextView: UITextField {
    
    /// 是否隐藏所有菜单
    var isHiddenAllMenu = false
    
    var pasteClouruse: ((_ isTrigger: Bool) -> Bool)?
    
    var selectClouruse: ((_ isTrigger: Bool) -> Bool)?
    
    var selectAllClouruse: ((_ isTrigger: Bool) -> Bool)?
    
    var copyClouruse: ((_ isTrigger: Bool) -> Bool)?
    
    var cutClouruse: ((_ isTrigger: Bool) -> Bool)?
    
    var deleteClouruse: ((_ isTrigger: Bool) -> Bool)?
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if isHiddenAllMenu {
            UIMenuController.shared.isMenuVisible = false
            return false
        }
        // 菜单是否隐藏
        var isTrigger = false
        
        if let vc = sender as? UIMenuController {
            isTrigger = vc.isMenuVisible
        }
        switch action {
        case #selector(UIResponderStandardEditActions.paste(_:)):
            if let pasteClouruse = pasteClouruse {
                return pasteClouruse(isTrigger)
            } else {
                return super.canPerformAction(action, withSender: sender)
            }
        case #selector(UIResponderStandardEditActions.select(_:)):
            if let selectClouruse = selectClouruse {
                return selectClouruse(isTrigger)
            } else {
                return super.canPerformAction(action, withSender: sender)
            }
        case #selector(UIResponderStandardEditActions.selectAll(_:)):
            if let selectAllClouruse = selectAllClouruse {
                return selectAllClouruse(isTrigger)
            } else {
                return super.canPerformAction(action, withSender: sender)
            }
        case #selector(UIResponderStandardEditActions.copy(_:)):
            if let copyClouruse = copyClouruse {
                return copyClouruse(isTrigger)
            } else {
                return super.canPerformAction(action, withSender: sender)
            }
        case #selector(UIResponderStandardEditActions.cut(_:)):
            if let cutClouruse = cutClouruse {
                return cutClouruse(isTrigger)
            } else {
                return super.canPerformAction(action, withSender: sender)
            }
        case #selector(UIResponderStandardEditActions.delete(_:)):
            if let deleteClouruse = deleteClouruse {
                return deleteClouruse(isTrigger)
            } else {
                return super.canPerformAction(action, withSender: sender)
            }
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }
}
