//
//  KRSwapLightView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/17.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//  闪电模式

import Foundation
import RxSwift

class KRSwapLightView: KRBaseV {
    
    private var myDisposeBag = DisposeBag()
    
    var lightVM = KRSwapVM()
    
    lazy var kLineView: KRSwapDetailChartView = {
        let object = KRSwapDetailChartView()
        object.clipsToBounds = true
        return object
    }()
    
    lazy var positionView: KRLightPositionView = {
        let object = KRLightPositionView()
        object.isHidden = true
        object.cancelLightPositionBlock = { [weak self] entity in
            self?.lightVM.requestClosePositionData(entity)
        }
        return object
    }()
    
    private lazy var buyButton: KRSwapLightBtn = {
        let object = KRSwapLightBtn()
        object.extsetBackgroundColor(backgroundColor: UIColor.ThemekLine.up, state: .normal)
        object.setName("开多".localized())
        object.extSetAddTarget(self, #selector(openButtonClick))
        return object
    }()
    
    private lazy var sellButton: KRSwapLightBtn = {
        let object = KRSwapLightBtn()
        object.extsetBackgroundColor(backgroundColor: UIColor.ThemekLine.down, state: .normal)
        object.setName("开空".localized())
        object.extSetAddTarget(self, #selector(openButtonClick))
        return object
    }()
    
    override func setupSubViewsLayout() {
        backgroundColor = UIColor.ThemeTab.bg
        addSubViews([kLineView, positionView, buyButton, sellButton])
        buyButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH * 0.5)
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
        sellButton.snp.makeConstraints { (make) in
            make.left.equalTo(buyButton.snp.right)
            make.right.equalToSuperview()
            make.height.bottom.equalTo(buyButton)
        }
        kLineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-44)
        }
        positionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(buyButton.snp_top).offset(-8)
            make.height.equalTo(164)
        }
        bindVM()
    }
    
    private func bindVM() {
        lightVM.setLightV(self)
        lightVM.swapPositionList.asObserver().subscribe(onNext: {[unowned self] (positions) in
            DispatchQueue.main.async {
                self.updateLightPositionView(positions)
            }
        }).disposed(by: self.disposeBag)
    }
    
    func setStatus(_ status:Bool) {
        self.isHidden = !status
        if !status { // 取消订阅k线数据
            self.kLineView.unSubKLineWS()
        } else { // 订阅K线数据
            self.kLineView.reloadConnectKLine()
        }
    }
}

extension KRSwapLightView {
    
    // 更新买卖盘第三档价格
    func updataLightOpenPx() {
        let askPx = SLPublicSwapInfo.sharedInstance()?.getBidOrderBooks(3)?.last?.px ?? "0"
        let bidPx = SLPublicSwapInfo.sharedInstance()?.getAskOrderBooks(3)?.last?.px ?? "0"
        buyButton.setPx(bidPx)
        sellButton.setPx(askPx)
    }
    
    // 请求仓位数据
    func reloadPositionData() {
        lightVM.requestPositionData(lightVM.itemModel?.instrument_id ?? 0)
    }
    
    // 闪电下单
    @objc func openButtonClick(sender:KRSwapLightBtn) {
        guard XUserDefault.getToken() != nil && SLPlatformSDK.sharedInstance()?.activeAccount != nil else {
            KRBusinessTools.showLoginVc(self.yy_viewController)
            return
        }
        var side = BTContractOrderWay.buy_OpenLong
        if sender == sellButton {
            side = BTContractOrderWay.sell_OpenShort
        }
        let lightOrderV = KRLightOrderSheet()
        lightOrderV.configOrder(sender.pxLabel.text ?? "0", side, lightVM.itemModel)
        lightOrderV.clickSwapLightSubmitBlock = {[weak self] order in
            guard let entity = order else {
                return
            }
            self?.lightVM.sendServerOrder(order: entity) { res in
                if res == true {
                    EXAlert.dismissEnd {
                        EXAlert.showSuccess(msg: "下单成功".localized())
                    }
                }
            }
        }
        EXAlert.showSheet(sheetView: lightOrderV)
    }
    
    // 更新仓位信息
    public func updateLightPositionView(_ positions : [BTPositionModel]) {
        if positions.count > 0 {
            positionView.isHidden = false
            kLineView.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(-216)
            }
        } else {
            positionView.isHidden = true
            kLineView.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(-44)
            }
        }
        positionView.setView(positions)
    }
}



