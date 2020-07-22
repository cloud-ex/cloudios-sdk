//
//  KRSwapLightView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/17.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

final class KRSideMaskView: UIVisualEffectView {

    init() {
        super.init(effect: UIBlurEffect.init(style: .dark))
        //初始准备代码
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_ :)))
        self.addGestureRecognizer(tap)
        
        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(_ :)))
        self.addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func tapAction(_ sender:UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:KRSideTapNotification), object: nil)
    }
    
    @objc private func panAction(_ sender:UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:KRSidePanNotification), object: sender)
    }
    
    func destroy() {
        self.removeFromSuperview()
    }
    
    deinit {
//        print( NSStringFromClass(self.classForCoder) + " 销毁了---->2")
    }
}

