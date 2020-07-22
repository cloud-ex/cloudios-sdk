//
//  KRSwapVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/12.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

class KRSwapVc: KRNavCustomVC {
    
    /// 是否需要重置深度数据订阅 (进入详情页时不需要取消, 每次界面重新显示时重置)
    var isNeedUpdateRefreshDepthUI = true
    
    private var myDisposeBag = DisposeBag()
    
    var itemModel : BTItemModel?
    
    var itemBS: BehaviorSubject<BTItemModel> = KRSwapSDKManager.shared.currentBS
    {
        didSet {
            self.myDisposeBag = DisposeBag()
            do {
                let entity = try itemBS.value()
                guard let symbol = entity.contractInfo?.symbol else {
                    return
                }
                setTitle(symbol)
                itemBS.asObserver().subscribe(onNext: {[unowned self] (itemModel) in
                    self.updateItemModel(itemModel)
                }).disposed(by: self.myDisposeBag)
            } catch {

            }
        }
    }
    
    private var cubWorkItems: [DispatchWorkItem] = []
    private var cubWorkQueue = DispatchQueue.init(label: "ink.bymex.bourse.cubWorkQueue")
    
    let modeSubject : BehaviorSubject<String> = BehaviorSubject(value:XUserDefault.getSwapMode())
    
