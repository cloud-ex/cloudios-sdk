//
//  KRMarketDetailVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/25.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  合约详情页

import Foundation
import RxSwift

class KRMarketDetailVc: KRNavCustomVC {
    
    private let depthCellReUseID = "KRMarketDetailDepthCell_ID"
    private let transactionCellReUseID = "KRTransactionDepthCell_ID"
    private let recordTitleReUseID = "KRTransactionRecordTitleCell_ID"
    private let recordCellReUseID = "KRTransactionRecordCell_ID"
    
    private var myDisposeBag = DisposeBag()
    
    var itemModel : BTItemModel? {
        didSet {
            if oldValue?.instrument_id != itemModel?.instrument_id {
                // 请求深度、成交记录
                updateContentData()
                // 添加 socket 订阅
                addSocketSubscribe()
            }
        }
    }
    
    lazy var depthModel = BTDepthModel()
    
    var dealRecordDataArray: [BTContractTradeModel] = []
    
    var curSectionTag : Int = 1001 // 1001:深度，1002成交
    
    var depthCell = KRSwapDetailDepthTC.init(style: .default, reuseIdentifier: "KRSwapDetailDepthView")
    
    let CellCount = 15
    
    var orderBookCells : [KRTransactionDepthTC] = []
    var tradeCells : [KRTransactionRecordTC] = []
    
    var maxBidLength : Double = 1
    var maxAskLength : Double = 1
    
    var itemBS: BehaviorSubject<BTItemModel> = BehaviorSubject(value: BTItemModel()) {
        didSet {
            self.myDisposeBag = DisposeBag()
            itemBS.subscribe(onNext: {[unowned self] (itemModel) in
                self.chartView.itemModel = itemModel
                self.headerInfoView.setView(itemModel)
                self.itemModel = itemModel
            }).disposed(by: self.myDisposeBag)
        }
    }
    
    private lazy var headerInfoView: KRDetailHeaderView = {
        let object = KRDetailHeaderView()
        object.backgroundColor = UIColor.ThemeTab.bg
        return object
    }()
    
    private lazy var chartView: KRSwapDetailChartView = {
        let object = KRSwapDetailChartView()
        return object
    }()
    private lazy var fullButton: UIButton = {
        let object = UIButton()
        object.extSetImages([UIImage.themeImageNamed(imageName: "swap_detail_full")], controlStates: [.normal])
        object.rx.tap.subscribe(onNext:{ [weak self] in
            self?.showFullScreen()
        }).disposed(by: disposeBag)
        return object
    }()
    private var isShowFullView = false
    
    private lazy var fullScreenChartView: KRKLineFullScreenView = {
        let object = KRKLineFullScreenView()
        return object
    }()
    
    lazy var tableHeaderView : UIView = {
        let object = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 547))
        object.addSubViews([headerInfoView,chartView])
        
        return object
    }()
    
    private lazy var contentTableView: UITableView = {
        let object = UITableView(frame: CGRect.zero, style: .grouped)
        if #available(iOS 11.0, *) {
            object.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        object.showsVerticalScrollIndicator = false
        object.extSetTableView(self, self)
        object.estimatedRowHeight = 0
        object.estimatedSectionHeaderHeight = 0
        object.estimatedSectionFooterHeight = 0
        object.tableHeaderView = self.tableHeaderView
        object.extRegistCell([KRSwapDetailDepthTC.classForCoder(),KRSwapDetailDepthTC.classForCoder(), KRTransactionDepthTC.classForCoder(), KRTransactionRecordTitleCell.classForCoder(), KRTransactionRecordTC.classForCoder()], ["KRSwapDetailDepthView",depthCellReUseID, transactionCellReUseID, recordTitleReUseID, recordCellReUseID])
        return object
    }()
    
    private lazy var sectionHeader: KRSwapDetailSegment = {
        let object = KRSwapDetailSegment(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        object.switchDetailSegmentBlock = {[weak self] tag in
            self?.curSectionTag = tag
            self?.contentTableView.reloadData()
            if tag == 1001 {
                self?.requestDepthData()
            } else if tag == 1002 {
                self?.requestDepthData()
            } else {
                self?.requestDealData()
            }
        }
        return object
    }()
    
    private lazy var buyButton: UIButton = {
        let object = UIButton()
        object.extSetTitle("开多", 16, UIColor.ThemeLabel.colorLite, .normal)
        object.extSetAddTarget(self, #selector(buyButtonClick))
        object.extsetBackgroundColor(backgroundColor: UIColor.ThemekLine.up, state: .normal)
        return object
    }()
    
    private lazy var sellButton: UIButton = {
        let object = UIButton()
        object.extSetTitle("开空", 16, UIColor.ThemeLabel.colorLite, .normal)
        object.extSetAddTarget(self, #selector(sellButtonClick))
        object.extsetBackgroundColor(backgroundColor: UIColor.ThemekLine.down, state: .normal)
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSocketNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        self.removeSocketSubscribe()
    }
    
    override func setNavCustomV() {
        self.navtype = .normal
        self.navCustomView.backView.backgroundColor = UIColor.ThemeTab.bg
        self.navCustomView.setRightModule([fullButton], rightSize: [(30, 30)])
    }
    
    private func initUI() {
        view.addSubViews([contentTableView, buyButton, sellButton])
    }
    
    private func initLayout() {
        headerInfoView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(86)
        }
        chartView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerInfoView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        self.contentTableView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(navCustomView.snp_bottom)
            make.bottom.equalTo(self.buyButton.snp_top)
        }
        self.buyButton.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview().offset(-TABBAR_BOTTOM)
        }
        self.sellButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.buyButton.snp_right)
            make.bottom.equalTo(self.buyButton)
            make.height.equalTo(self.buyButton)
            make.width.equalTo(self.buyButton)
        }
    }
}

