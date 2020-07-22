//
//  KRSwapDetailSegment.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/8.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSwapDetailSegment: KRBaseV {
    
    typealias SwitchDetailSegmentBlock = (Int) -> ()
    var switchDetailSegmentBlock : SwitchDetailSegmentBlock?
    
    lazy var orderBtn : UIButton = {
        let object = UIButton()
        object.extSetTitle("盘口".localized(), 16, UIColor.ThemeLabel.colorDark, UIColor.ThemeLabel.colorLite)
        object.extSetAddTarget(self, #selector(clickSegment))
        object.tag = 1001
        object.isSelected = true
        return object
    }()
    lazy var depthBtn : UIButton = {
        let object = UIButton()
        object.extSetTitle("深度".localized(), 16, UIColor.ThemeLabel.colorDark, UIColor.ThemeLabel.colorLite)
        object.extSetAddTarget(self, #selector(clickSegment))
        object.tag = 1002
        object.isSelected = false
        return object
    }()
    lazy var dealBtn : UIButton = {
        let object = UIButton()
        object.extSetTitle("成交".localized(), 16, UIColor.ThemeLabel.colorDark, UIColor.ThemeLabel.colorLite)
        object.extSetAddTarget(self, #selector(clickSegment))
        object.tag = 1003
        return object
    }()
    lazy var bottomLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    lazy var introduceV : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.borderSelected
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([orderBtn,depthBtn,dealBtn,bottomLine,introduceV])
        bottomLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
        orderBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
        }
        depthBtn.snp.makeConstraints { (make) in
            make.left.equalTo(orderBtn.snp.right)
            make.bottom.equalToSuperview().offset(-1)
            make.width.height.top.equalTo(orderBtn)
        }
        dealBtn.snp.makeConstraints { (make) in
            make.left.equalTo(depthBtn.snp.right)
            make.right.equalToSuperview()
            make.width.height.top.equalTo(depthBtn)
        }
        introduceV.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
            make.width.equalTo(100)
            make.centerX.equalTo(orderBtn)
        }
    }
}

extension KRSwapDetailSegment {
    @objc func clickSegment(_ sender:UIButton) {
        sender.isSelected = true
        if sender == depthBtn {
            dealBtn.isSelected = false
            orderBtn.isSelected = false
        } else if sender == orderBtn {
            dealBtn.isSelected = false
            depthBtn.isSelected = false
        } else {
            depthBtn.isSelected = false
            orderBtn.isSelected = false
        }
        switchDetailSegmentBlock?(sender.tag)
        introduceV.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
            make.width.equalTo(100)
            make.centerX.equalTo(sender)
        }
    }
}
