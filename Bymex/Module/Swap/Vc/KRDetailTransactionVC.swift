//
//  KRSwapDetailTransactionVC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRDetailTransactionVC: KRNavCustomVC {
    
    var orderModel: BTContractOrderModel?
    
    var tableViewRowDatas: [BTContractTradeModel] = []
    
    lazy var titleView: KRSwapDetailHeaderView = KRSwapDetailHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 118))
    lazy var footerView : KRSwapDetailFooterView = KRSwapDetailFooterView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 60))
    lazy var contentTableView: UITableView = {
        let object = UITableView(frame: CGRect.zero, style: .plain)
        object.rowHeight = 158
        object.extSetTableView(self, self)
        object.tableHeaderView = titleView
        object.tableFooterView = footerView
        object.extRegistCell([KRDetailTransactionTC.classForCoder()], ["KRDetailTransactionTC"])
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.contentTableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        contentView.addSubview(contentTableView)
        initLayout()
        handleJumpDetail()
        
        if self.orderModel != nil {
            updateHeader(order: self.orderModel!)
            updateFooter(order: self.orderModel!)
        }
        self.requestHistoryData(instrument_id: self.orderModel?.instrument_id ?? 0, oid: self.orderModel?.oid ?? 0)
    }
    
    override func setNavCustomV() {
        self.setTitle("成交明细")
    }
    
    private func initLayout() {
        self.contentTableView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.navCustomView.snp_bottom).offset(18)
        }
    }
     
    private func handleJumpDetail() {
        titleView.showDetailCallback = {[weak self] (order,detailType) in
            self?.showDetailAlert(model: order, detailType: detailType)
        }
    }
    
    private func updateHeader(order: BTContractOrderModel) {
        self.titleView.updateView(model: order)
    }
    
    private func updateFooter(order: BTContractOrderModel) {
        let str = KRSwapSDKManager.shared.getOrderResultStr(order)
        footerView.titleLabel.text = "取消原因".localized()
        if str == "已完成".localized() {
            footerView.isHidden = true
        } else if str == "已撤销".localized() {
            footerView.detailLabel.text = KRSwapSDKManager.shared.getErrorNoStr(order)
        } else if str == "部分成交".localized() {
            footerView.detailLabel.text = "用户取消"
        }
    }
}

extension KRDetailTransactionVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewRowDatas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KRDetailTransactionTC", for: indexPath) as! KRDetailTransactionTC
        cell.contractInfo = self.orderModel?.contractInfo
        cell.updateCell(model: self.tableViewRowDatas[indexPath.row])
        return cell
    }
}

extension KRDetailTransactionVC {
    /// 请求历史数据
    private func requestHistoryData(instrument_id: Int64, oid: Int64) {
        if XUserDefault.getToken() == nil || SLPlatformSDK.sharedInstance().activeAccount == nil || instrument_id == 0 || oid == 0 {
            self.endRefresh()
            return
        }
        BTContractTool.getUserDetailHistoryOrder(withContractID: instrument_id, orderID: oid, success: { (res: [BTContractTradeModel]?) in
            if let modelArray = res {
                self.tableViewRowDatas = modelArray
            } else {
                self.tableViewRowDatas = []
            }
            self.contentTableView.reloadData()
            self.endRefresh()
        }) { (error) in
            self.endRefresh()
        }
    }
    
    private func endRefresh(){
//        self.contentTableView.mj_header?.endRefreshing()
    }
}

extension KRDetailTransactionVC {
    private func showDetailAlert(model: BTContractOrderModel, detailType: KRSwapTransactionDetailType) {
        // 强平明细
        if detailType == .force {
            self.showForceDetailAlert(model: model)
        }
        // 减仓明细
        else if detailType == .reduce {
            self.showReduceDetailAlert(model: model)
        }
    }
    
