//
//  KRSwapBaseSheet.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/22.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSwapBaseSheet: KRBaseV {
    
    typealias ClickSubmitBtnBlock = () -> ()
    var clickSubmitBtnBlock : ClickSubmitBtnBlock?
    
    lazy var nameLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    
    lazy var cancelBtn : UIButton = {
        let object = UIButton()
        object.setImage(UIImage.themeImageNamed(imageName: "closed"), for: .normal)
        object.extSetAddTarget(self, #selector(clickCancel))
        return object
    }()
    lazy var headLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    
    lazy var contentView : UIScrollView = {
        let object = UIScrollView()
        object.showsVerticalScrollIndicator = false
        object.showsHorizontalScrollIndicator = false
        return object
    }()
    
    lazy var submitBtn : EXButton = {
        let object = EXButton()
        object.extUseAutoLayout()
        object.setTitle("确定".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeBtn.colorTitle, for: .normal)
        object.extSetAddTarget(self, #selector(clickSubmitBtn))
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([nameLabel,cancelBtn,headLine,contentView,submitBtn])
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH * 0.5 - 16)
            make.top.equalTo(14)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalTo(nameLabel)
            make.width.height.equalTo(25)
        }
        headLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(1)
            make.top.equalTo(nameLabel.snp_bottom).offset(14)
        }
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(headLine.snp_bottom)
            make.height.equalTo(1)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(contentView.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-TABBAR_BOTTOM-10)
        }
    }
}

extension KRSwapBaseSheet {
    
    @objc func clickSubmitBtn(_ sender: EXButton) {
        sender.showLoading()
        clickSubmitBtnBlock?()
    }
    
    @objc func clickCancel() {
        EXAlert.dismiss()
        clearSubViews()
        removeFromSuperview()
    }
}