// MARK: - ws
extension KRMarketDetailVc {
    
    // MARK: - Socket Data
    
    /// 添加 socket 订阅
    private func addSocketSubscribe() {
        if let _itemModel = self.itemModel {
            // 订阅深度
            SLSocketDataManager.sharedInstance().sl_subscribeContractDepthData(withInstrument: _itemModel.instrument_id)
            // 订阅最新成交
            SLSocketDataManager.sharedInstance().sl_subscribeContractTradeData(withInstrument: _itemModel.instrument_id)
        }
    }
    
    private func removeSocketSubscribe() {
        if let _itemModel = self.itemModel {
            // 取消订阅最新成交
            SLSocketDataManager.sharedInstance().sl_unSubscribeContractTradeData(withInstrument: _itemModel.instrument_id)
            // 取消订阅K线
            chartView.unSubKLineWS()
        }
    }
    
    /// 添加 socket 数据通知
    private func addSocketNotification() {
        // 深度
        NotificationCenter.default.addObserver(self, selector: #selector(handleDepthSocketData), name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Depth_Notification), object: nil)
        // 最新成交
        NotificationCenter.default.addObserver(self, selector: #selector(handleTradeSocketData), name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Trade_Notification), object: nil)
        // websocket重新连接成功
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(rearrangeSwapConnect),
                                               name: NSNotification.Name(rawValue: ContractWebSocketDidOpenNote),
                                               object: nil)
    }
    /// 深度数据
    @objc func handleDepthSocketData(notify: Notification) {
        guard let instrument_id = notify.userInfo!["instrument_id"] as? Int64 else { return }
        if instrument_id == itemModel?.instrument_id && self.curSectionTag != 1003  {
            self.depthModel.sells = SLPublicSwapInfo.sharedInstance()?.getAskOrderBooks(Int32(CellCount))
            self.depthModel.buys = KRSwapSDKManager.shared.handleAddQtyOrderBooksData(SLPublicSwapInfo.sharedInstance()?.getBidOrderBooks(Int32(CellCount)) ?? [])
            self.depthModel.sells = KRSwapSDKManager.shared.handleAddQtyOrderBooksData(SLPublicSwapInfo.sharedInstance()?.getAskOrderBooks(Int32(CellCount)) ?? [])
            self.maxBidLength = KRBasicParameter.handleDouble(self.depthModel.buys.last?.addupQty ?? "0")
            self.maxAskLength = KRBasicParameter.handleDouble(self.depthModel.sells.last?.addupQty ?? "0")
            if self.curSectionTag == 1001 {
                // 刷新orderBook
                refreshOrderBooksCells()
            } else if self.curSectionTag == 1002 {
                // 刷新深度图
                depthCell.depthView.updateView(itemModel?.last_px ?? "0")
            }
        }
    }
    
    /// 最新成交
    @objc func handleTradeSocketData(notify: Notification) {
        guard let trades = notify.userInfo?["data"] as? [BTContractTradeModel] else {
            return
        }
        if self.curSectionTag == 1003 {
            self.dealRecordDataArray = trades
            refreshTradeCells()
        }
    }
    
    // 链接成功请求数据
    @objc func rearrangeSwapConnect() {
        updateContentData()
        self.addSocketSubscribe()
        // 重新请求K线
        self.chartView.reloadConnectKLine()
    }
}

// MARK:- upload data
extension KRMarketDetailVc {
    /// 更新全部数据
    private func updateContentData() {
        if self.curSectionTag == 1001 {
            self.requestDepthData()
        } else if self.curSectionTag == 1003 {
            self.requestDealData()
        }
    }
    