    var currentMode = XUserDefault.getSwapMode()
    //MARK:-导航条
    lazy var switchModeBtn:UIButton = {
        let object = UIButton()
        object.extSetCornerRadius(4)
        object.extSetBorderWidth(1, color: UIColor.ThemeLabel.colorHighlight)
        object.extSetAddTarget(self, #selector(clickSwitchMode))
        object.extSetTitle("逐仓10X", 14, UIColor.ThemeLabel.colorHighlight, .normal)
        return object
    }()
    
    lazy var moreBtn: UIButton = {
        let object = UIButton()
        object.extSetImages([UIImage.themeImageNamed(imageName: "asset_more")], controlStates: [.normal])
        object.rx.tap.subscribe(onNext:{ [weak self] in
            self?.actionShowMore()
        }).disposed(by: disposeBag)
        return object
    }()
    //MARK:-内容
    lazy var lightView : KRSwapLightView = {
        let object = KRSwapLightView()
        return object
    }()
    lazy var proView: KRSwapProView = {
        let object = KRSwapProView()
        object.isHidden = true
        object.jumpToDetailVC = {[unowned self] in
            let vc = KRMarketDetailVc()
            vc.itemBS = self.itemBS
            vc.setTitle(self.itemModel?.contractInfo.symbol ?? "")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        object.jumpToPositionVC = {[weak self] entity in
            guard let mySelf = self else {return}
            let vc = KRSwapPositionVc()
            vc.itemBS = mySelf.itemBS
            mySelf.navigationController?.pushViewController(vc, animated: true)
        }
        object.refreshOrderBook = {[weak self] needSub in
            self?.kr_swapVcWillApear(needSub)
        }
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews([lightView,proView])
        lightView.snp.makeConstraints { (make) in
            make.top.equalTo(navCustomView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-TABBAR_HEIGHT)
        }
        proView.snp.makeConstraints { (make) in
            make.top.equalTo(navCustomView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-TABBAR_HEIGHT)
        }
        setNoti()
        bindSubject()
        self.itemBS = KRSwapSDKManager.shared.currentBS
    }
    override func setNavCustomV() {
        self.navtype = .swap
        self.navCustomView.setRightModule([moreBtn,switchModeBtn], rightSize: [(24,24),(72,30)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentMode == "1" { // 专业模式
            isNeedUpdateRefreshDepthUI = true
        }
        kr_swapVcWillApear()
        addSocketSubscribe()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isNeedUpdateRefreshDepthUI = false
        removeSocketSubscribe()
    }
    
    override func pushVc() {
        let vc = KRSwapDrawerVc()
        vc.didSelectItem = {[unowned self] itemBS in
            KRSwapSDKManager.shared.currentBS = itemBS
            self.switchItemModelBS(itemBS)
        }
        self.gy_showSide(configuration: { (config) in
        }, viewController: vc)
    }
    
    func bindSubject() {
        modeSubject.asObserver().subscribe {[weak self] (mode) in
            guard let mySelf = self else{return}
            if mode.element == "1" {
                mySelf.navCustomView.backView.backgroundColor = UIColor.ThemeView.bg
                mySelf.refreshLeverage(mySelf.itemModel?.instrument_id ?? 0)
                mySelf.proView.setStatus(true)
                mySelf.lightView.setStatus(false)
            } else {
                mySelf.navCustomView.backView.backgroundColor = UIColor.ThemeTab.bg
                mySelf.lightView.setStatus(true)
                mySelf.proView.setStatus(false)
                mySelf.switchModeBtn.extSetTitle("闪电模式".localized(), 14, UIColor.ThemeLabel.colorHighlight, .normal)
            }
        }.disposed(by: self.disposeBag)
    }
    
    // 切换合约
    func switchItemModelBS(_ newBS : BehaviorSubject<BTItemModel>) {
        do {
            let new_entity = try newBS.value()
            let old_entity = try itemBS.value()
            if new_entity.instrument_id == old_entity.instrument_id,new_entity.instrument_id > 0 {
                return
            }
            self.setTitle(new_entity.contractInfo.symbol)
            // 存下选中的合约
            XUserDefault.setDefaultSwapID(new_entity.instrument_id)
            
            self.itemBS = newBS
            // 订阅深度
            SLSDK.sl_loadOrderBooks(withContractID: new_entity.instrument_id,
                                    price: new_entity.last_px,
                                    count: 5,
                                    success: {[weak self](depthModel) in
                                        if self?.currentMode == "1" {
                                            self?.proView.makeOrderTC.priceInfoV.refreshOrderBook()
                                        } else {
                                            self?.lightView.updataLightOpenPx()
                                        }
                                        self?.addSocketSubscribe()
                                        
            }) {[weak self] (error) in
                self?.addSocketSubscribe()
            }
            // 更新全局杠杆
            updateLeverageItem(new_entity)
        } catch {
            
        }
    }
    
    func setNoti() {
        // MARK:- 当接口请求ticker数据更新时候获得通知
        _ = NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: MARKET_TICKER_LOADED_NOTI))
            .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
            .subscribe(onNext: {[weak self] notification in
                guard let mySelf = self else {return}
                mySelf.itemBS = KRSwapSDKManager.shared.currentBS
            })
        // MARK:- 合约私有信息
        _ = NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: BTSocketDataUpdate_Contract_Unicast_Notification))
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: {[weak self] notification in
                guard let mySelf = self else {return}
                mySelf.performSelector(inBackground: #selector(mySelf.websocketUpdataUnicast(_:)), with: notification)
            })
        // MARK:- 用户合约资产刷新通知
        _ = NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: BTFutureProperty_Notification))
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: {[weak self] notification in
                guard let mySelf = self else {return}
                mySelf.websocketUpdataProperty(notification)
            })
        // MARK:- 监听登录成功、退出登录
        _ = NotificationCenter.default.rx
        .notification(Notification.Name(rawValue: KRLoginStatus))
        .takeUntil(self.rx.deallocated)
        .subscribe(onNext:{ [weak self] notification in
            guard let mySelf = self else {
                return
            }
            mySelf.handleLoginSuccess(notification as NSNotification)
        })
        // 深度监听
        _ = NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: BTSocketDataUpdate_Contract_Depth_Notification))
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext:{ [weak self] notification in
                guard let mySelf = self,
                    let instrument_id = notification.userInfo!["instrument_id"] as? Int64 else {
                    return
                }
                if instrument_id == mySelf.itemModel?.instrument_id {
                    if mySelf.currentMode == "1" {
                        mySelf.proView.makeOrderTC.priceInfoV.refreshOrderBook()
                    } else {
                        mySelf.lightView.updataLightOpenPx()
                    }
                }
            })
        
        // MARK:- Token 失效
    }
    
    deinit {
        cubWorkItems.cancelPendingItems()
        cubWorkItems = []
    }
    
    /// 添加 socket 订阅
    private func addSocketSubscribe() {
        guard let instrument_id = itemModel?.instrument_id, instrument_id > 0 else {
            return
        }
        SLSocketDataManager.sharedInstance().sl_subscribeContractDepthData(withInstrument: instrument_id)
    }
    
    // 取消订阅
    private func removeSocketSubscribe() {
        guard let instrument_id = itemModel?.instrument_id, instrument_id > 0 else {
            return
        }
        SLSocketDataManager.sharedInstance().sl_unSubscribeContractDepthData(withInstrument: instrument_id)
    }
}

