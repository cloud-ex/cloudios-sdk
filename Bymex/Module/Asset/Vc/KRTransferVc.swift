//
//  KRTransferVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/24.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  资金划转

import Foundation

class KRTransferVc: KRNavCustomVC {
    
    var symbol:String = ""
    
    var amount:String = ""
    
    // MARK:- lazy
    lazy var selectCoinV : KRSelectCoinView = {
        let object = KRSelectCoinView()
        object.clickSelectCoinBlock = {[weak self] in
            let recordVc = KRSettingVc.init(.selectCoin)
            recordVc.setTitle("选择币种".localized())
            self?.navigationController?.pushViewController(recordVc, animated: true)
        }
        return object
    }()
    
    lazy var transferV : KRTransferHeaderView = {
        let object = KRTransferHeaderView()

        return object
    }()
    
    lazy var amountV : KRTransferaAmountView = {
        let object = KRTransferaAmountView()

        return object
    }()
    
    lazy var transferBtn : EXButton = {
        let object = EXButton()
        object.extUseAutoLayout()
        object.setTitle("asset_action_transfer".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeBtn.colorTitle, for: .normal)
        object.isEnabled = false
        object.rx.tap.subscribe(onNext:{ [weak self] in
            
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var transferRecord : UIButton = {
        let object = UIButton()
        object.extSetTitle("asset_action_transferRecord".localized(), 14, UIColor.ThemeLabel.colorMedium, .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            
        }).disposed(by: disposeBag)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviewsConstraint()
    }
    
    override func setNavCustomV() {
        self.setTitle("资金划转".localized())
        self.navCustomView.setRightModule([transferRecord],rightSize:[(80,15)])
    }
}

extension KRTransferVc {
    func addSubviewsConstraint() {
        view.addSubViews([selectCoinV,transferV,amountV,transferBtn])
        selectCoinV.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(NAV_SCREEN_HEIGHT + 20)
            make.height.equalTo(44)
        }
        transferV.snp.makeConstraints { (make) in
            make.left.right.equalTo(selectCoinV)
            make.top.equalTo(selectCoinV.snp.bottom).offset(20)
            make.height.equalTo(124)
        }
        amountV.snp.makeConstraints { (make) in
            make.left.right.equalTo(selectCoinV)
            make.height.equalTo(116)
            make.top.equalTo(transferV.snp.bottom).offset(20)
        }
        transferBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(selectCoinV)
            make.height.equalTo(44)
            make.top.equalTo(amountV.snp.bottom).offset(40)
        }
    }
}
