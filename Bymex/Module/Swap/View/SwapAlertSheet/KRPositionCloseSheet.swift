//
//  KRPositionCloseSheet.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/27.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRPositionCloseSheet: KRSwapBaseSheet {
    
    /// 平仓回调
    var closePositionCallback: ((Bool) -> ())?
    
    var positionM : BTPositionModel? {
        didSet {
            if positionM != nil {
                self.pxInput.input.text = positionM!.lastPrice ?? ""
                self.qtyInput.input.text = positionM!.cur_qty ?? ""
                if positionM!.contractInfo.px_unit.kr_length > 3 {
                    let decimal = String(positionM!.contractInfo.px_unit.kr_length - 3)
                    pxInput.decimal = decimal
                } else {
                    pxInput.decimal = ""
                }
            }
        }
    }
    
    lazy var pxInput : KRLineField = {
        let object = KRLineField.init(frame: CGRect.init(x: 16, y: 0, width: SCREEN_WIDTH - 32, height: 56), lineFieldType: .baseLine)
        object.titleLabel.text = "委托价格".localized()
        object.input.placeholder = "请输入委托价格".localized()
        object.input.keyboardType = .decimalPad
        object.extraLabel.text = "USDT"
        return object
    }()
    lazy var qtyInput : KRLineField = {
        let object = KRLineField.init(frame: CGRect.init(x: 16, y: 0, width: SCREEN_WIDTH - 32, height: 56), lineFieldType: .baseLine)
        object.titleLabel.text = "委托数量".localized()
        object.input.placeholder = "请输入委托数量".localized()
        object.input.keyboardType = .decimalPad
        object.extraLabel.text = "USDT"
        object.decimal = "0"
        return object
    }()
    lazy var levelSlider : KRPercentSlider = {
        let object = KRPercentSlider(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 50), maxLevel: 100)
        object.updateSliderValue(value:100)
        return object
    }()
    
    lazy var marketCloseBtn : KRFrameBtn = {
        let object = KRFrameBtn()
        object.extSetTitle("市价全平".localized(), 14, UIColor.ThemeLabel.colorHighlight, .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            self?.marketPxClosePosition()
        }).disposed(by: disposeBag)
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        contentView.addSubViews([pxInput,qtyInput,levelSlider])
        addSubview(marketCloseBtn)
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(210)
        }
        pxInput.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(SCREEN_WIDTH - 32)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(56)
        }
        qtyInput.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(pxInput)
            make.top.equalTo(pxInput.snp.bottom)
        }
        levelSlider.snp.makeConstraints { (make) in
            make.left.right.equalTo(pxInput)
            make.height.equalTo(50)
            make.top.equalTo(qtyInput.snp.bottom).offset(30)
        }
        marketCloseBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(contentView.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-TABBAR_BOTTOM-10)
        }
        submitBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(marketCloseBtn.snp.right).offset(15)
            make.top.width.height.equalTo(marketCloseBtn)
            make.right.equalToSuperview().offset(-16)
        }
        nameLabel.text = "平仓".localized()
        submitBtn.setTitle("限价平仓", for: .normal)
        
        self.levelSlider.valueChangedCallback = {[weak self] value in
            guard let position = self?.positionM  else {
                return
            }
            self?.qtyInput.input.text = String(format: "%d", value).bigDiv("100").bigMul(position.cur_qty).toString(0)
        }
    }
    
    // 点击限价平仓
    override func clickSubmitBtn(_ sender: EXButton) {
        guard let entity = positionM else {
            return
        }
        guard let qty = qtyInput.input.text, qty.length > 0,let px = pxInput.input.text,px.length > 0 else {
            return
        }
        if qty.greaterThan(entity.cur_qty.bigSub(entity.freeze_qty)) {// 先取消对应的委托单
            guard let entrustOrders = SLFormula.getCloseEntrustOrder(withPosition: entity) as? [BTContractOrderModel] else {
                return
            }
            handleCancelAllEntrustOrders(entrustOrders, qty, .normal, px)
        } else {
            handleCloseOrder(price: px, volume: qty, category: .normal)
        }
    }
    
    // 点击市价全平
    func marketPxClosePosition() {
        guard let entity = positionM else {
            return
        }
        guard let qty = qtyInput.input.text, qty.length > 0 else {
            return
        }
        if qty.greaterThan(entity.cur_qty.bigSub(entity.freeze_qty)) {// 先取消对应的委托单
            guard let entrustOrders = SLFormula.getCloseEntrustOrder(withPosition: entity) as? [BTContractOrderModel] else {
                return
            }
            handleCancelAllEntrustOrders(entrustOrders, qty, .market, "")
        } else {
            handleCloseOrder(price: "", volume: qty, category: .market)
        }
    }
}

extension KRPositionCloseSheet {
    func handleCancelAllEntrustOrders(_ entrustOrders : [BTContractOrderModel],_ volume:String,_ category:BTContractOrderCategory,_ px: String) {
        BTContractTool.cancelContractOrders(entrustOrders, contractOrderType: .defineContractClose, assetPassword: nil, success: {[weak self] (number) in
            if category == .market {
                let newprice = BTMaskFutureTool.marketPrice(withContractID: self?.positionM!.instrument_id ?? 0) ?? "0"
                self?.handleCloseOrder(price: newprice, volume: volume, category: .market)
            } else {
                self?.handleCloseOrder(price: px, volume: volume, category: .normal)
            }
        }) { (error) in
        }
    }
    
    func handleCloseOrder(price:String,volume:String, category:BTContractOrderCategory) {
        if price.lessThanOrEqual(BT_ZERO) && category != .market {
            EXAlert.showFail(msg: "价格不能为0")
            return
        }
        if volume.lessThanOrEqual(BT_ZERO) {
            EXAlert.showFail(msg: "数量不能为0")
            return
        }
        var way : BTContractOrderWay
        if self.positionM!.side == .openMore {
            way = .sell_CloseLong
        } else {
            way = .buy_CloseShort
        }
        let orderModel = BTContractOrderModel.newContractCloseOrder(withContractId: self.positionM!.instrument_id, category: category, way: way, positionID: self.positionM!.pid, price: price, vol: volume)
        orderModel!.position_type = self.positionM!.position_type
        BTContractTool.sendContractsOrder(orderModel!, contractOrderType: .defineContractClose, assetPassword: nil, success: {[weak self] (oid) in
            self?.closePositionCallback?(true)
        }) {[weak self] (error) in
            self?.closePositionCallback?(false)
            guard let errStr = error as? String else {
                EXAlert.showFail(msg: "平仓失败")
                return
            }
            EXAlert.showFail(msg: errStr)
        }
    }
}