// MARK:- handle Notification
extension KRSwapVc {
    // 登录成功请求
    private func handleLoginSuccess(_ notification :NSNotification) {
        guard let instrument_id = self.itemModel?.instrument_id else {
            return
        }
        guard let object = notification.object as? [String:String] else {
            return
        }
        guard let status = object["status"] else {
            return
        }
        if status == "1" {
            if currentMode == "1" {
                // 获取全局杠杆
                KRLeverageManager.shared.getGlobalLeverage(instrumentId: instrument_id, successCallback: {[weak self] (entity) in
                    self?.refreshLeverage(instrument_id)
                })
                // 请求仓位
                proView.proVM.requestPositionData(instrument_id)
                // 请求订单
                proView.proVM.requestTransitionData(proView.proVM.cellIdentifier)
                proView.makeOrderTC.makeOrderV.moreOrEmptySegment()
            } else {
                // 获取全局杠杆
                KRLeverageManager.shared.getGlobalLeverage(instrumentId: instrument_id)
                // 请求仓位
                lightView.lightVM.requestPositionData(instrument_id)
                // 请求订单
                lightView.lightVM.requestTransitionData(lightView.lightVM.cellIdentifier)
            }
        } else {
            if currentMode == "1" {
                proView.makeOrderTC.makeOrderV.moreOrEmptySegment()
                proView.clearProSwapData()
            } else {
                lightView.updateLightPositionView([])
            }
        }
    }
    
    private func websocketUpdataProperty(_ notify: Notification) {
        // 刷新下单区域数据
        updateItemModel(self.itemModel)
        KRSwapSDKManager.krShowOpenSwapAlert(self.itemModel)
    }
    
    @objc private func websocketUpdataUnicast(_ notify: Notification) {
        let item = DispatchWorkItem.init { [weak self] in
            guard let mySelf = self else { return }
            var items = mySelf.cubWorkItems
            items.cancelPendingItems()
            mySelf.cubWorkItems = items
            guard let socketModelArray = notify.userInfo?["data"] as? [BTWebSocketModel] else {
                return
            }
            if mySelf.currentMode == "1" { // 专业模式
                mySelf.proView.proVM.wsDealOrder(socketModelArray)
                mySelf.proView.proVM.wsDealPosition(socketModelArray)
            } else {
                mySelf.lightView.lightVM.wsDealPosition(socketModelArray)
            }
        }
        cubWorkQueue.sync(execute: item)
    }
}

// MARK:- action
extension KRSwapVc {
    
    func showSwitchModeSheet() {
        let sheet = KRSwitchModeSheet()
        sheet.switchModeCallbackBlock = {[weak self] mode in
            self?.currentMode = mode
            self?.modeSubject.onNext(mode)
        }
        EXAlert.showSheet(sheetView: sheet)
    }
    
    @objc func clickSwitchMode() {
        if self.currentMode == "1" { // 专业模式
            guard let instrument_id = itemModel?.instrument_id else {
                return
            }
            guard SLPlatformSDK.sharedInstance()?.activeAccount != nil else {
                KRBusinessTools.showLoginVc(self)
                return
            }
            let orders = SLPersonaSwapInfo.sharedInstance()?.getOrders(instrument_id) ?? []
            let positions = SLPersonaSwapInfo.sharedInstance()?.getPositions(instrument_id) ?? []
            if orders.count > 0 || positions.count > 0 {
                EXAlert.showWarning(msg: "存在当前持仓或委托，不可调整杠杆".localized())
                return
            }
            let sheet = KRAdjustLeverageSheet()
            sheet.instrumentId = instrument_id
            sheet.leverageMultipleSelected = {[weak self] (leverageItem) in
                guard let mySelf = self else { return }
                mySelf.refreshLeverage(mySelf.itemModel?.instrument_id ?? 0)
                EXAlert.dismiss()
            }
            EXAlert.showSheet(sheetView: sheet)
        } else {
            showSwitchModeSheet()
        }
    }
    
