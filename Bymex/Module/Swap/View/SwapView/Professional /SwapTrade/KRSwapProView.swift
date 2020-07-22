//
//  KRSwapProView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/24.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  专业模式

import Foundation
import RxSwift

class KRSwapProView: KRBaseV {
    
    var refreshOrderBook: ((Bool) -> Void)?
    
    var jumpToPositionVC: ((BTPositionModel?) -> Void)?
       
    var jumpToDetailVC: (() -> Void)?
    
    var orderArray: [BTContractOrderModel] = []
    
    var positionArray: [BTPositionModel] = []
    
    let proVM = KRSwapVM()
    
    lazy var positionV : KRPositionHeaderView = {
        let object = KRPositionHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 144))
        object.positionHeaderClickBlock = {[weak self] position in
            self?.jumpToPositionVC?(position)
        }
        return object
    }()
    lazy var swapSegmentV : KRSwapSegmentView = {
        let object = KRSwapSegmentView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        object.setViewInfo(["开仓".localized(),"平仓".localized()], images: ["swap_calculator","contract_stock_line"])
        object.subject.asObserver().subscribe(onNext: {[weak self] (tag) in
            self?.handleHeaderSegmentTag(tag)
        }).disposed(by: self.disposeBag)
        return object
    }()
    
    var makeOrderTC : KRMakeOrderTC = KRMakeOrderTC.init(style: .default, reuseIdentifier: "KRMakeOrderTC")
    
    lazy var sectionView : KRSwapSegmentView = {
        let object = KRSwapSegmentView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        object.setViewInfo(["普通委托".localized(),"条件委托".localized()], images: ["swap_orders","swap_deleteAll"])
        object.subject.asObserver().subscribe(onNext: {[weak self] (tag) in
            self?.handleSectionTag(tag)
        }).disposed(by: self.disposeBag)
        return object
    }()
    
    lazy var tableView : UITableView = {
        let object = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: .plain)
        object.extUseAutoLayout()
        object.backgroundColor = UIColor.ThemeView.bg
        object.extRegistCell([KRSwapOrderTC.classForCoder(),KRSwapOrderTC.classForCoder(),KRTransactionEmptyTC.classForCoder(),KRMakeOrderTC.classForCoder()], [limitIdentify,planIdentify,"KRTransactionEmptyTC","KRMakeOrderTC"])
        object.showsVerticalScrollIndicator = false
        object.estimatedRowHeight = 180
        object.rowHeight = UITableView.automaticDimension
        object.extSetTableView(self, self)
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([tableView])
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bindVM()
        bindSubject()
        tableView.mj_header = KRRefreshHeaderView(refreshingBlock: { [weak self] in
            guard let mySelf = self else { return }
            mySelf.refreshData()
        })
    }
    
    func bindVM() {
        proVM.setProV(self)
        proVM.swapOrdersList.asObserver().subscribe(onNext: {[unowned self] (orders) in
            self.orderArray = orders
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).disposed(by: self.disposeBag)
        
        proVM.swapPositionList.asObserver().subscribe(onNext: {[unowned self] (positions) in
            self.positionArray = positions
            DispatchQueue.main.async {
                self.setPositionViews(positions)
            }
        }).disposed(by: self.disposeBag)
    }
    
    func bindSubject() {
        makeOrderTC.heightSubject.asObserver().subscribe(onNext: {[weak self] (height) in
//            let indexPath = IndexPath.init(row: 0, section: 0)
//            self?.tableView.reloadRows(at: [indexPath], with: .none)
            self?.tableView.reloadData()
        }).disposed(by: self.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPositionViews(_ positions:[BTPositionModel]) {
        positionV.setView(positions)
        if positions.count > 0 && positionV.isHidden == true {
            positionV.isHidden = false
            tableView.tableHeaderView = positionV
        } else if positions.count <= 0 && positionV.isHidden == false {
            positionV.isHidden = true
            tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 1))
        }
    }
}

