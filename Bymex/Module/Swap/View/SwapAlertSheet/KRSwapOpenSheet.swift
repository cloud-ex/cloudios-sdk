//
//  KRSwapOpenSheet.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/16.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSwapOpenSheet: KRSwapBaseSheet {
    lazy var tipsView : UITextView = {
        let object = UITextView(frame: CGRect.init(x: 16, y: 20, width: self.width - 32, height: 280))
        object.extUseAutoLayout()
        object.backgroundColor = UIColor.ThemeView.bg;
        object.font = UIFont.ThemeFont.BodyRegular
        object.textColor = UIColor.ThemeLabel.colorDark
        object.text = "contract_text_openswap_risk".localized()
        object.textAlignment = .left
        object.isEditable = false
        object.isScrollEnabled = true
        return object
    }()
    
    lazy var riskBtn : UIButton = {
        let object = UIButton()
        object.extSetTitle("我已知晓风险，继续开通合约账户".localized(), 14, UIColor.ThemeLabel.colorMedium, .normal)
        object.extSetImages([UIImage.themeImageNamed(imageName: "swap_board_unSelected"),UIImage.themeImageNamed(imageName: "swap_board_selected")], controlStates: [.normal,.selected])
        object.extSetAddTarget(self, #selector(clickContinueBtn))
        object.imageView?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        })
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        contentView.addSubViews([tipsView,riskBtn])
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(370)
        }
        tipsView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(20)
            make.width.equalTo(SCREEN_WIDTH - 32)
            make.height.equalTo(300)
        }
        riskBtn.snp.makeConstraints { (make) in
            make.left.equalTo(tipsView)
            make.top.equalTo(tipsView.snp.bottom).offset(20)
            make.height.equalTo(24)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH - 32)
        }
        submitBtn.setTitle("立即开通".localized(), for: .normal)
        submitBtn.isEnabled = false
        nameLabel.text = "开通合约".localized()
    }
    
    override func clickSubmitBtn(_ sender: EXButton) {
        super.clickSubmitBtn(sender)
        
    }
}

extension KRSwapOpenSheet {
    // 点击开通合约
    @objc func clickContinueBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        submitBtn.isEnabled = sender.isSelected
    }
}
