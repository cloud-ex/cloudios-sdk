//
//  KRSwapPositionVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/2.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

class KRSwapPositionVc: KRNavCustomVC {
    
    let vm = KRSwapPositionVM()
    
    var itemBS: BehaviorSubject<BTItemModel> = KRSwapSDKManager.shared.currentBS {
        didSet {
            do {
                let entity = try itemBS.value()
                self.vm.itemModel = entity
                self.vm.loadPositionData(entity.instrument_id)
            } catch  {
            }
            itemBS.asObserver().subscribe(onNext: {[unowned self] (itemModel) in
                self.updataItemModel(itemModel)
            }).disposed(by: self.disposeBag)
        }
    }
    
    lazy var headNavV : KRAllTransactionsNavV = {
        let object = KRAllTransactionsNavV()
        object.setViews(["当前仓位".localized(),"历史仓位".localized()])
        return object
    }()
    lazy var tableView : UITableView = {
        let object = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        object.extUseAutoLayout()
        object.backgroundColor = UIColor.ThemeView.bg
        object.extSetTableView(self, self)
        object.extRegistCell([KRSwapPositionTC.classForCoder(),KRSwapPositionTC.classForCoder()], [currentPosition,historyPosition])
        object.estimatedRowHeight = 294
        object.rowHeight = UITableView.automaticDimension;
        object.mj_header = KRRefreshHeaderView(refreshingBlock: { [weak self] in
            guard let mySelf = self,let instrument_id = mySelf.vm.itemModel?.instrument_id  else { return }
            mySelf.vm.loadPositionData(instrument_id)
        })
        return object
    }()
    lazy var sectionV : KRSwapPositionSection = {
        let object = KRSwapPositionSection.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 32))
        return object
    }()
    lazy var emptyV : KRSwapEmptyView = {
        let object = KRSwapEmptyView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return object
    }()
    
    override func setNavCustomV() {
        self.navCustomView.addSubview(headNavV)
        headNavV.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.width.equalTo(176)
            make.centerX.bottom.equalToSuperview()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewsLayout()
        bindSubject()
        bindVM()
    }
    private func setupSubviewsLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navCustomView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        view.addSubview(emptyV)
        emptyV.snp.makeConstraints { (make) in
            make.top.equalTo(navCustomView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    func bindSubject() {
        headNavV.subject.asObserver().subscribe(onNext: {[weak self] (tag) in
            guard let mySelf = self else { return}
            mySelf.vm.cellIdentifier = (tag == 1001) ? currentPosition : historyPosition
            mySelf.emptyV.isHidden = false
            mySelf.vm.loadPositionData(mySelf.vm.itemModel?.instrument_id ?? 0)
        }).disposed(by: self.disposeBag)
    }
    
    func bindVM() {
        self.vm.setVc(self)
    }
}

extension KRSwapPositionVc: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = vm.tableViewRowDatas[indexPath.row]
        let cell : KRSwapPositionTC = tableView.dequeueReusableCell(withIdentifier: vm.cellIdentifier) as! KRSwapPositionTC
        cell.setCell(entity)
        cell.clickPositionTCBtnBlock = {[weak self] (tag) in
            switch tag {
            case 1000: // 分享
                self?.showSharePage(entity)
            case 1001: // 调整保证金
                self?.showAdjustMargin(entity)
            case 1002: // 止盈止损
                self?.showStopProfitOrLosdd(entity)
            case 1003: // 平仓
                self?.showClosePosition(entity)
            default:
                break
            }
        }
        cell.clickShowTipsBlock = {[weak self] (tag) in
            switch tag {
            case 2001: // 强平价格提示
                self?.showEstimatedLiquidationPxTips()
            case 2002: // 未实现盈亏提示
                self?.showUnrealizedProfitAndLossTips()
            case 2003: // 盈亏率提示
                self?.showProfitAndLossRatioTips()
            case 2004: // 已实现盈亏提示
                self?.showRealizedProfitAndLossTips(entity)
            default:
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if vm.cellIdentifier == currentPosition {
            return sectionV
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if vm.cellIdentifier == currentPosition {
            return 32
        } else {
            return 0
        }
    }
}

// MARK:- refresh Data
extension KRSwapPositionVc {
    
    private func updataItemModel(_ itemModel : BTItemModel) {
        sectionV.setView(itemModel)
        if vm.tableViewRowDatas.count > 0 || vm.cellIdentifier == currentPosition {
            self.tableView.reloadData()
        }
    }
    
    func reloadTableView() {
        if vm.tableViewRowDatas.count > 0 {
            emptyV.isHidden = true
        } else {
            emptyV.isHidden = false
        }
        if self.tableView.mj_header!.isRefreshing {
            self.tableView.mj_header!.endRefreshing()
        }
        self.tableView.reloadData()
    }
}

//MARK:- handle Action
extension KRSwapPositionVc {
    // 分享
    func showSharePage(_ entity:BTPositionModel) {
        
    }
    
    // 调整保证金
    func showAdjustMargin(_ entity:BTPositionModel) {
        let sheet = KRAdjustMarginSheet2()
        sheet.updatePositionModel(entity)
        sheet.clickAdjustMarginBlock = {(result) in
            if result {
                EXAlert.dismissEnd {
                    EXAlert.showSuccess(msg: "调整保证金成功")
                }
            } else {
                EXAlert.dismissEnd {
                    EXAlert.showFail(msg: "调整保证金失败")
                }
            }
        }
        EXAlert.showSheet(sheetView: sheet)
    }
    
    // 止盈止损
    func showStopProfitOrLosdd(_ entity:BTPositionModel) {
        let sheet = KRProfitOrLossSheet()
        sheet.itemBS = itemBS
        sheet.configPositionModel(entity: entity)
        sheet.clickStopProfitLossBlock = {result in
            if result {
                EXAlert.dismissEnd {
                    EXAlert.showSuccess(msg: "下单成功")
                    self.vm.loadPositionData(self.vm.itemModel?.instrument_id ?? 0)
                }
            } else {
                EXAlert.dismissEnd {
                    EXAlert.showSuccess(msg: "下单失败")
                }
            }
        }
        EXAlert.showSheet(sheetView: sheet)
    }
    
    // 平仓
    func showClosePosition(_ entity:BTPositionModel) {
        let sheet = KRPositionCloseSheet()
        sheet.positionM = entity
        sheet.closePositionCallback = {result in
            if result {
                EXAlert.dismissEnd {
                    EXAlert.showSuccess(msg: "下单成功")
                }
            } else {
                EXAlert.dismissEnd {
                    EXAlert.showSuccess(msg: "下单失败")
                }
            }
        }
        EXAlert.showSheet(sheetView: sheet)
    }
    
    // 预估强平价提示
    func showEstimatedLiquidationPxTips() {
        let sheet = KRTextSheet()
        sheet.configTextAlert("", title: "预估强平价格".localized(), content: "预估强平价格为参考强平价格，全仓模式下所有全仓仓位共用可用保证金，强平价格会因其他全仓仓位的盈亏而变化。\r\n当合理价格达到预估强平价格时仓位将会被系统强平。".localized())
        EXAlert.showSheet(sheetView: sheet)
    }
    
    // 未实现盈亏提示
    func showUnrealizedProfitAndLossTips() {
        let sheet = KRTextSheet()
        sheet.configTextAlert("", title: "未实现盈亏".localized(), content: "未实现盈亏根据持仓均价和最新价格计算得出，实际仓位平仓盈亏需要考虑实际成交价格和仓位的已实现盈亏。".localized())
        EXAlert.showSheet(sheetView: sheet)
    }
    
    // 盈亏率
    func showProfitAndLossRatioTips() {
        let sheet = KRTextSheet()
        sheet.configTextAlert("", title: "盈亏率".localized(), content: "盈亏率=未实现盈亏/保证金 表达当前仓位盈利水平".localized())
        EXAlert.showSheet(sheetView: sheet)
    }
    
    // 已实现盈亏提示
    func showRealizedProfitAndLossTips(_ entity : BTPositionModel) {
        let alert = KRRealityProfitAlert()
        alert.configPosition(entity)
        alert.alertCallback = {[weak self] tag in
            if tag == 1 {
                // 资金费用详情页
                let vc = KRCapitalCostVc()
                vc.position = entity
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        EXAlert.showAlert(alertView: alert)
    }
}

