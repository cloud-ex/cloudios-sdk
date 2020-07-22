//
//  KRTitleBarItem.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/7.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class KRTitleBarItem : UIView {
    lazy var btnItem : KRFlatBtn = {
        let object = KRFlatBtn()
        return object
    }()
    
    lazy var indicator : UIView = {
        let object = UIView()
        return object
    }()
    var selectedColor:UIColor = UIColor.ThemeView.border
    var normalColor:UIColor = UIColor.clear
    
    var isSelected:Bool = false {
        didSet {
            btnItem.isSelected = isSelected
            if isSelected {
                indicator.backgroundColor = selectedColor
            }else {
                indicator.backgroundColor = normalColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        onCreate()
        addSubViews([btnItem,indicator])
        btnItem.snp.makeConstraints { (make) in
            make.top.right.bottom.left.equalToSuperview()
        }
        indicator.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCreate() {
        btnItem.clearColors()
    }
    
    func setFont(_ font:UIFont) {
        btnItem.titleLabel?.font = font
    }
    
    func setTitle(_ title:String) {
        btnItem.setTitle(title, for: .normal)
    }
    
    func setTitleColor(_ color:UIColor,state:UIControl.State) {
        btnItem.setTitleColor(color, for:state)
    }
}
