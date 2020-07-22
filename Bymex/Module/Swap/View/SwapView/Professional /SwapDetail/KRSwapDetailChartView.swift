//
//  KRSwapDetailChartView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/24.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSwapDetailChartView: KRBaseV {

    var kLineDataArray: [KRChartItem] = []
    
    var itemModel: BTItemModel? {
        didSet {
            guard let model = itemModel else {
                return
            }
            if kLineDataArray.count > 0 || oldValue?.instrument_id == itemModel?.instrument_id {
                return
            }
            XHUDManager.show()
            self.kLineVM.requestKLineData(timeType: settingView.currentDuration, contract_id: model.instrument_id) { (chartItems) in
                XHUDManager.dismiss()
                self.reloadData(data: chartItems ?? [])
                self.kLineVM.subscribKLineSocketData(contract_id: model.instrument_id, timeType: self.settingView.currentDuration)
            }
        }
    }
    
    lazy var kLineVM: KRSwapKLineVM = KRSwapKLineVM()
    
    var kLineConfig = KRKLineConfig() {
        didSet {
            self.settingView.changeTimeType(timeType: kLineConfig.currentTimeType)
            self.settingView.settingIndexView.changeMainSettingIndex(name: kLineConfig.currentMainName)
            self.settingView.settingIndexView.changeSubSettingIndex(name: kLineConfig.currentSubName)
        }
    }
    
    private lazy var settingView: KRKLineSettingView = {
        let v = KRKLineSettingView()
        return v
    }()
    
    lazy var chartView: KRKLineView = {
        let chartView = KRKLineView(frame: .zero)
        return chartView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initLayout()
        
        if let instrument_id = itemModel?.instrument_id {
            kLineVM.subscribKLineSocketData(contract_id: instrument_id, timeType: kLineConfig.currentTimeType)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        addSubViews([chartView, settingView])
        
        settingView.timeTypeChanged = {[weak self] timeType in
            guard let wSelf = self, let model = wSelf.itemModel else {
                return
            }
            let isNeedChangeStyle = ((timeType == .k_timeline && wSelf.kLineConfig.currentTimeType != .k_timeline) || (timeType != .k_timeline && wSelf.kLineConfig.currentTimeType == .k_timeline))
            if isNeedChangeStyle {
                wSelf.chartView.changeKLineStyle(timeType: timeType, mainName: wSelf.kLineConfig.currentMainName, subName: wSelf.kLineConfig.currentSubName)
            }
            wSelf.kLineConfig.currentTimeType = timeType
            XHUDManager.show()
            wSelf.kLineVM.requestKLineData(timeType: timeType, contract_id: model.instrument_id) { (chartItems) in
                XHUDManager.dismiss()
                wSelf.reloadData(data: chartItems ?? [])
                
                // socket 订阅
                wSelf.kLineVM.subscribKLineSocketData(contract_id: model.instrument_id, timeType: timeType)
            }
        }
        
        settingView.settingIndexView.mainIndexChanged = {[weak self] name in
            guard let wSelf = self else { return }
            wSelf.kLineConfig.currentMainName = name
            wSelf.chartView.changeKLineStyle(timeType: wSelf.kLineConfig.currentTimeType, mainName: name, subName: wSelf.kLineConfig.currentSubName)
        }
        
        settingView.settingIndexView.subIndexChanged = {[weak self] name in
            guard let wSelf = self else { return }
            wSelf.kLineConfig.currentSubName = name
            wSelf.chartView.changeKLineStyle(timeType: wSelf.kLineConfig.currentTimeType, mainName: wSelf.kLineConfig.currentMainName, subName: name)
        }
        
        kLineVM.reciveKLineSocketData = {[weak self] itemArr in
            guard let wSelf = self else { return }
            wSelf.chartView.appendData(data: itemArr)
        }
    }
    
    private func initLayout() {
        settingView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(30)
        }
        chartView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(settingView.snp.bottom)
        }
    }

    
   
}


// MARK: - load data
extension KRSwapDetailChartView {
    
    func unSubKLineWS() {
        guard let entity = itemModel else {
            return
        }
        self.kLineVM.unsubscribeKLineScoketData(contract_id: entity.instrument_id)
    }
    
    func reloadConnectKLine() {
        guard let entity = itemModel else {
            return
        }
        XHUDManager.show()
        self.kLineVM.requestKLineData(timeType: settingView.currentDuration, contract_id: entity.instrument_id) { (chartItems) in
            XHUDManager.dismiss()
            self.reloadData(data: chartItems ?? [])
            self.kLineVM.subscribKLineSocketData(contract_id: entity.instrument_id, timeType: self.settingView.currentDuration)
        }
    }
    
    func reloadData(data: [KRChartItem]) {
        if data.count == 0 {
            return
        }
        self.chartView.reloadData(data: data)
    }
    
    func appendData(data: [KRChartItem]) {
        self.chartView.appendData(data: data)
    }
}
