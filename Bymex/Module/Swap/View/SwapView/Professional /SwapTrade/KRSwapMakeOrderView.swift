//
//  KRSwapMakeOrderView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/24.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  下单区域

import Foundation
import SnapKitExtend
import RxSwift

class KRSwapMakeOrderView: KRBaseV {
    typealias FrameChangeBlock = (Int) -> ()
    var frameChangeBlock : FrameChangeBlock?
    let makerOrderVM = KRSwapMakeOrderVM()
    lazy var moreOrEmptyView : UISegmentedControl = {
        let object = UISegmentedControl.init(titles: ["开多".localized(),"开空".localized()])
        _ = object.rx.value.asObservable()
            .subscribe(onNext: { [weak self] tag in
                if self?.makerOrderVM.direction == 1001 {
                    self?.makerOrderVM.orderSide = (tag == 0) ? .buy_OpenLong : .sell_OpenShort
                } else {
                    self?.makerOrderVM.orderSide = (tag == 0) ? .sell_CloseLong : .buy_CloseShort
                }
                // 刷新界面
                self?.moreOrEmptySegment()
                // 刷新数据
                self?.refreshData()
            }).disposed(by: disposeBag)
        return object
    }()
    // 委托类型(限价、高级、计划)
    lazy var orderTypeBtn : KRDirectionButton = {
        let object = KRDirectionButton()
        object.extUseAutoLayout()
        object.addTarget(self, action: #selector(clickOrderTypeBtn), for: .touchUpInside)
        object.titleLabel.text = "限价".localized()
        return object
    }()
    // 高级限价类型(只做Maker、Lok、foc)
    lazy var highOrderTypeBtn : KRDirectionButton = {
        let object = KRDirectionButton()
        object.extUseAutoLayout()
        object.setAlighment(margin: .marginRight)
        object.addTarget(self, action: #selector(clickHighOrderTypeBtn), for: .touchUpInside)
        object.titleLabel.text = "只做maker".localized()
        object.isHidden = true
        return object
    }()
    lazy var priceInput : KRBorderField = {
        let object = KRBorderField()
        object.decimalType = .coin
        object.setPlaceHolder(placeHolder: "价格".localized(), font: 16)
        object.textfieldValueChangeBlock = {[weak self]str in
             guard let mySelf = self else{return}
             mySelf.textFieldValueHasChanged(textField: object.input)
        }
        object.input.rx.text.orEmpty.changed.asObservable().subscribe {(event) in
            if let str = event.element{
                if str.count > 15{
                    object.input.text = str[0...12]
                }
            }
        }.disposed(by: self.disposeBag)
        return object
    }()
    lazy var pxTypeV : UIView = {
        let object = UIView()
        return object
    }()
    var pxTypeItems : [KRFlatBtn] = {
        var objects:[KRFlatBtn]  = []
        let titles = ["市价".localized(),"买一价".localized(),"卖一价".localized()];
        for idx in 0..<titles.count {
            let title = titles[idx]
            let item = KRFlatBtn()
            item.tag = idx
            item.extSetTitle(title, 14, UIColor.ThemeLabel.colorMedium,UIColor.ThemeLabel.colorHighlight)
            item.setTitleColor(UIColor.extColorWithHex("5A5A5A"), for: .disabled)
            item.extSetAddTarget(self, #selector(clickPriceTypeItem))
            objects.append(item)
        }
        return objects
    }()
    lazy var pxTypeLabel : KRSpaceLabel = {
        let object = KRSpaceLabel.init(text: "市价单".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        object.showTapLabel()
        object.isHidden = true
        return object
    }()
    lazy var performInput : KRPerformInputView = {
        let object = KRPerformInputView()
        object.performInput.decimalType = .coin
        object.performMarketBtn.extSetAddTarget(self, #selector(clickPerformMarket))
        object.performInput.textfieldValueChangeBlock = {[weak self]str in
             guard let mySelf = self else{return}
            mySelf.textFieldValueHasChanged(textField: object.performInput.input)
        }
        object.performInput.input.rx.text.orEmpty.changed.asObservable().subscribe {(event) in
            if let str = event.element{
                if str.count > 15{
                    object.performInput.input.text = str[0...12]
                }
            }
        }.disposed(by: self.disposeBag)
        object.isHidden = true
        return object
    }()
    lazy var qtyInput : KRBorderField = {
        let object = KRBorderField()
        object.decimal = "0"
        object.unitLabel.text = "张".localized()
        object.setPlaceHolder(placeHolder: "数量".localized(), font: 16)
        object.textfieldValueChangeBlock = {[weak self]str in
             guard let mySelf = self else{return}
             mySelf.textFieldValueHasChanged(textField: object.input)
        }
        object.input.rx.text.orEmpty.changed.asObservable().subscribe {(event) in
            if let str = event.element{
                if str.count > 15{
                    object.input.text = str[0...12]
                }
            }
        }.disposed(by: self.disposeBag)
        return object
    }()
    lazy var equalLabel : UILabel = {
        let object = UILabel.init(text: "≈ 0", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    // 百分比
    lazy var percentageV : UIView = {
        let object = UIView()
        return object
    }()
    lazy var percentageItems: [KRFlatBtn] = {
        var objects:[KRFlatBtn]  = []
        let titles = ["25%","50%","75%","100%"];
        for idx in 0..<titles.count {
            let title = titles[idx]
            let item = KRFlatBtn()
            item.tag = idx
            item.extSetTitle(title, 14, UIColor.ThemeLabel.colorMedium,UIColor.ThemeLabel.colorHighlight)
            item.extSetAddTarget(self, #selector(clickPercentageItem))
            objects.append(item)
        }
        return objects
    }()
    lazy var percentLabel : KRSpaceLabel = {
        let object = KRSpaceLabel.init(text: "".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        object.showTapLabel()
        object.isHidden = true
        return object
    }()
    lazy var mostOpenV : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("最大可开".localized())
        object.rightLabel.extSetTextColor( UIColor.ThemeLabel.colorMedium, fontSize: 12)
        return object
    }()
    lazy var orderValueV : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("委托价值".localized())
        object.rightLabel.extSetTextColor( UIColor.ThemeLabel.colorMedium, fontSize: 12)
        return object
    }()
    lazy var costV : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("成本".localized())
        object.rightLabel.extSetTextColor( UIColor.ThemeLabel.colorMedium, fontSize: 12)
        return object
    }()
    lazy var balanceV : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("可用".localized())
        object.rightLabel.extSetTextColor( UIColor.ThemeLabel.colorMedium, fontSize: 12)
        return object
    }()
    // 开多按钮
    lazy var takeOrderBtn : EXButton = {
        let btn = EXButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickTakeOrderBtn))
        btn.setTitle("开多".localized(), for: .normal)
        btn.titleLabel?.font = UIFont.ThemeFont.HeadRegular
        btn.color = UIColor.ThemekLine.up
        btn.highlightedColor = UIColor.ThemekLine.up.overlayWhite()
        return btn
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([moreOrEmptyView,orderTypeBtn,highOrderTypeBtn,
                     priceInput,pxTypeV,performInput,qtyInput,equalLabel,
                     percentageV,mostOpenV,orderValueV,costV,balanceV,takeOrderBtn,
                     pxTypeLabel,percentLabel])
        pxTypeV.addSubViews(pxTypeItems)
        percentageV.addSubViews(percentageItems)
        initLayout()
    }
    
    override func onCreat() {
        makerOrderVM.setMakeOrderV(self)
        _ = makerOrderVM.directionSubject.asObserver().subscribe(onNext: {[weak self] (tag) in
            self?.makerOrderVM.direction = tag
            // 改变界面
            self?.refreshDirection()
            // 刷新数据
            self?.refreshData()
        }).disposed(by: self.disposeBag)
        
        pxTypeLabel.clickLabelBlock = { [weak self] in
            if self?.makerOrderVM.orderType == .limit {
                self?.makerOrderVM.limitType = .limitPx
            } else if self?.makerOrderVM.orderType == .highLimit {
                self?.makerOrderVM.limitType = .limitPx
            }
            self?.pxTypeLabel.isHidden = true
            self?.priceInput.input.becomeFirstResponder()
            self?.clearPxTypeItems(-1)
            self?.refreshData()
        }
        percentLabel.clickLabelBlock = { [weak self] in
            self?.percentLabel.isHidden = true
            self?.qtyInput.input.becomeFirstResponder()
            self?.qtyInput.input.text = ""
            self?.clearPercentageItems(-1)
            self?.refreshData()
        }
    }
    
    func handleSelectedPrice(_ entity: SLOrderBookModel) {
        if self.makerOrderVM.orderType == .limit {
            self.clearPxTypeItems(-1)
            self.pxTypeLabel.isHidden = true
            self.makerOrderVM.limitType = .limitPx
            self.priceInput.input.text = entity.px
        } else if self.makerOrderVM.orderType == .highLimit {
            self.clearPxTypeItems(-1)
            self.pxTypeLabel.isHidden = true
            self.makerOrderVM.limitType = .limitPx
            self.priceInput.input.text = entity.px
        } else if self.makerOrderVM.orderType == .plan {
            self.priceInput.input.text = entity.px
        }
        refreshData()
    }
}

//MARK:-refreshDate
extension KRSwapMakeOrderView {
    
    // 刷新单位
    func refreshUnit() {
        guard let entity = makerOrderVM.itemModel else {return}
        if entity.contractInfo.px_unit.kr_length > 3 {
            priceInput.decimal = String(entity.contractInfo.px_unit.kr_length - 3)
            performInput.performInput.decimal = String(entity.contractInfo.px_unit.kr_length - 3)
        } else {
            priceInput.decimal = "0"
            performInput.performInput.decimal = "0"
        }
        
        priceInput.unitLabel.text = makerOrderVM.priceUnit
        qtyInput.unitLabel.text = makerOrderVM.volumeUnit
        if makerOrderVM.isCoin {
            qtyInput.decimal = "8"
        } else {
            qtyInput.decimal = "0"
        }
        refreshData()
    }
    
    // 刷新下单订单信息
    func refreshData() {
        if percentLabel.isHidden == false && (percentLabel.text?.kr_length ?? 0) > 0 {
            let per = percentLabel.text?.extStringSub(NSRange.init(location: 0, length: percentLabel.text!.kr_length - 1)) ?? "0"
            getPercentValue(per.bigDiv("100"))
        }
        
        makerOrderVM.createOrder(px: self.priceInput.input.text ?? "0",
                                      qty: self.qtyInput.input.text ?? "0",
                                      performPx: self.performInput.performInput.input.text ?? "0")
        guard let order = makerOrderVM.currentOrder else {
            return
        }
        switch makerOrderVM.orderSide {
        case .buy_OpenLong,.sell_OpenShort:
            if makerOrderVM.orderSide == .buy_OpenLong {
                self.mostOpenV.setRightText(self.makerOrderVM.canOpenMore+" "+self.makerOrderVM.volumeUnit!)
            } else {
                self.mostOpenV.setRightText(self.makerOrderVM.canOpenShort+" "+self.makerOrderVM.volumeUnit!)
            }
            self.orderValueV.setRightText(order.avai.toSmallValue(withContract: order.instrument_id)+" "+self.makerOrderVM.costUnit)
            self.costV.setRightText((order.freezAssets.toSmallValue(withContract: order.instrument_id) ?? "0")+" "+self.makerOrderVM.costUnit)
            self.balanceV.setRightText((self.makerOrderVM.canUseAmount ?? "0")+" "+self.makerOrderVM.costUnit)
        case .buy_CloseShort:
            self.mostOpenV.setRightText(self.makerOrderVM.canCloseShort+" "+self.makerOrderVM.volumeUnit!)
            self.orderValueV.setRightText(self.makerOrderVM.holdShortNum+" "+self.makerOrderVM.volumeUnit!)
        case .sell_CloseLong:
            self.mostOpenV.setRightText(self.makerOrderVM.canCloseMore+" "+self.makerOrderVM.volumeUnit!)
            self.orderValueV.setRightText(self.makerOrderVM.holdMoreNum+" "+self.makerOrderVM.volumeUnit!)
        default:
            break
        }
    }
    
    func textFieldValueHasChanged(textField:UITextField) {
        guard let swapInfo = makerOrderVM.itemModel?.contractInfo else {
            return
        }
        if textField == priceInput.input {
//            let px = priceInput.input.text ?? "0"
//            px = px.forDecimals((swapInfo.px_unit ?? "0").bigMul("10")) // 价格输入精度比返回的少一位
//            priceInput.input.text = px;
        } else if textField == performInput.performInput.input {
//            let px = performInput.performInput.input.text ?? "0"
//            px = px.forDecimals((swapInfo.px_unit ?? "0").bigMul("10")) // 价格精度少一位
//            performInput.performInput.input.text = px;
        } else if textField == qtyInput.input {
//            let qty = self.qtyInput.input.text ?? "0"
//            if makerOrderVM.isCoin {
//                let arr = qty.components(separatedBy: ".")
//                let qty_decimal = (swapInfo.value_unit ?? "0.1").kr_length - 2
//                if arr.count == 2 && arr[1].kr_length > qty_decimal {
//                    qty = arr[0] + "." + arr[1].extStringSub(NSRange.init(location: 0, length: qty_decimal))
//                    self.qtyInput.input.text = qty
//                }
//            }
//            self.qtyInput.input.text = qty
        }
        var price = BT_ZERO
        var vol = self.qtyInput.input.text ?? BT_ZERO
        var amount = BT_ZERO;
        switch makerOrderVM.orderType {
        case .limit,.highLimit:
            if makerOrderVM.limitType == .limitPx {
                price = priceInput.input.text ?? BT_ZERO
            } else if makerOrderVM.limitType == .bidPx {
                price = makerOrderVM.bids?.first?.px ?? BT_ZERO
            } else if makerOrderVM.limitType == .askPx {
                price = makerOrderVM.asks?.first?.px ?? BT_ZERO
            } else {
                price = makerOrderVM.itemModel?.last_px ?? BT_ZERO
            }
        case .plan:
            if makerOrderVM.planType == .limitPlan {
                price = performInput.performInput.input.text ?? BT_ZERO
            } else {
                price = priceInput.input.text ?? BT_ZERO
            }
        }
        if makerOrderVM.isCoin {
            vol = SLFormula.coin(toTicket: vol, price: price, contract: swapInfo)
            amount = vol
            equalLabel.text = "≈ " + amount + "张".localized()
        } else {
            amount = SLFormula.calculateContractBasicValue(withPrice: price, vol: vol, contract: swapInfo)
            equalLabel.text = "≈ " + amount + swapInfo.base_coin
        }
        refreshData()
    }
}

//MARK:- layout
extension KRSwapMakeOrderView {
    func initLayout() {
        moreOrEmptyView.snp.makeConstraints { (make) in
            make.left.equalTo(2)
            make.right.equalTo(-2)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(28)
        }
        orderTypeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(moreOrEmptyView.snp.bottom).offset(12)
            make.height.equalTo(18)
            make.width.lessThanOrEqualTo(100)
        }
        highOrderTypeBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.height.equalTo(orderTypeBtn)
            make.left.equalTo(orderTypeBtn.snp.right).offset(10)
        }
        priceInput.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(orderTypeBtn.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        pxTypeLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(priceInput)
        }
        pxTypeV.snp.makeConstraints { (make) in
            make.left.right.equalTo(priceInput)
            make.height.equalTo(24)
            make.top.equalTo(priceInput.snp_bottom).offset(12)
        }
        // plan
        performInput.snp.makeConstraints { (make) in
            make.left.equalTo(priceInput)
            make.top.equalTo(pxTypeV.snp.bottom).offset(12)
            make.height.equalTo(40)
            make.right.equalToSuperview()
        }
        qtyInput.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(priceInput)
            make.top.equalTo(pxTypeV.snp_bottom).offset(12)
        }
        percentLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(qtyInput)
        }
        equalLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.height.equalTo(17)
            make.top.equalTo(qtyInput.snp_bottom).offset(4)
        }
        percentageV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(pxTypeV)
            make.top.equalTo(equalLabel.snp_bottom).offset(12)
        }
        mostOpenV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(16)
            make.top.equalTo(percentageV.snp_bottom).offset(12)
        }
        orderValueV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(mostOpenV)
            make.top.equalTo(mostOpenV.snp.bottom).offset(4)
        }
        costV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(mostOpenV)
            make.top.equalTo(orderValueV.snp.bottom).offset(4)
        }
        balanceV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(mostOpenV)
            make.top.equalTo(costV.snp.bottom).offset(4)
        }
        takeOrderBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(balanceV.snp.bottom).offset(12)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-16)
        }
        pxTypeItems.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 10, leadSpacing: 0, tailSpacing: 0)
        pxTypeItems.snp.makeConstraints{
            $0.centerY.equalTo(pxTypeV)
            $0.height.equalTo(24)
        }
        percentageItems.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 10, leadSpacing: 0, tailSpacing: 0)
        percentageItems.snp.makeConstraints{
            $0.centerY.equalTo(percentageV)
            $0.height.equalTo(24)
        }
    }
    
    func refreshDirection() {
        if self.makerOrderVM.direction == 1001 {
            moreOrEmptyView.setTitles(["开多".localized(),"开空".localized()])
            makerOrderVM.orderSide = (moreOrEmptyView.selectedSegmentIndex == 0) ? .buy_OpenLong : .sell_OpenShort
            mostOpenV.setLeftText("最大可开".localized())
            orderValueV.setLeftText("委托价值".localized())
            costV.isHidden = false
            balanceV.isHidden = false
            takeOrderBtn.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(balanceV.snp.bottom).offset(12)
                make.height.equalTo(44)
                make.bottom.equalToSuperview().offset(-16)
            }
        } else {
            self.moreOrEmptyView.setTitles(["平多".localized(),"平空".localized()])
            self.mostOpenV.setLeftText("最大可平".localized())
            self.orderValueV.setLeftText("持仓".localized())
            makerOrderVM.orderSide = (moreOrEmptyView.selectedSegmentIndex == 0) ? .sell_CloseLong : .buy_CloseShort
            costV.isHidden = true
            balanceV.isHidden = true
            var offset = -16
            if makerOrderVM.orderType == .limit || makerOrderVM.orderType == .highLimit {
                offset = -56
            }
            takeOrderBtn.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(orderValueV.snp.bottom).offset(12)
                make.height.equalTo(44)
                make.bottom.equalToSuperview().offset(offset)
            }
        }
        self.moreOrEmptySegment()
    }
    
    func refreshLayout() {
        switch makerOrderVM.orderType {
        case .limit,.highLimit:
            refreshPxTypeItems(0)
            if makerOrderVM.orderType == .limit {
                highOrderTypeBtn.isHidden = true
                pxTypeItems.first?.isEnabled = true
            } else {
                highOrderTypeBtn.isHidden = false
                pxTypeItems.first?.isEnabled = false
            }
        case .plan:
            pxTypeItems.first?.isEnabled = true
            refreshPxTypeItems(1)
            break
        }
    }
    
    func refreshPxTypeItems(_ type : Int) {
        pxTypeLabel.isHidden = true
        if type == 0 {
            let titles = ["市价".localized(),"买一价".localized(),"卖一价".localized()]
            for (idx,item) in pxTypeItems.enumerated() {
                if item.titleLabel?.text == titles[idx] {
                    return
                }
                item.isSelected = false
                item.setTitle(titles[idx], for: .normal)
            }
            performInput.isHidden = true
            qtyInput.snp.remakeConstraints { (make) in
                make.left.right.height.equalTo(priceInput)
                make.top.equalTo(pxTypeV.snp.bottom).offset(12)
            }
            if makerOrderVM.direction == 1002 {
                takeOrderBtn.snp.updateConstraints { (make) in
                   make.bottom.equalToSuperview().offset(-56)
                }
            }
        } else {
            let titles = ["最新价".localized(),"合理价".localized(),"指数价".localized()]
            var currentIdx = 0
            switch makerOrderVM.tiggerType {
            case .tradePriceType:
                currentIdx = 0
            case .markPriceType:
                currentIdx = 1
            case .indexPriceType:
                currentIdx = 2
            default:
                break
            }
            for (idx,item) in pxTypeItems.enumerated() {
                if item.titleLabel?.text == titles[idx] {
                    return
                }
                item.isSelected = false
                item.setTitle(titles[idx], for: .normal)
                if currentIdx == idx {
                    item.isSelected = true
                }
            }
            performInput.isHidden = false
            qtyInput.snp.remakeConstraints { (make) in
                make.left.right.height.equalTo(priceInput)
                make.top.equalTo(performInput.snp.bottom).offset(12)
            }
            if makerOrderVM.direction == 1002 {
                takeOrderBtn.snp.updateConstraints { (make) in
                    make.bottom.equalToSuperview().offset(-16)
                }
            }
        }
    }
    
    func clearPxTypeItems(_ tag : Int) {
        for item in pxTypeItems {
            if item.tag != tag {
                item.isSelected = false
            }
        }
    }
    // 每次点击清除选中的百分比
    func clearPercentageItems(_ tag : Int) {
        for item in percentageItems {
            if item.tag != tag {
                item.isSelected = false
            }
        }
    }
}

