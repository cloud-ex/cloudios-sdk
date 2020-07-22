//
//  KRSwapInfoVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/2.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  合约信息数据

import Foundation

enum SwapInfoType {
    case baseSwapInfo   // 合约信息
    case InsuranceFund  // 保险基金
    case FundingRate    // 保险基金
}

class KRSwapInfoVc: KRNavCustomVC {
    
    var tableViewRowDatas : [KRSwapInfoEntity] = []
    var tableViewRowDatas1 : [BTIndexDetailModel] = []
    
    var vcType = SwapInfoType.baseSwapInfo
    
    var itemModel : BTItemModel?
    
    lazy var tableView : UITableView = {
        let tableV = UITableView()
        tableV.extUseAutoLayout()
        tableV.extSetTableView(self, self)
        tableV.separatorStyle = .none
        tableV.backgroundColor = UIColor.ThemeView.bg
        if vcType == .baseSwapInfo || vcType == .InsuranceFund {
            tableV.extRegistCell([KRSwapInfoTC.classForCoder()], ["KRSwapInfoTC"])
        } else {
            tableV.extRegistCell([KRSwapFundRateTC.classForCoder()], ["KRSwapFundRateTC"])
        }
        tableV.rowHeight = 30
        return tableV
    }()
    
    lazy var headeV : KRSwapInfoHeaderView = {
        let object = KRSwapInfoHeaderView()
        if vcType == .InsuranceFund {
            object.leftLabel.text = "时间".localized()
            object.rightLabel.text = "余额".localized()
        } else if vcType == .FundingRate {
            object.leftLabel.text = "时间".localized()
            object.middleLabel.isHidden = false
            object.middleLabel.text = "资金费率间隔"
            object.rightLabel.text = "资金费率".localized()
        }
        return object
    }()
    
    public convenience init(_ type : SwapInfoType) {
        self.init()
        self.vcType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        loadData()
    }
    
    override func setNavCustomV() {
        switch vcType {
        case .baseSwapInfo:
            self.setTitle("合约信息".localized())
        case .InsuranceFund:
            self.setTitle("保险基金".localized())
        case .FundingRate:
            self.setTitle("资金费率".localized())
        }
    }
}

