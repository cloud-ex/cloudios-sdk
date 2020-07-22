//
//  KRAssetDrawerVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/1.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  右边筛选

import Foundation

class KRAssetDrawerVc : KRNavCustomVC {
    
    var vcType : KRAssetRecordType = .deposit
    
    var sectionDataSource : [KRDrawerSiftSecEntity] = []
    
    var drawerVArr : [KRAssetDrawerV] = []
    
    lazy var resetBtn : KRFrameBtn = {
        let object = KRFrameBtn()
        object.extSetTitle("重置".localized(), 14, UIColor.ThemeLabel.colorHighlight, .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var comfirmBtn : EXButton = {
        let object = EXButton()
        object.setTitle("common_text_btnComfirm".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeBtn.colorTitle, for: .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            
        }).disposed(by: disposeBag)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navCustomView.isHidden = true
        view.backgroundColor = UIColor.ThemeTab.bg
        contentView.backgroundColor = UIColor.ThemeTab.bg
        sectionDataSource = PublicInfoEntity.sharedInstance.getAssetRecordDrawerEntitys(vcType)
        handleDrawerViews()
        handlePositiveBtn()
    }
}

extension KRAssetDrawerVc {
    func handleDrawerViews() {
        for i in 0..<sectionDataSource.count {
            let entity = sectionDataSource[i]
            let drawerV = KRAssetDrawerV.init(frame: CGRect.init(x: 0, y: CGFloat(i * 144) + NAV_SCREEN_HEIGHT - 30, width: self.view.width, height: 144), entity)
            view.addSubview(drawerV)
            drawerVArr.append(drawerV)
        }
    }
    
    func handlePositiveBtn() {
        contentView.addSubViews([resetBtn,comfirmBtn])
        resetBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-38)
        }
        comfirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(resetBtn.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
            make.width.height.bottom.equalTo(resetBtn)
        }
    }
}
