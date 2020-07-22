//
//  KRAssetRecordDetailVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/1.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRAssetRecordDetailVc: KRNavCustomVC {
    
    var entity = KRSettlesEntity()
    
    var rowData : [[String:String]] = []
    
    lazy var headView : KRAssetRecordHeadView = {
        let object = KRAssetRecordHeadView()
        object.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 160)
        return object
    }()
    
    lazy var tableView : UITableView = {
        let object = UITableView()
        object.extUseAutoLayout()
        object.backgroundColor = UIColor.ThemeView.bg
        object.showsVerticalScrollIndicator = false
        object.extSetTableView(self, self)
        object.extRegistCell([KRAssetRecordDetailTC.classForCoder()], ["KRAssetRecordDetailTC"])
        object.tableHeaderView = headView
        object.bounces = false
        return object
    }()
    
    lazy var cancelBtn : UIButton = {
        let object = UIButton()
        object.extSetTitle("取消", 14, UIColor.ThemeLabel.colorDark, .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            
        }).disposed(by: disposeBag)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        entity.coin_code = "AT"
        entity.created_at = "2020-01-07T19:07:40.997816Z"
        entity.fee = "0"
        entity.from_address = "0x7747b3fd228d8fd70a6986758615089d3f58acd7"
        entity.status = 3
        entity.to_address = "0xd09dcbf84b7bcdd99d475be34f3c7a16d10eeaf0"
        entity.tx_hash = "0x02fc981d464e20e1456168e50bad50d6f0a8852bc59b471ff193571517963862"
        entity.type = 2
        entity.updated_at = "2020-01-07T19:07:40.997816Z"
        entity.vol = "9870"
        entity.account_id = 16688359
        entity.error = "审核未通过"
        
        setAssetRecordDetailData()
    }
    
    override func setNavCustomV() {
        if entity.status < 3 {
            self.navCustomView.setRightModule([cancelBtn],rightSize:[(60,15)])
        }
    }
}

extension KRAssetRecordDetailVc  {
    func setAssetRecordDetailData() {
        if entity.type == KRSettlesType.SettlesTypeDeposit.rawValue || entity.type == KRSettlesType.SettlesTypeDeposit.rawValue { // 充值
            self.setTitle(entity.coin_code+"充值".localized())
            rowData = [["name":"充值地址","content":entity.to_address],
                       ["name":"Txid","content":entity.tx_hash],
                       ["name":"From","content":entity.from_address],
                       ["name":"时间","content":entity.updated_at]]
        } else if entity.type == KRSettlesType.SettlesTypeWithDraw.rawValue || entity.type == KRSettlesType.SettlesTypeInset.rawValue { // 提现
            self.setTitle(entity.coin_code+"提现".localized())
            if entity.status == KRSellerStatus.SETTLE_STATUS_REJECTED.rawValue || entity.status == KRSellerStatus.SETTLE_STATUS_FAILED.rawValue {
                rowData = [["name":"矿工手续费","content":String(format: "%@%@", entity.fee,entity.fee_coin_code)],
                ["name":"提现地址","content":entity.to_address],
                ["name":"Txid","content":entity.tx_hash],
                ["name":"From","content":entity.from_address],
                ["name":"时间","content":entity.updated_at],
                ["name":"失败原因","content":entity.error]]
            } else {
                rowData = [["name":"矿工手续费","content":String(format: "%@%@", entity.fee,entity.fee_coin_code)],
                ["name":"提现地址","content":entity.to_address],
                ["name":"Txid","content":entity.tx_hash],
                ["name":"From","content":entity.from_address],
                ["name":"时间","content":entity.updated_at]]
            }
        }
        headView.setHeadV(entity.status, volume: String(format: "%@ %@", entity.vol,entity.coin_code))
        tableView.reloadData()
    }
}

extension KRAssetRecordDetailVc: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : KRAssetRecordDetailTC = tableView.dequeueReusableCell(withIdentifier: "KRAssetRecordDetailTC") as! KRAssetRecordDetailTC
        let itemEntity = rowData[indexPath.row]
        cell.setCell(itemEntity["name"]!, content: itemEntity["content"]!)
        return cell
    }
    
    
}