//MARK:- Even Click
extension KRSwapMakeOrderView {
    // 开多开空
    func moreOrEmptySegment() {
        switch makerOrderVM.orderSide {
        case .buy_OpenLong,.buy_CloseShort:
            if SLPlatformSDK.sharedInstance()?.activeAccount == nil {
                takeOrderBtn.setTitle("登录".localized(), for: .normal)
            } else {
                if makerOrderVM.orderSide == .buy_OpenLong {
                    takeOrderBtn.setTitle("开多".localized(), for: .normal)
                } else {
                    takeOrderBtn.setTitle("平空".localized(), for: .normal)
                }
            }
            takeOrderBtn.color = UIColor.ThemekLine.up
            takeOrderBtn.highlightedColor = UIColor.ThemekLine.up.overlayWhite()
        case .sell_OpenShort,.sell_CloseLong:
            if SLPlatformSDK.sharedInstance()?.activeAccount == nil {
                takeOrderBtn.setTitle("登录".localized(), for: .normal)
            } else {
                if makerOrderVM.orderSide == .sell_OpenShort {
                    takeOrderBtn.setTitle("开空".localized(), for: .normal)
                } else {
                    takeOrderBtn.setTitle("平多".localized(), for: .normal)
                }
            }
            takeOrderBtn.color = UIColor.ThemekLine.down
            takeOrderBtn.highlightedColor = UIColor.ThemekLine.down.overlayWhite()
        default:break
        }
    }
    
