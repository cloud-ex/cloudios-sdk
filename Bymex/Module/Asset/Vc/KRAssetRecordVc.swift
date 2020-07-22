//
//  KRAssetRecordVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/28.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  充值提现记录

import Foundation

enum KRAssetRecordType {
    case deposit
    case withdraw
    case wallet
    case swap
}

class KRAssetRecordVc: KRNavCustomVC {
    
    var vcType = KRAssetRecordType.deposit
    
    var titleArr : [String] = []
    
    var tableViewRowDatas : [Any] = []
    
    lazy var headSegmentV : UISegmentedControl = {
        let object = UISegmentedControl.init(titles: titleArr)
        return object
    }()
    
    lazy var tableView : UITableView = {
        let object = UITableView()
        object.extUseAutoLayout()
        object.backgroundColor = UIColor.ThemeView.bg
        object.showsVerticalScrollIndicator = false
        object.extSetTableView(self, self)
        return object
    }()
    
    lazy var drawerBtn : UIButton = {
        let object = UIButton()
        object.extSetImages([UIImage.themeImageNamed(imageName: "asset_drawer")], controlStates: [.normal])
        object.rx.tap.subscribe(onNext:{ [weak self] in
            guard let myself = self else {return}
            let vc = KRAssetDrawerVc()
            vc.vcType = myself.vcType
            myself.gy_showSide(configuration: { (config) in
                config.direction = .right
            }, viewController: vc)
        }).disposed(by: disposeBag)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupSubviewsLayout()
        loadData()
    }
    
    override func setNavCustomV() {
        self.navCustomView.setRightModule([drawerBtn],rightSize:[(30,30)])
    }
}

extension KRAssetRecordVc {
    private func initData() {
        switch vcType {
        case .deposit:
            self.setTitle("充值")
            titleArr = ["充值".localized(),"提现".localized()]
            tableView.extRegistCell([KRAssetRecordTC.classForCoder()], ["KRAssetRecordTC1"])
        case .withdraw:
            self.setTitle("提现")
            titleArr = ["充值".localized(),"提现".localized()]
            tableView.extRegistCell([KRAssetRecordTC.classForCoder()], ["KRAssetRecordTC1"])
        case .wallet:
            self.setTitle("资金流水")
            titleArr = ["钱包账户".localized(),"合约账户".localized()]
            tableView.extRegistCell([KRAssetRecordTC.classForCoder()], ["KRAssetRecordTC2"])
        case .swap:
            self.setTitle("资金流水")
            titleArr = ["钱包账户".localized(),"合约账户".localized()]
            tableView.extRegistCell([KRAssetRecordTC.classForCoder()], ["KRAssetRecordTC2"])
        }
    }
    
    private func setupSubviewsLayout() {
        view.addSubViews([headSegmentV,tableView])
        headSegmentV.snp.makeConstraints { (make) in
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.top.equalTo(navCustomView.snp.bottom).offset(16)
            make.height.equalTo(32)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headSegmentV.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func loadData() {
        
    }
}

extension KRAssetRecordVc : UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if vcType == .deposit {
            let cell : KRAssetRecordTC = tableView.dequeueReusableCell(withIdentifier: "KRAssetRecordTC1") as! KRAssetRecordTC
            return cell
        } else if vcType == .withdraw {
            let cell : KRAssetRecordTC = tableView.dequeueReusableCell(withIdentifier: "KRAssetRecordTC1") as! KRAssetRecordTC
            return cell
        } else if vcType == .wallet {
            let cell : KRAssetRecordTC = tableView.dequeueReusableCell(withIdentifier: "KRAssetRecordTC2") as! KRAssetRecordTC
            return cell
        } else if vcType == .swap {
            let cell : KRAssetRecordTC = tableView.dequeueReusableCell(withIdentifier: "KRAssetRecordTC2") as! KRAssetRecordTC
            return cell
        }
        return UITableViewCell()
    }
    
    
}
