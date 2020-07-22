//
//  KRSwapPriceView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/24.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  盘口区域

import Foundation

class KRSwapPriceView: KRBaseV {
    
    typealias ClickRightBlock = (SLOrderBookModel) -> ()
    var clickRightBlock : ClickRightBlock?
    var decimal : NSInteger = 0
    var depthCount = 5
    
    var itemModel:BTItemModel?
    
    var isCoin : Bool {
        return BTStoreData.storeBool(forKey: BT_UNIT_VOL)
    }
    
    var bidTableViewRowDatas : [SLOrderBookModel] = []
    var askTableViewRowDatas : [SLOrderBookModel] = []
    
    var buyCells: [KRSwapBidAskTC] = []
    var sellCells: [KRSwapBidAskTC] = []
    
    lazy var lastPxLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.HeadRegular, textColor: UIColor.ThemekLine.up, alignment: .left)
        return object
    }()
    lazy var rateLabel : KRSpaceLabel = {
        let object = KRSpaceLabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemekLine.up, alignment: .center)
        object.textInsets = UIEdgeInsets(top: 1, left: 3, bottom: 0, right: 3)
        object.backgroundColor = UIColor.ThemekLine.up.withAlphaComponent(0.1)
        object.extSetCornerRadius(4)
        return object
    }()
    lazy var indexPxBtn : KRTipBtn = {
        let object = KRTipBtn()
        object.setImgLayout("swap_indexPx", .left)
        object.setTitle("--")
        object.titleLabel.font = UIFont.ThemeFont.MinimumRegular
        object.clickShowTipBlock = {[weak self] in
            let sheet = KRTextSheet()
            sheet.configTextAlert("swap_indexpx", title: "指数价格".localized(), content: "指数价格是标的资产的多个现货市场加权价格，用于计算当前市场合约的合理价格。".localized())
            EXAlert.showSheet(sheetView: sheet)
        }
        return object
    }()
    lazy var fairPxBtn : KRTipBtn = {
        let object = KRTipBtn()
        object.setImgLayout("swap_fairPx", .right)
        object.setTitle("--")
        object.titleLabel.font = UIFont.ThemeFont.MinimumRegular
        object.clickShowTipBlock = {[weak self] in
            let sheet = KRTextSheet()
            sheet.configTextAlert("swap_fairPx", title: "合理价格".localized(), content: "合理价格等于标的指数价格加上随时间递减的资金费用基差，主要为了避免高杠杆发生的不必要平仓。合理价格影响强平，即当合理价格达到爆仓价格时，系统将执行强制平仓操作。".localized())
            EXAlert.showSheet(sheetView: sheet)
        }
        return object
    }()
    lazy var pxQtyLabel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.leftLabel.font = UIFont.systemFont(ofSize: 11.5)
        object.rightLabel.extSetTextColor(UIColor.ThemeLabel.colorDark, fontSize: 11.5)
        object.setLeftText("价格".localized())
        object.setRightText("数量".localized())
        return object
    }()
    lazy var askTableV : UITableView = {
        let object = UITableView()
        object.extUseAutoLayout()
        object.backgroundColor = UIColor.ThemeView.bg
        object.showsVerticalScrollIndicator = false
        object.extSetTableView(self, self)
        object.extRegistCell([KRSwapBidAskTC.classForCoder()], ["KRSwapAskTC"])
        object.rowHeight = 24
        object.bounces = false
        return object
    }()
    lazy var bidTableV : UITableView = {
        let object = UITableView()
        object.extUseAutoLayout()
        object.backgroundColor = UIColor.ThemeView.bg
        object.showsVerticalScrollIndicator = false
        object.bounces = false
        object.extSetTableView(self, self)
        object.extRegistCell([KRSwapBidAskTC.classForCoder()], ["KRSwapBidTC"])
        object.rowHeight = 24
        return object
    }()
    lazy var fundRateLabel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.setLeftText("资金费率".localized())
        object.addTapLabel()
        object.clickRightLabelBlock = {[weak self] in
            let sheet = KRTextSheet()
            sheet.configTextAlert(title: "资金费率".localized(), content: "资金费率为正数，多头仓位向空头仓位支付资金费用。\r\n资金费率为负数，空头仓位向多头仓位支付资金费用。\r\n资金费用 = 仓位价值 * 资金费率".localized())
            EXAlert.showSheet(sheetView: sheet)
        }
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([lastPxLabel,rateLabel,indexPxBtn,fairPxBtn,pxQtyLabel,askTableV,bidTableV,fundRateLabel])
        lastPxLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(25)
            make.width.lessThanOrEqualTo(100)
        }
        rateLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.height.equalTo(lastPxLabel)
            make.width.lessThanOrEqualTo(70)
        }
        indexPxBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(lastPxLabel.snp.bottom).offset(8)
            make.height.equalTo(16)
        }
        fairPxBtn.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(indexPxBtn)
            make.right.equalToSuperview()
            make.left.equalTo(indexPxBtn.snp.right).offset(8)
        }
        pxQtyLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(16)
            make.top.equalTo(indexPxBtn.snp.bottom).offset(20)
        }
        askTableV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(pxQtyLabel.snp.bottom).offset(12)
            make.height.equalTo(120)
        }
        bidTableV.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(askTableV)
            make.top.equalTo(askTableV.snp.bottom).offset(12)
        }
        fundRateLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(bidTableV.snp.bottom).offset(12)
            make.height.equalTo(16)
        }
    }
}

