//
//  KRDetailTransactionTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

/// 历史委托详情 cell
class KRDetailTransactionTC : UITableViewCell {
    var contractInfo: BTContractsModel?
    
    /// 成交时间
    lazy var dealTimeView: KRHorDetailLabel = {
        let view = KRHorDetailLabel()
        view.setLeftText("成交时间".localized())
        return view
    }()
    /// 成交价格
    lazy var dealPriceView: KRHorDetailLabel = {
        let view = KRHorDetailLabel()
        view.setLeftText("成交价格".localized())
        return view
    }()
    /// 成交数量
    lazy var dealVolumeView : KRHorDetailLabel = {
        let view = KRHorDetailLabel()
        view.setLeftText("成交数量".localized())
        return view
    }()
    /// 成交金额
    lazy var dealMoneyView : KRHorDetailLabel = {
        let view = KRHorDetailLabel()
        view.setLeftText("成交金额".localized())
        return view
    }()
    /// 手续费
    lazy var withDrawView: KRHorDetailLabel = {
        let view = KRHorDetailLabel()
        view.setLeftText("手续费".localized())
        return view
    }()
    /// 分割线
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        self.contentView.addSubViews([self.dealTimeView, self.dealPriceView, self.dealVolumeView, self.dealMoneyView, self.withDrawView, self.lineView])
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        self.dealTimeView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(14)
            make.top.equalTo(17)
        }
        self.dealPriceView.snp_makeConstraints { (make) in
            make.left.right.height.equalTo(self.dealTimeView)
            make.top.equalTo(self.dealTimeView.snp_bottom).offset(14)
        }
        self.dealVolumeView.snp_makeConstraints { (make) in
            make.left.right.height.equalTo(self.dealTimeView)
            make.top.equalTo(self.dealPriceView.snp_bottom).offset(14)
        }
        self.dealMoneyView.snp_makeConstraints { (make) in
            make.left.right.height.equalTo(self.dealTimeView)
            make.top.equalTo(self.dealVolumeView.snp_bottom).offset(14)
        }
        self.withDrawView.snp_makeConstraints { (make) in
            make.left.right.height.equalTo(self.dealTimeView)
            make.top.equalTo(self.dealMoneyView.snp_bottom).offset(14)
        }
        self.lineView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Update Data
    
    func updateCell(model: BTContractTradeModel) {
        self.dealTimeView.setRightText(BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: model.created_at), format: "yyyy-MM-dd HH:mm"))
        self.dealPriceView.setRightText(model.px.toSmallPrice(withContractID:model.instrument_id))
        self.dealVolumeView.setRightText(model.qty.toSmallVolume(withContractID:model.instrument_id))
        // 计算合约价值
        if self.contractInfo != nil {
            let money = SLFormula.calculateContractValue(withVol: model.qty, price: model.px, contract: self.contractInfo!)
            self.dealMoneyView.setRightText(money)
        } else {
            self.dealMoneyView.setRightText("--")
        }
        // 手续费
        var fee = "0"
        let make_fee = (model.make_fee.contains("-") ? (model.make_fee.extStringSub(NSRange.init(location: 1, length: model.make_fee.kr_length - 1))) :  model.make_fee) ?? "0"
        fee = (model.take_fee != nil && model.take_fee != "0") ? String(format: "%f", KRBasicParameter.handleDouble(model.take_fee!)) : String(format: "%f", KRBasicParameter.handleDouble(make_fee))
        
        self.withDrawView.setRightText(fee)
    }
    
    func updataForceCell() {
        self.dealPriceView.setRightText("--")
        self.dealMoneyView.setRightText("--")
    }
}
