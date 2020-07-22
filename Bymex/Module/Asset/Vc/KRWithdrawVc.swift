//
//  KRWithdrawVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/28.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  提现页面

import Foundation

enum KRWithdrawType {
    case normal
    case eos
    case usdt
}

class KRWithdrawVc : KRNavCustomVC {
    
    // MARK:- lazy
    lazy var selectCoinV : KRSelectCoinView = {
        let object = KRSelectCoinView()
        object.clickSelectCoinBlock = {[weak self] in
//            let recordVc = KRSettingVc.init(.selectCoin)
//            recordVc.setTitle("选择币种".localized())
//            self?.navigationController?.pushViewController(recordVc, animated: true)
            let alert = KRImageAlert()
            alert.configAlertView()
            EXAlert.showAlert(alertView: alert)
        }
        return object
    }()
    
    lazy var withdrawV : KRWithdrawV = {
        let object = KRWithdrawV.init(.usdt)
        return object
    }()
    
    lazy var resultV : KRWithdrawBottomV = {
        let object = KRWithdrawBottomV()
        return object
    }()
    
    lazy var confirmBtn : EXButton = {
        let object = EXButton()
        object.extUseAutoLayout()
        object.setTitle("common_text_btnComfirm".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeBtn.colorTitle, for: .normal)
        object.isEnabled = false
        object.rx.tap.subscribe(onNext:{ [weak self] in
            
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var withdrawRecord : UIButton = {
        let object = UIButton()
        object.extSetTitle("提现记录".localized(), 14, UIColor.ThemeLabel.colorMedium, .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            let vc = KRAssetRecordVc()
            vc.vcType = .withdraw
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews([xscrollView,confirmBtn])
        xscrollView.backgroundColor = UIColor.ThemeView.bg
        xscrollView.snp.makeConstraints { (make) in
            make.top.equalTo(navCustomView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-94)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-20)
        }
        setupSubViewsLayout()
    }
    
    override func setNavCustomV() {
        self.setTitle("提现".localized())
        self.navCustomView.setRightModule([withdrawRecord],rightSize:[(80,15)])
    }
}

extension KRWithdrawVc {
    func setupSubViewsLayout() {
        xscrollView.addSubViews([selectCoinV,withdrawV,resultV])
        selectCoinV.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(SCREEN_WIDTH - 32)
            make.height.equalTo(44)
            make.top.equalTo(20)
        }
        withdrawV.snp.makeConstraints { (make) in
            make.left.right.equalTo(selectCoinV)
            make.top.equalTo(selectCoinV.snp.bottom).offset(10)
        }
        resultV.snp.makeConstraints { (make) in
            make.left.right.equalTo(selectCoinV)
            make.top.equalTo(withdrawV.snp.bottom).offset(10)
        }
        
    }
}