    // 委托类型
    @objc func clickOrderTypeBtn() {
        let sheet = KRActionSheet()
        sheet.configButtonTitles(buttons: ["限价委托".localized(),"高级限价".localized(),"条件单".localized()], selectedIdx: makerOrderVM.orderType.rawValue)
        sheet.actionIdxCallback = {[weak self] (idx,title) in
            self?.orderTypeBtn.titleLabel.text = title
            self?.makerOrderVM.orderType = KRMarketOrderVShowType(rawValue: idx) ?? .limit
            self?.refreshLayout()
            self?.frameChangeBlock?(idx)
        }
        EXAlert.showSheet(sheetView: sheet)
    }
    // 高级限价订单类型
    @objc func clickHighOrderTypeBtn() {
        let sheet = KRActionSheet()
        sheet.configButtonTitles(buttons: ["只做maker(Post only)".localized(),"全部成交或立即取消(FOK)".localized(),"立即成交并且取消剩余(IOC)".localized()], selectedIdx: makerOrderVM.highLimitType.rawValue)
        sheet.actionIdxCallback = {[weak self] (idx,title) in
            switch idx {
            case 0:
                self?.highOrderTypeBtn.titleLabel.text = "只做Maker".localized()
            case 1:
                self?.highOrderTypeBtn.titleLabel.text = "FOK".localized()
            case 2:
                self?.highOrderTypeBtn.titleLabel.text = "IOC".localized()
            default:
                break
            }
            self?.makerOrderVM.highLimitType = KRMarketOrderHighLimitType(rawValue: idx) ?? .postOnly
        }
        EXAlert.showSheet(sheetView: sheet)
    }
    // 价格类型
    @objc func clickPriceTypeItem(_ sender: KRFlatBtn) {
        sender.isSelected = true
        clearPxTypeItems(sender.tag)
        if makerOrderVM.orderType == .limit || makerOrderVM.orderType == .highLimit {
            pxTypeLabel.isHidden = false
            switch sender.tag {
            case 0:
                makerOrderVM.limitType = .marketPx
                pxTypeLabel.text = "市价".localized()
            case 1:
                makerOrderVM.limitType = .bidPx
                pxTypeLabel.text = "买一价".localized()
            case 2:
                makerOrderVM.limitType = .askPx
                pxTypeLabel.text = "卖一价".localized()
            default:
                break
            }
            refreshData()
        } else if makerOrderVM.orderType == .plan {
            switch tag {
            case 0:
                makerOrderVM.tiggerType = .tradePriceType
            case 1:
                makerOrderVM.tiggerType = .markPriceType
            case 2:
                makerOrderVM.tiggerType = .indexPriceType
            default:
                break
            }
        }
    }
    // 点击执行市价
    @objc func clickPerformMarket(_ sender: KRFlatBtn) {
        sender.isSelected = !sender.isSelected
        makerOrderVM.planType = sender.isSelected ? .marketPlan : .limitPlan
        if sender.isSelected {
            performInput.performLabel.isHidden = false
        } else {
            performInput.performLabel.isHidden = true
        }
        refreshData()
    }
    
