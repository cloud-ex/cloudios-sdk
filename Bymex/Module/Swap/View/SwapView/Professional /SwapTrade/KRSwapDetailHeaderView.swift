//
//  KRSwapDetailHeaderView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  历史委托详情 - 顶部视图

import Foundation

class KRSwapDetailHeaderView : UIView {
    /// 点击明细回调
    var showDetailCallback: ((BTContractOrderModel, KRSwapTransactionDetailType) -> ())?
    weak var entity: BTContractOrderModel?
    /// 多 空 类型
    lazy var typeLabel: UILabel = {
        let object = UILabel(text: nil, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .center)
        object.extSetCornerRadius(2)
        return object
    }()
    /// 合约名称
    lazy var nameLabel: UILabel = {
        let object = UILabel(text: nil, font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    lazy var detailBtn : KRTipBtn = {
        let object = KRTipBtn()
        object.titleLabel.font = UIFont.ThemeFont.BodyRegular
        object.setTitle("--")
        object.layoutBottomLine()
        object.clickShowTipBlock = {[weak self] in
            guard let mySelf = self,
                let itemModel = mySelf.entity,
                let detailType = KRSwapSDKManager.shared.getDetailType(itemModel)
                else {return}
            mySelf.showDetailCallback?(itemModel,detailType)
        }
        object.isHidden = true
        return object
    }()
    /// 成交均价
    lazy var dealAverageView: KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("成交均价".localized())
        return object
    }()
    /// 成交数量
    lazy var dealVolumeView: KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("成交数量".localized() + " (\("张".localized()))")
        object.contentAlignment = .center
        return object
    }()
    /// 手续费
    lazy var withDrawView: KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.contentAlignment = .right
        object.setTopText("手续费".localized())
        return object
    }()
    lazy var bottomLine:UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubViews([typeLabel, nameLabel, dealAverageView, dealVolumeView, withDrawView,bottomLine,detailBtn])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        self.typeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(18)
            make.height.equalTo(16)
            make.top.equalTo(18)
            make.width.equalTo(30)
        }
        self.nameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.typeLabel.snp_right).offset(4)
            make.height.equalTo(19)
            make.centerY.equalTo(self.typeLabel)
        }
        self.detailBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameLabel.snp_right).offset(4)
            make.height.equalTo(16)
            make.centerY.equalTo(self.typeLabel)
            make.width.lessThanOrEqualTo(100)
        }
        self.dealAverageView.snp_makeConstraints { (make) in
            make.left.equalTo(self.typeLabel)
            make.top.equalTo(self.typeLabel.snp_bottom).offset(30)
            make.height.equalTo(32)
        }
        self.dealVolumeView.snp_makeConstraints { (make) in
            make.top.height.equalTo(self.dealAverageView)
            make.centerX.equalToSuperview()
        }
        self.withDrawView.snp_makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.height.equalTo(self.dealAverageView)
        }
        self.bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    
    func updateView(model: BTContractOrderModel) {
        self.entity = model
        var color = UIColor.ThemekLine.up
        var typeStr = "开多".localized()
        if model.side == .sell_OpenShort {
            color = UIColor.ThemekLine.down
            typeStr = "开空".localized()
        } else if model.side == .buy_CloseShort {
            color = UIColor.ThemekLine.up
            typeStr = "平空".localized()
        } else if model.side == .sell_CloseLong {
            color = UIColor.ThemekLine.down
            typeStr = "平多".localized()
        }
        
        self.typeLabel.backgroundColor = color
        self.typeLabel.text = typeStr
        self.nameLabel.text = model.name ?? "--"
        let detailType = KRSwapSDKManager.shared.getDetailType(model)
        if detailType == .force {
            self.detailBtn.isHidden = false
            self.detailBtn.setTitle("强平明细".localized())
        } else if detailType == .reduce {
            self.detailBtn.isHidden = false
            self.detailBtn.setTitle("减仓明细".localized())
        }
        if model.avg_px != nil {
            self.dealAverageView.setBottomText(model.avg_px.toSmallPrice(withContractID:model.instrument_id))
        } else {
            self.dealAverageView.setBottomText("--")
        }
        self.dealVolumeView.setBottomText(model.cum_qty ?? "--")
        
        // 手续费
        var fee = "0"
        let make_fee = ((model.make_fee ?? "0").contains("-") ? ((model.make_fee ?? "0").extStringSub(NSRange.init(location: 1, length: (model.make_fee ?? "0").kr_length - 1)) ) :  model.make_fee ?? "0")
        fee = (model.take_fee != nil && model.take_fee != "0") ? String(format: "%f", KRBasicParameter.handleDouble(model.take_fee ?? "0")) : String(format: "%f", KRBasicParameter.handleDouble(make_fee))
        
        self.withDrawView.setBottomText(fee)
    }
}

class KRSwapDetailFooterView : KRBaseV {
    lazy var titleLabel: UILabel = {
        let object = UILabel(text: nil, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        object.text = "取消原因".localized()
        return object
    }()
    /// 合约名称
    lazy var detailLabel: UILabel = {
        let object = UILabel(text: nil, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .right)
        object.numberOfLines = 0
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([titleLabel,detailLabel])
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(100)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(240)
            make.height.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