    func actionShowMore() {
        let moreV = KRBouncedAlert()
        if currentMode == "0" { // 闪电模式
            moreV.setData(KRSwapInfoManager.getSwapLightMoreEntity())
        } else if currentMode == "1" {
            moreV.setData(KRSwapInfoManager.getSwapProfesionMoreEntity())
        }
        moreV.clickViewBlock = {[weak self] tag in
            guard let mySelf = self else{return}
            switch tag {
            case "资金划转".localized():
                guard SLPlatformSDK.sharedInstance()?.activeAccount != nil else {
                    KRBusinessTools.showLoginVc(self)
                    return
                }
                let vc = KRTransferVc()
                mySelf.navigationController?.pushViewController(vc, animated: true)
            case "合约信息".localized():
                let vc = KRSwapInfoVc()
                vc.itemModel = mySelf.itemModel
                mySelf.navigationController?.pushViewController(vc, animated: true)
            case "仓位信息".localized():
                guard SLPlatformSDK.sharedInstance()?.activeAccount != nil else {
                    KRBusinessTools.showLoginVc(self)
                    return
                }
                let vc = KRSwapPositionVc()
                vc.itemBS = mySelf.itemBS
                mySelf.navigationController?.pushViewController(vc, animated: true)
            case "委托信息".localized():
                let vc = KRAllTransactionsVc()
                vc.vm.itemModel = mySelf.itemModel
                mySelf.navigationController?.pushViewController(vc, animated: true)
            case "合约设置".localized():
                let vc = KRSwapSetingVc()
                vc.selectUnitBlock = {[weak self] in
                    self?.proView.makeOrderTC.makeOrderV.refreshUnit()
                    self?.proView.makeOrderTC.priceInfoV.refreshPriceUnit()
                }
                mySelf.navigationController?.pushViewController(vc, animated: true)
            case "模式切换".localized():
                mySelf.showSwitchModeSheet()
                break
            default:
                break
            }
        }
        moreV.show()
    }
}

// MARK: - Data

extension KRSwapVc {
    // 进入合约页面纠错(以防万一)
    private func kr_swapVcWillApear(_ needRefresh:Bool=false) {
        guard let entity = self.itemModel else {
            return
        }
        if SLPublicSwapInfo.sharedInstance()!.hasCurrentDepthModel() == false || needRefresh {
            SLSDK.sl_loadOrderBooks(withContractID: entity.instrument_id,
                                    price: entity.last_px,
                                    count: 5,
                                    success: {[weak self] (depthModel) in
                                        if self?.currentMode == "1" {
                                            self?.proView.makeOrderTC.priceInfoV.refreshOrderBook()
                                        } else {
                                            self?.lightView.updataLightOpenPx()
                                        }
                                        if needRefresh {
                                            self?.addSocketSubscribe()
                                        }
            }) { (error) in
                
            }
        }
    }
    
    // ticker数据更新
    private func updateItemModel(_ itemModel: BTItemModel?) {
        guard let entity = itemModel else {
            return
        }
        self.itemModel = itemModel
        if self.currentMode == "1" {
            proView.proVM.itemModel = entity
        } else {
            lightView.lightVM.itemModel = entity
        }
    }
    // 切换合约更新杠杆
    private func updateLeverageItem(_ itemModel: BTItemModel?) {
        guard let entity = itemModel,SLPlatformSDK.sharedInstance()?.activeAccount != nil else {
            return
        }
        KRLeverageManager.shared.getGlobalLeverage(instrumentId:entity.instrument_id, successCallback: {[weak self] _ in
            guard let mySelf = self else { return }
            mySelf.refreshLeverage(entity.instrument_id)
        }) { (error) in
            
        }
    }
    private func refreshLeverage(_ instrument_id : Int64) {
        guard instrument_id > 0 else {
            return
        }
        let leverageNum = KRLeverageManager.shared.refreshLeverage(instrument_id)
        switchModeBtn.setTitle(leverageNum, for: .normal)
    }
}