extension KRSwapInfoVc: UITableViewDelegate ,UITableViewDataSource {
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vcType == .baseSwapInfo {
            return tableViewRowDatas.count
        } else {
            return tableViewRowDatas1.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch vcType {
        case .baseSwapInfo:
            let entity = tableViewRowDatas[indexPath.row]
            let cell : KRSwapInfoTC = tableView.dequeueReusableCell(withIdentifier: "KRSwapInfoTC") as! KRSwapInfoTC
            cell.setCell(entity)
            if entity.showLine {
                cell.contentLabel.clickRightLabelBlock = { [weak self] in
                    if entity.name == "保险基金".localized() {
                        let vc = KRSwapInfoVc.init(.InsuranceFund)
                        vc.itemModel = self?.itemModel
                        self?.navigationController?.pushViewController(vc, animated: true)
                    } else if entity.name == "资金费率".localized() {
                        let vc = KRSwapInfoVc.init(.FundingRate)
                        vc.itemModel = self?.itemModel
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            return cell
        case .InsuranceFund:
            let entity = tableViewRowDatas1[indexPath.row]
            let cell : KRSwapInfoTC = tableView.dequeueReusableCell(withIdentifier: "KRSwapInfoTC") as! KRSwapInfoTC
            let time = BTFormat.timeOnlyDate(fromDateStr: entity.timestamp.stringValue) ?? "-"
            let qty = (entity.qty ?? "-") + (self.itemModel?.contractInfo.margin_coin ?? "-")
            cell.contentLabel.setLeftText(time)
            cell.contentLabel.setRightText(qty)
            return cell
        case .FundingRate:
            let entity = tableViewRowDatas1[indexPath.row]
            let cell : KRSwapFundRateTC = tableView.dequeueReusableCell(withIdentifier: "KRSwapFundRateTC") as! KRSwapFundRateTC
            cell.setFundRateCell(entity)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if vcType == .FundingRate || vcType == .InsuranceFund {
            return self.headeV
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if vcType == .FundingRate || vcType == .InsuranceFund {
            return 30
        }
        return 0
    }
}

extension KRSwapInfoVc {
    func loadData() {
        if vcType == .baseSwapInfo {
            updateBaseInfo()
        } else if vcType == .InsuranceFund {
            updateInsuranceFund()
        } else if vcType == .FundingRate {
            requestFundRate()
        }
    }
    
    private func updateBaseInfo() {
        guard let entity = self.itemModel else {
            return
        }
        let coinName = entity.contractInfo.base_coin ?? "--"
        let marginName = entity.contractInfo.margin_coin ?? "--"
        let type = (entity.contractInfo.is_reverse) ? "反向合约".localized() : "正向合约".localized()
        let size = String(format: "每张%@%@", entity.contractInfo.face_value ?? "--", entity.contractInfo.price_coin ?? "--")
        let level = String(format: "%@%@", entity.contractInfo.leverageArr.first ?? "--", "倍".localized())
        let position = (entity.position_size as NSString).toSmallVolume(withContractID: entity.instrument_id) ?? "--"
        let deaalQty = BTFormat.totalVolume(fromNumberStr: (entity.qty24 as NSString).toSmallVolume(withContractID: entity.instrument_id)) ?? "--"
        let turnover = (((entity.qty24 as NSString).bigDiv(entity.position_size) as NSString)).toSmallVolume(withContractID: entity.instrument_id) ?? "--"
        let risk_fund = (entity.risk_revers_vol?.toSmallValue(withContract: entity.instrument_id) ?? "--")+entity.contractInfo.margin_coin
        let fundRate = entity.funding_rate?.toPercentString(4) ?? "-"
        BTMaskFutureTool.getIndexesInfo(withIndexId: entity.contractInfo.index_id , success: {[weak self] (res) in
            let baseInfoArr = [KRSwapInfoEntity.init("合约基础币种".localized(), coinName),
                               KRSwapInfoEntity.init("保证金币种".localized(), marginName),
                               KRSwapInfoEntity.init("合约属性".localized(), type),
                               KRSwapInfoEntity.init("合约大小".localized(), size),
                               KRSwapInfoEntity.init("最高杠杆".localized(), level),
                               KRSwapInfoEntity.init("指数信息".localized(), res ?? "--"),
                               KRSwapInfoEntity.init("总持仓量".localized(), position),
                               KRSwapInfoEntity.init("成交量".localized(), deaalQty),
                               KRSwapInfoEntity.init("换手比".localized(), turnover),
                               KRSwapInfoEntity.init("保险基金".localized(), risk_fund, true),
                               KRSwapInfoEntity.init("资金费率".localized(), fundRate, true),
                               ]
            self?.tableViewRowDatas = baseInfoArr
            self?.tableView.reloadData()
        }) { (error) in
        }
    }
    
    // 保险基金
    private func updateInsuranceFund() {
        guard let entity = self.itemModel else {
            return
        }
        BTContractTool.getRiskReserves(withContractID: entity.instrument_id, success: { (result: [Any]?) in
            guard let dateArr = result as? Array<BTIndexDetailModel> else {
                return
            }
            self.tableViewRowDatas1 = dateArr
            self.tableView.reloadData()
        }) { (error) in
        }
    }
    
    // 资金费率
    private func requestFundRate() {
        guard let instrument_id = self.itemModel?.instrument_id else {
            return
        }
        BTContractTool.getFundingrateWithContractID(instrument_id, success: { (result: Any?) in
            guard let dateArr = result as? Array<BTIndexDetailModel> else {
                return
            }
            self.tableViewRowDatas1 = dateArr
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
}