    // 可开百分比
    @objc func clickPercentageItem(_ sender: KRFlatBtn) {
        sender.isSelected = true
        percentLabel.isHidden = false
        clearPercentageItems(sender.tag)
        percentLabel.text = sender.titleLabel?.text ?? ""
        switch sender.tag {
        case 0:
            getPercentValue("0.25")
        case 1:
            getPercentValue("0.5")
        case 2:
            getPercentValue("0.75")
        case 3:
            getPercentValue("1")
        default:
            break
        }
        refreshData()
    }
    func getPercentValue(_ value: String) {
        var decimal: Int32 = 0
        if makerOrderVM.isCoin {
            decimal = 8
        }
        if makerOrderVM.orderSide == .buy_OpenLong {
            qtyInput.input.text = makerOrderVM.canOpenMore.bigMul(value).toString(decimal)
        } else if makerOrderVM.orderSide == .sell_CloseLong {
            qtyInput.input.text = makerOrderVM.canOpenShort.bigMul(value).toString(decimal)
        } else if makerOrderVM.orderSide == .sell_CloseLong {
            qtyInput.input.text = makerOrderVM.canCloseMore.bigMul(value).toString(decimal)
        } else if makerOrderVM.orderSide == .buy_CloseShort {
            qtyInput.input.text = makerOrderVM.canCloseShort.bigMul(value).toString(decimal)
        }
    }
    