extension KRSwapProView : UITableViewDelegate ,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if orderArray.count == 0 {
                return 1
            }
            return orderArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return makeOrderTC
        } else {
            if orderArray.count == 0 {
                let cell : KRTransactionEmptyTC = tableView.dequeueReusableCell(withIdentifier: "KRTransactionEmptyTC") as! KRTransactionEmptyTC
                cell.emptyTips.text = "赶快下单吧，你离暴富只差一步".localized()
                return cell
            }
            let entity = orderArray[indexPath.row]
            let cell : KRSwapOrderTC = tableView.dequeueReusableCell(withIdentifier: proVM.cellIdentifier) as! KRSwapOrderTC
            cell.setCell(entity)
            cell.cancelOrderBlock = {[weak self] cellOrder in
                guard let order = cellOrder, let mySelf = self else {
                    return
                }
                let alert = KRNormalAlert()
                alert.configAlert(title:"提示".localized() , message: "确定取消这条订单么?".localized(), passiveBtnTitle: "取消".localized(), positiveBtnTitle: "确定".localized())
                alert.alertCallback = {(tag) in
                    if tag == 0 {
                        mySelf.proVM.cancelTransitionOrders(mySelf.proVM.cellIdentifier, [order], { (result) in
                            if result {
                                if mySelf.orderArray.count > indexPath.row {
                                    mySelf.orderArray.remove(at: indexPath.row)
                                    mySelf.tableView.reloadData()
                                }
                            }
                        })
                    }
                }
                EXAlert.showAlert(alertView: alert)
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return swapSegmentV
        }
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension KRSwapProView {
    
    func handleHeaderSegmentTag(_ tag : Int) {
        switch tag {
        case 1001,1002:
            self.makeOrderTC.makeOrderV.makerOrderVM.directionSubject.onNext(tag)
            self.makeOrderTC.heightSubject.onNext(self.frame.size.height)
        case 101:
            let sheet = KRCalculatorSheet()
            sheet.itemModel = self.proVM.itemModel
            EXAlert.showSheet(sheetView: sheet)
        case 102:
            self.jumpToDetailVC?()
        default:
            break
        }
    }
    
    func handleSectionTag(_ tag: Int) {
        switch tag {
        case 1001,1002:
            proVM.cellIdentifier = (tag == 1001) ? limitIdentify : planIdentify
            proVM.requestTransitionData(proVM.cellIdentifier)
        case 101:
            guard XUserDefault.getToken() != nil && SLPlatformSDK.sharedInstance()?.activeAccount != nil else {
                KRBusinessTools.showLoginVc(self.yy_viewController)
                return
            }
            // 全部委托
            let vc = KRAllTransactionsVc()
            vc.vm.itemModel = proVM.itemModel
            self.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        case 102:
            guard XUserDefault.getToken() != nil && SLPlatformSDK.sharedInstance()?.activeAccount != nil else {
                KRBusinessTools.showLoginVc(self.yy_viewController)
                return
            }
            // 全部撤销
            if orderArray.count == 0 {
                return
            }
            let alert = KRNormalAlert()
            alert.configAlert(title:"提示" , message: "确定撤销全部委托?", passiveBtnTitle: "取消".localized(), positiveBtnTitle: "确定".localized())
            alert.alertCallback = {[weak self] (tag) in
                guard let mySelf = self else {
                    return
                }
                if tag == 0 {
                    mySelf.proVM.cancelTransitionOrders(mySelf.proVM.cellIdentifier, mySelf.orderArray) { (result) in
                        if result {
                            mySelf.orderArray.removeAll()
                            mySelf.tableView.reloadData()
                        }
                    }
                }
            }
            EXAlert.showAlert(alertView: alert)
            break
        default:break
        }
    }
    
    func setStatus(_ status:Bool) {
        self.isHidden = !status
    }
}

extension KRSwapProView {
    // 下拉刷新(后续做成zip)
    private func refreshData() {
        // 刷新深度
        refreshOrderBook?(true)
        
        guard SLPlatformSDK.sharedInstance()?.activeAccount != nil else {
            if self.tableView.mj_header?.isRefreshing == true {
                self.tableView.mj_header?.endRefreshing()
            }
            if orderArray.count > 0 || positionArray.count > 0 {
                clearProSwapData()
            }
            return
        }
        // 刷新当前委托
        proVM.requestTransitionData(proVM.cellIdentifier) {[weak self] (result) in
            guard let mySelf = self else {return}
            if mySelf.tableView.mj_header?.isRefreshing == true {
                mySelf.tableView.mj_header?.endRefreshing()
            }
        }
        // 刷新仓位
        proVM.requestPositionData(proVM.itemModel?.instrument_id ?? 0) {[weak self] (result) in
            guard let mySelf = self else {return}
            if mySelf.tableView.mj_header?.isRefreshing == true {
                mySelf.tableView.mj_header?.endRefreshing()
            }
        }
        // 刷新资产
        SLPlatformSDK.sharedInstance()?.sl_loadUserContractPerpotyCallBack({[weak self] (assets) in
            self?.makeOrderTC.makeOrderV.refreshData()
        })
    }
    
    func clearProSwapData() {
        orderArray.removeAll()
        positionArray.removeAll()
        proVM.swapOrdersList.onNext([])
        proVM.swapPositionList.onNext([])
    }
}