    /// 更新挂单深度数据列表
    private func requestDepthData() {
        guard let _itemModel = self.itemModel else {
            return
        }
        SLSDK.sl_loadOrderBooks(withContractID: _itemModel.instrument_id, price: _itemModel.last_px, count: 15, success: { (depthModel) in
            guard let _depthModel = depthModel else {
                return
            }
            self.depthModel = _depthModel
            self.maxBidLength = KRBasicParameter.handleDouble(_depthModel.buys.first?.qty ?? "0")
            self.maxAskLength = KRBasicParameter.handleDouble(_depthModel.sells.first?.qty ?? "0")
            self.contentTableView.reloadData()
            if self.curSectionTag == 1002 {
                self.depthCell.depthView.updateView(self.itemModel?.last_px ?? "0")
            }
        }) { (error) in

        }
    }
    /// 获取成交记录列表
    private func requestDealData() {
        guard let _itemModel = self.itemModel else {
            return
        }
        SLSDK.sl_loadFutureLatestDeal(withContractID: _itemModel.instrument_id) { (resArr: [BTContractTradeModel]?) in
            guard let array = resArr else {
                return
            }
            self.dealRecordDataArray = array
            self.contentTableView.reloadData()
        }
    }
    
    func refreshOrderBooksCells() {
        if curSectionTag != 1001 {
            return
        }
        if !self.contentTableView.isTracking, !self.contentTableView.isDecelerating {
            if self.orderBookCells.count < CellCount {
                self.contentTableView.reloadData()
            } else {
                self.orderBookCells.forEach { (cell: KRTransactionDepthTC) in
                    var bid: SLOrderBookModel?
                    var ask: SLOrderBookModel?
                    if cell.row < depthModel.buys.count {
                        bid = depthModel.buys[cell.row]
                    }
                    if cell.row < depthModel.sells.count {
                        ask = depthModel.sells[cell.row]
                    }
                    cell.updateCell(buyModel: bid, sellModel: ask, maxBidVol: self.maxBidLength, maxAskVol: self.maxAskLength)
                }
            }
        }
    }
    
    func refreshTradeCells() {
        if curSectionTag != 1003 {
            return
        }
        if !self.contentTableView.isTracking, !self.contentTableView.isDecelerating {
            if self.tradeCells.count < CellCount {
                self.contentTableView.reloadData()
            } else {
                self.tradeCells.forEach { (cell: KRTransactionRecordTC) in
                    var trade: BTContractTradeModel?
                    if cell.row < dealRecordDataArray.count {
                        trade = dealRecordDataArray[cell.row]
                    }
                    cell.updateCell(trade)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension KRMarketDetailVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if curSectionTag == 1002 {
            return 1
        }
        return CellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.curSectionTag == 1001 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: depthCellReUseID) as! KRSwapDetailDepthTC
                cell.setMiddleUnit(itemModel?.contractInfo.quote_coin ?? "-")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: transactionCellReUseID) as! KRTransactionDepthTC
                cell.row = indexPath.row - 1
                let buyModel = self.depthModel.buys[safe: indexPath.row - 1]
                let sellModel = self.depthModel.sells[safe: indexPath.row - 1]
                cell.updateCell(buyModel: buyModel, sellModel: sellModel, maxBidVol: self.maxBidLength,maxAskVol: self.maxAskLength)
                if !orderBookCells.contains(cell) {
                    orderBookCells.append(cell)
                }
                return cell
            }
        } else if self.curSectionTag == 1002 {
            return depthCell
        } else if self.curSectionTag == 1003 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: recordTitleReUseID) as! KRTransactionRecordTitleCell
                cell.setPriceUnit(itemModel?.contractInfo.quote_coin ?? "-")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: recordCellReUseID) as! KRTransactionRecordTC
                cell.row = indexPath.row - 1
                let model = self.dealRecordDataArray[safe: indexPath.row - 1]
                cell.updateCell(model)
                if !tradeCells.contains(cell) {
                    tradeCells.append(cell)
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.curSectionTag == 1001 {
            return 25
        } else if self.curSectionTag == 1002 {
            return 200
        } else if self.curSectionTag == 1003 {
            if indexPath.row == 0 {
                return 25
            }
        }
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.tableHeaderView.dismissDropView()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        chartView.chartView.scrollEnabled = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        chartView.chartView.scrollEnabled = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        chartView.chartView.scrollEnabled = true
    }
}

// MARK:- Even Action
extension KRMarketDetailVc {
    private func showFullScreen() {
        view.addSubview(fullScreenChartView)
        
        isShowFullView = true
        
        weak var wFullScreenChartView = fullScreenChartView
        fullScreenChartView.topView.closeCallback = {[weak self] in
            UIView.animate(withDuration: 0.2, animations: {
                wFullScreenChartView?.x = self?.view.width ?? 0
            }) { (_) in
                wFullScreenChartView?.snp_removeConstraints()
                wFullScreenChartView?.removeFromSuperview()
            }
        }
        
        let transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2)
        fullScreenChartView.transform = transform
    
        fullScreenChartView.itemModel = chartView.itemModel
        
        fullScreenChartView.frame = CGRect(x: view.width, y: 0, width: view.width, height: view.height)
        fullScreenChartView.centerY = view.centerY
        
        UIView.animate(withDuration: 0.2) {
            self.fullScreenChartView.centerX = self.view.centerX
        }
    }
    
    @objc func buyButtonClick() {
        self.popBack()
    }
    
    @objc func sellButtonClick() {
        self.popBack()
    }
}
