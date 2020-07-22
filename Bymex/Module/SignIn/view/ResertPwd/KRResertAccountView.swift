//
//  KRResertAccountView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

class KRResertAccountView: KRBaseV {
    
    typealias ClickNextBtnBlock = ()->()
    var clickNextBtnBlock : ClickNextBtnBlock?
    
    lazy var accountName : KRLineField = {
        let object = KRLineField.init(frame: .zero, lineFieldType: .endNone)
        object.setPlaceHolder(placeHolder: "login_text_phoneOrMail".localized(), font: 16)
        object.titleLabel.text = "login_text_phoneOrMail".localized()
        return object
    }()
    lazy var nextBtn : EXButton = {
        let object = EXButton()
        object.extUseAutoLayout()
        object.setTitle("login_action_login".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeBtn.colorTitle, for: .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            self?.clickNextBtnBlock?()
        }).disposed(by: disposeBag)
        object.isEnabled = false
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        accountName.input.rx.text.orEmpty
            .map{ $0.count > 5}
            .share(replay: 1).subscribe(onNext: {[weak self] (bool) in
                self?.nextBtn.isEnabled = bool
                }, onError: { (error) in
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubViewsLayout() {
        addSubViews([accountName,nextBtn])
        accountName.snp.makeConstraints { (make) in
            make.left.equalTo(MARGIN_LEFT)
            make.right.equalTo(-MARGIN_LEFT)
            make.top.equalToSuperview()
            make.height.equalTo(56)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(accountName)
            make.height.equalTo(44)
            make.top.equalTo(accountName.snp.bottom).offset(40)
        }
    }
}