    /// 显示强平明细
    private func showForceDetailAlert(model: BTContractOrderModel) {
        BTContractTool.getEserLiqRecords(withContractID: model.contractInfo.instrument_id, orderID: model.oid, success: { (result) in
            if let array = result as? Array<BTContractLipRecordModel> {
                let liprecord = array.first
                liprecord?.coinCode = model.name
                liprecord?.marginCoin = model.contractInfo.margin_coin
                var message = ""
                var tip1 = "contract_transaction_force_detail_tip0".localized()
                var tip2 = "contract_transaction_force_detail_tip1".localized()
                
                let time = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: liprecord?.created_at), format: "yyyy/MM/dd HH:mm") ?? "--"
                tip1 = tip1.replacingOccurrences(of: "%1$s", with: time)
                tip1 = tip1.replacingOccurrences(of: "%2$s", with: liprecord?.coinCode ?? "-")
                tip1 = tip1.replacingOccurrences(of: "%3$s", with: String(format: "%@%@", liprecord?.trigger_px.toSmallPrice(withContractID:model.instrument_id) ?? "-", liprecord?.marginCoin ?? "-"))
                tip1 = tip1.replacingOccurrences(of: "%4$s", with: liprecord?.coinCode ?? "-")
                tip1 = tip1.replacingOccurrences(of: "%5$s", with: ((liprecord?.mmr ?? "-") as NSString).toPercentString(2))
                
                tip2 = tip2.replacingOccurrences(of: "%1$s", with: String(format: "%@%@", liprecord?.order_px ?? "-", liprecord?.marginCoin ?? "-"))
                
                message.append(tip1)
                message.append("\n\n")
                message.append(tip2)
                
                let alert = KRNormalAlert()
                alert.configAlert(title: "contract_transaction_force_detail".localized(), message: message)
                alert.alertCallback = {[weak self] idx in
                    if idx == 0 {
                        // 跳转至强平机制介绍页
                        let vc = KRWebVC()
                        vc.title = "contract_transaction_force_detail".localized()
                        vc.loadUrl(KRSwapSDKManager.shared.online_swap_Close)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                EXAlert.showAlert(alertView: alert)
            }
        }) { (error) in
        }
    }
    
    /// 显示减仓明细
    private func showReduceDetailAlert(model: BTContractOrderModel) {
        BTContractTool.getEserLiqRecords(withContractID: model.contractInfo.instrument_id, orderID: model.oid, success: { (result) in
            if let array = result as? Array<BTContractLipRecordModel> {
                let liprecord = array.first
                liprecord?.coinCode = model.name
                liprecord?.marginCoin = model.contractInfo.margin_coin
                liprecord?.forcePrice = model.markPrice
                var tip = "contract_transaction_reduce_detail_tip".localized()
                let time = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: liprecord?.created_at), format: "yyyy/MM/dd HH:mm") ?? "--"
                tip = tip.replacingOccurrences(of: "%1$s", with: time)
                tip = tip.replacingOccurrences(of: "%2$s", with: String(format: "%@%@", liprecord?.forcePrice.toSmallPrice(withContractID:model.instrument_id) ?? "-", liprecord?.marginCoin ?? "-"))
                tip = tip.replacingOccurrences(of: "%3$s", with: String(format: "%@%@", liprecord?.order_px.toSmallPrice(withContractID:model.instrument_id) ?? "-", liprecord?.marginCoin ?? "-"))
                
                let alert = KRNormalAlert()
                alert.configAlert(title: "contract_transaction_reduce_detail".localized(), message: tip)
                alert.alertCallback = {[weak self] idx in
                    if idx == 0 {
                        // 跳转至自动减仓机制介绍页
                        let vc = KRWebVC()
                        vc.title = "contract_transaction_reduce_detail".localized()
                        vc.loadUrl(KRSwapSDKManager.shared.online_swap_ADL)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                EXAlert.showAlert(alertView: alert)
            }
        }) { (error) in
        }
    }
}