    // 下单
    @objc func clickTakeOrderBtn(_ sender : EXButton) {
        guard XUserDefault.getToken() != nil && SLPlatformSDK.sharedInstance()?.activeAccount != nil else {
            KRBusinessTools.showLoginVc(self.yy_viewController)
            return
        }
        if makerOrderVM.limitType == .limitPx {
            guard priceInput.input.text?.length ?? 0 > 0 else {
                EXAlert.showWarning(msg: "请输入价格".localized())
                return
            }
        }
        guard qtyInput.input.text?.length ?? 0 > 0 else {
            EXAlert.showWarning(msg: "请输入数量".localized())
            return
        }
        refreshData()
        if makerOrderVM.direction == 1001 {
            if makerOrderVM.orderSide == .buy_OpenLong {
                if (qtyInput.input.text ?? "0").greaterThan(makerOrderVM.canOpenMore) { //大于最大可开
                    EXAlert.showWarning(msg: "超过最大可开多张数".localized())
                    return
                }
            } else {
                if (qtyInput.input.text ?? "0").greaterThan(makerOrderVM.canOpenShort) { //大于最大可开
                    EXAlert.showWarning(msg: "超过最大可开空张数".localized())
                    return
                }
            }
        } else {
            if makerOrderVM.orderSide == .sell_CloseLong {
                if (qtyInput.input.text ?? "0").greaterThan(makerOrderVM.canCloseMore) { //大于最大可开
                    EXAlert.showWarning(msg: "超过最大可平多张数".localized())
                    return
                }
            } else {
                if (qtyInput.input.text ?? "0").greaterThan(makerOrderVM.canCloseShort) { //大于最大可开
                    EXAlert.showWarning(msg: "超过最大可平多张数".localized())
                    return
                }
            }
        }
        makerOrderVM.doSubmitOrder(sender)
    }
}


