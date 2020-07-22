//
//  KRDepositVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/28.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  充值页面

import Foundation

class KRDepositVc: KRNavCustomVC {
    
    let depositVm = KRDepositVM()
    
    // MARK:- lazy
    lazy var selectCoinV : KRSelectCoinView = {
        let object = KRSelectCoinView()
        object.clickSelectCoinBlock = {[weak self] in
//            let recordVc = KRSettingVc.init(.selectCoin)
//            recordVc.setTitle("选择币种".localized())
//            self?.navigationController?.pushViewController(recordVc, animated: true)
            let vc = KRAssetRecordDetailVc()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return object
    }()
    
    lazy var depositV : KRDepositView = {
        let object = KRDepositView.init(.usdt)
        return object
    }()
    
    lazy var pleasantTipV : UILabel = {
        let object = UILabel()
        let str = "温馨提示\n充币需要 3 个网络确认才能到账\n最小充币数量 3 EOS,小于最小数量的充币不会入账且无法退回"
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 8
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12),
                          NSAttributedString.Key.paragraphStyle: paraph]
        object.attributedText = NSAttributedString(string: str, attributes: attributes)
        object.textColor = UIColor.ThemeLabel.colorDark
        object.numberOfLines = 0
        return object
    }()
    
    lazy var depositRecord : UIButton = {
        let object = UIButton()
        object.extSetTitle("充值记录".localized(), 14, UIColor.ThemeLabel.colorMedium, .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            let vc = KRAssetRecordVc()
            vc.vcType = .deposit
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(xscrollView)
        xscrollView.backgroundColor = UIColor.ThemeView.bg
        xscrollView.snp.makeConstraints { (make) in
            make.top.equalTo(navCustomView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        setupSubViewsLayout()
        bindVM()
    }
    override func setNavCustomV() {
        self.setTitle("充值".localized())
        self.navCustomView.setRightModule([depositRecord],rightSize:[(80,15)])
    }
    
    func bindVM() {
        depositVm.setVC(self)
        depositVm.getDepositAddress("USDT")
    }
}

extension KRDepositVc {
    func setupSubViewsLayout() {
        xscrollView.addSubViews([selectCoinV,depositV,pleasantTipV])
        selectCoinV.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(SCREEN_WIDTH - 32)
            make.height.equalTo(44)
            make.top.equalTo(20)
        }
        depositV.snp.makeConstraints { (make) in
            make.left.right.equalTo(selectCoinV)
            make.top.equalTo(selectCoinV.snp.bottom).offset(10)
        }
        pleasantTipV.snp.makeConstraints { (make) in
            make.left.right.equalTo(selectCoinV)
            make.top.equalTo(depositV.snp.bottom).offset(20)
        }
        depositV.setVType(.eos)
        
    }
}
