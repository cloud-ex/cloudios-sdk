//
//  KRBaseV.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRBaseV: UIView {
    let MarginSpace = 15
    
    func setupSubViewsLayout() {
        backgroundColor = UIColor.ThemeView.bg
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubViewsLayout()
        onCreat()
    }
    
    func onCreat() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