extension KRSwapPriceView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.bidTableV {
            let cell : KRSwapBidAskTC = tableView.dequeueReusableCell(withIdentifier: "KRSwapBidTC") as! KRSwapBidAskTC
            cell.row = indexPath.row
            if bidTableViewRowDatas.count == depthCount {
                let entity = bidTableViewRowDatas[indexPath.row]
                cell.setCell(entity)
            }
            if !buyCells.contains(cell) {
                buyCells.append(cell)
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell : KRSwapBidAskTC = tableView.dequeueReusableCell(withIdentifier: "KRSwapAskTC") as! KRSwapBidAskTC
            cell.row = indexPath.row
            if askTableViewRowDatas.count == depthCount {
                let entity = askTableViewRowDatas[depthCount - indexPath.row - 1]
                cell.setCell(entity)
            }
            if !sellCells.contains(cell) {
                sellCells.append(cell)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var entity : SLOrderBookModel
        if tableView == self.bidTableV {
            entity = bidTableViewRowDatas[indexPath.row]
        } else {
            entity = askTableViewRowDatas[depthCount - indexPath.row - 1]
        }
        if entity.px?.length ?? 0 > 0 {
            self.clickRightBlock?(entity)
        }
    }
}

extension KRSwapPriceView {
    
    func refreshBidCells() {
        if !self.bidTableV.isTracking, !self.bidTableV.isDecelerating {
            if self.buyCells.count == 0 {
                self.bidTableV.reloadData()
            } else {
                self.buyCells.forEach { (cell: KRSwapBidAskTC) in
                    var bid: SLOrderBookModel?
                    if cell.row < bidTableViewRowDatas.count {
                        bid = bidTableViewRowDatas[cell.row]
                        if isCoin {
                            cell.setCoinCell(bid,self.itemModel?.contractInfo)
                        } else {
                            cell.setCell(bid)
                        }
                    }
                }
            }
        }
    }
    
    func refreshAskCells() {
        if !self.askTableV.isTracking, !self.askTableV.isDecelerating {
            if self.sellCells.count == 0 {
                self.askTableV.reloadData()
            } else {
                self.sellCells.forEach { (cell: KRSwapBidAskTC) in
                    var ask: SLOrderBookModel?
                    if cell.row < askTableViewRowDatas.count {
                        ask = askTableViewRowDatas[depthCount-cell.row-1]
                        if isCoin {
                            cell.setCoinCell(ask,self.itemModel?.contractInfo)
                        } else {
                            cell.setCell(ask)
                        }
                    }
                }
            }
        }
    }
    
    func setBids(_ bids : [SLOrderBookModel] , max : String) {
        bidTableViewRowDatas.removeAll()
        for idx in 0..<depthCount{
            if bids.count <= idx {
                let buy = SLOrderBookModel()
                buy.way = "1"
                buy.max_volume = max
                bidTableViewRowDatas.append(buy)
            } else {
                let buy = bids[idx]
                buy.way = "1"
                buy.max_volume = max
                bidTableViewRowDatas.append(buy)
            }
        }
        refreshBidCells()
    }
    
    func setAsks(_ asks : [SLOrderBookModel] , max : String) {
        askTableViewRowDatas.removeAll()
        for idx in 0..<depthCount{
            if asks.count <= idx {
                let sell = SLOrderBookModel()
                sell.way = "2"
                sell.max_volume = max
                askTableViewRowDatas.append(sell)
            } else {
                let sell = asks[idx]
                sell.way = "2"
                sell.max_volume = max
                askTableViewRowDatas.append(sell)
            }
        }
        refreshAskCells()
    }
}

extension KRSwapPriceView {
    
    func refreshPriceUnit() {
        guard let entity = self.itemModel else {
            return
        }
        pxQtyLabel.setLeftText(String(format: "价格(%@)", entity.contractInfo.quote_coin))
        if isCoin { // 以币种为单位
            pxQtyLabel.setRightText(String(format:"数量(%@)".localized(),entity.contractInfo.base_coin))
        } else {
            pxQtyLabel.setRightText("数量(张)".localized())
        }
    }
    
    func updataPriceInfo(_ itemModel: BTItemModel) {
        self.itemModel = itemModel
        lastPxLabel.text = itemModel.last_px
        
        if itemModel.trend == .up {
            rateLabel.textColor = UIColor.ThemekLine.up
            rateLabel.text = itemModel.change_rate.toPercentString(3)
        } else {
            rateLabel.textColor = UIColor.ThemekLine.down
            rateLabel.text = "-"+itemModel.change_rate.toPercentString(3)
        }
        indexPxBtn.setTitle(itemModel.index_px.toSmallPrice(withContractID: itemModel.instrument_id))
        fairPxBtn.setTitle(itemModel.fair_px.toSmallPrice(withContractID: itemModel.instrument_id))
        let fd = itemModel.funding_rate.count > 0 ? (itemModel.funding_rate as NSString).toPercentString(4) : "0"
        fundRateLabel.setRightText(fd ?? "0")
    }
    
    func refreshOrderBook(_ refreshType: Int = 0) {
        if refreshType == 1 { // 买盘
            let buys = SLPublicSwapInfo.sharedInstance()?.getBidOrderBooks(5) ?? []
            setBids(buys, max: buys.first?.max_volume ?? "0")
        } else if refreshType == 2 { // 卖盘
            let sells = SLPublicSwapInfo.sharedInstance()?.getAskOrderBooks(5) ?? []
            setAsks(sells, max: sells.first?.max_volume ?? "0")
        } else {
            let buys = SLPublicSwapInfo.sharedInstance()?.getBidOrderBooks(5) ?? []
            let sells = SLPublicSwapInfo.sharedInstance()?.getAskOrderBooks(5) ?? []
            setBids(buys, max: buys.first?.max_volume ?? "0")
            setAsks(sells, max: sells.first?.max_volume ?? "0")
        }
    }
    
    func clearOrderBook() {
        setAsks([], max: "0")
        setBids([], max: "0")
    }
}
