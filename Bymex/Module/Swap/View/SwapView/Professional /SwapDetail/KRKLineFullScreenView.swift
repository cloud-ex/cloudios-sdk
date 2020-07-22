//
//  KRKLineFullScreenView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/7.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class KRKLineFullScreenView: UIView {
    
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
            self.kLineVM.requestKLineData(timeType: timeView.currentTimeType, contract_id: model.instrument_id) { (chartItems) in
                XHUDManager.dismiss()
                self.reloadData(data: chartItems ?? [])
                // socket 订阅
                self.kLineVM.subscribKLineSocketData(contract_id: model.instrument_id, timeType: self.timeView.currentTimeType)
            }
            self.topView.setView(itemModel)
        }
    }
    
    private lazy var kLineVM: KRSwapKLineVM = KRSwapKLineVM()
    
    var kLineConfig: KRKLineConfig = KRKLineConfig() {
        didSet {
            self.timeView.changeTimeType(timeType: kLineConfig.currentTimeType)
            self.settingIndexView.changeMainSettingIndex(name: kLineConfig.currentMainName)
            self.settingIndexView.changeSubSettingIndex(name: kLineConfig.currentSubName)
        }
    }
    
    lazy var topView: KRKLineFullTopView = {
        let v = KRKLineFullTopView()
        return v
    }()
    
    private lazy var chartView: KRKLineView = {
        let chartView = KRKLineView(frame: .zero)
        chartView.isFullScreen = true
        return chartView
    }()
    
    private lazy var settingIndexView: KRKLineFullSettingIndexView = {
        let v = KRKLineFullSettingIndexView()
        return v
    }()
    
    private lazy var timeView: KRKLineFullTimeView = {
        let v = KRKLineFullTimeView()
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        backgroundColor = .black
        addSubViews([topView, chartView, settingIndexView, timeView])
        
        settingIndexView.mainIndexChanged = {[weak self] name in
            guard let wSelf = self else { return }
            wSelf.kLineConfig.currentMainName = name
            wSelf.chartView.changeKLineStyle(timeType: wSelf.kLineConfig.currentTimeType, mainName: name, subName: wSelf.kLineConfig.currentSubName)
        }
        
        settingIndexView.subIndexChanged = {[weak self] name in
            guard let wSelf = self else { return }
            wSelf.kLineConfig.currentSubName = name
            wSelf.chartView.changeKLineStyle(timeType: wSelf.kLineConfig.currentTimeType, mainName: wSelf.kLineConfig.currentMainName, subName: name)
        }
        
        timeView.timeTypeChanged = {[weak self] timeType in
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
        
        kLineVM.reciveKLineSocketData = {[weak self] itemArr in
            guard let wSelf = self else { return }
            wSelf.chartView.appendData(data: itemArr)
        }
    }
    
    private func initLayout() {
        topView.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.height.equalTo(40)
            make.left.equalTo(NAV_TOP)
        }
        settingIndexView.snp.makeConstraints { (make) in
            make.bottom.equalTo(timeView.snp.top)
            make.right.equalTo(0)
            make.width.equalTo(50+TABBAR_BOTTOM)
            make.top.equalTo(topView.snp.bottom)
        }
        chartView.snp.makeConstraints { (make) in
            make.left.equalTo(topView)
            make.top.equalTo(topView.snp.bottom)
            make.right.equalTo(settingIndexView.snp.left)
        }
        timeView.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
            make.left.equalTo(chartView)
            make.height.equalTo(40)
            make.top.equalTo(chartView.snp.bottom)
        }
    }
}

// MARK: - load data
extension KRKLineFullScreenView {
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


// MARK: - KRKLineFullTopView

class KRKLineFullTopView: UIView {
    var closeCallback: (() -> Void)?
    
    lazy var nameLabel: UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyBold, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    lazy var lastPxLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyBold, textColor: UIColor.ThemekLine.up, alignment: .left)
        return object
    }()
    lazy var rateLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemekLine.up, alignment: .center)
        return object
    }()
    lazy var fairPxLabel : KRHorLabel = {
        let object = KRHorLabel()
        object.setLeftText("合理价格".localized())
        object.setRightText("--")
        return object
    }()
    lazy var indexPxLabel : KRHorLabel = {
        let object = KRHorLabel()
        object.setLeftText("指数价格".localized())
        object.setRightText("--")
        return object
    }()
    lazy var dayQtyLabel : KRHorLabel = {
        let object = KRHorLabel()
        object.setLeftText("24h量".localized())
        object.setRightText("--")
        return object
    }()
    
    private lazy var closeButton: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(clickClose), for: .touchUpInside)
        v.extSetImages([UIImage.themeImageNamed(imageName: "closed")], controlStates: [.normal])
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        addSubViews([nameLabel, closeButton, lastPxLabel, rateLabel,fairPxLabel,indexPxLabel,dayQtyLabel])
    }
    
    private func initLayout() {
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(100)
        }
        lastPxLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.top.bottom.equalToSuperview()
             make.width.lessThanOrEqualTo(100)
        }
        rateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lastPxLabel.snp.right).offset(5)
            make.height.equalTo(20)
            make.centerY.equalTo(nameLabel)
            make.width.equalTo(40)
        }
        closeButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
        dayQtyLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-56)
            make.centerY.equalToSuperview()
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(120)
        }
        indexPxLabel.snp.makeConstraints { (make) in
            make.right.equalTo(dayQtyLabel.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(120)
        }
        fairPxLabel.snp.makeConstraints { (make) in
            make.right.equalTo(indexPxLabel.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(120)
        }
    }
    
    @objc private func clickClose() {
        closeCallback?()
    }
    
    func setView(_ entity : BTItemModel?) {
        guard let itemModel = entity else {
            return
        }
        nameLabel.text = itemModel.symbol ?? "-"
        lastPxLabel.text = itemModel.last_px?.toSmallEditPriceContractID(itemModel.instrument_id) ?? "-"
        rateLabel.text = itemModel.change_rate?.toPercentString(2) ?? "-"
        fairPxLabel.setRightText(itemModel.fair_px?.toSmallEditPriceContractID(itemModel.instrument_id) ?? "-")
        indexPxLabel.setRightText(itemModel.index_px?.toSmallEditPriceContractID(itemModel.instrument_id) ?? "-")
        dayQtyLabel.setRightText(itemModel.qty24.count > 0 ? BTFormat.depthValue(fromNumberStr: itemModel.qty24) : "0")
    }
}

// MARK: - KRKLineFullSettingIndexView

class KRKLineFullSettingIndexView: UIView {
    
    var mainIndexChanged: ((_ algorithm: KRSeriesName?) -> Void)?
    var subIndexChanged: ((_ algorithm: KRSeriesName?) -> Void)?
    
    private var selectedMainButton: UIButton?
    private var selectedSubButton: UIButton?
    
    private var normalColor = UIColor.ThemeLabel.colorDark
    private var selectedColor = UIColor.ThemeLabel.colorHighlight
    
    private lazy var contentStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.distribution = .fillEqually
        v.spacing = 0
        v.alignment = .fill
        return v
    }()
    /// 主图
    private lazy var mainTitle: UILabel = {
        let label = UILabel()
        label.text = "主图".localized()
        label.textAlignment = .center
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    private lazy var maBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(KRSeriesName.ma.rawValue, for: .normal)
        btn.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
        btn.setTitleColor(normalColor, for: .normal)
        btn.setTitleColor(selectedColor, for: .selected)
        btn.addTarget(self, action: #selector(mainButtonClick(sender:)), for: .touchUpInside)
        btn.isSelected = true
        return btn
    }()
    private lazy var bollBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(KRSeriesName.boll.rawValue, for: .normal)
        btn.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
        btn.setTitleColor(normalColor, for: .normal)
        btn.setTitleColor(selectedColor, for: .selected)
        btn.addTarget(self, action: #selector(mainButtonClick(sender:)), for: .touchUpInside)
        return btn
    }()
    private lazy var mainEyeBtn: UIButton = {
        let btn = UIButton()
        btn.extSetImages([UIImage.themeImageNamed(imageName: "visible"),UIImage.themeImageNamed(imageName: "hide")], controlStates: [.normal,.selected])
        btn.addTarget(self, action: #selector(mainEyeButtonClick), for: .touchUpInside)
        return btn
    }()

    /// 副图
    private lazy var subTitle: UILabel = {
        let label = UILabel()
        label.text = "副图".localized()
        label.textAlignment = .center
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    private lazy var macdBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(KRSeriesName.macd.rawValue, for: .normal)
        btn.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
        btn.setTitleColor(normalColor, for: .normal)
        btn.setTitleColor(selectedColor, for: .selected)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(subButtonClick(sender:)), for: .touchUpInside)
        return btn
    }()
    private lazy var kdjBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(KRSeriesName.kdj.rawValue, for: .normal)
        btn.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
        btn.setTitleColor(normalColor, for: .normal)
        btn.setTitleColor(selectedColor, for: .selected)
        btn.addTarget(self, action: #selector(subButtonClick(sender:)), for: .touchUpInside)
        return btn
    }()
    private lazy var rsiBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(KRSeriesName.rsi.rawValue, for: .normal)
        btn.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
        btn.setTitleColor(normalColor, for: .normal)
        btn.setTitleColor(selectedColor, for: .selected)
        btn.addTarget(self, action: #selector(subButtonClick(sender:)), for: .touchUpInside)
        return btn
    }()
    private lazy var subEyeBtn: UIButton = {
        let btn = UIButton()
        btn.extSetImages([UIImage.themeImageNamed(imageName: "visible"),UIImage.themeImageNamed(imageName: "hide")], controlStates: [.normal,.selected])
        btn.addTarget(self, action: #selector(subEyeButtonClick), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        backgroundColor = .black
        layer.borderColor = normalColor.cgColor
        
        addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(mainTitle)
        contentStackView.addArrangedSubview(maBtn)
        contentStackView.addArrangedSubview(bollBtn)
        contentStackView.addArrangedSubview(mainEyeBtn)
        contentStackView.addArrangedSubview(subTitle)
        contentStackView.addArrangedSubview(macdBtn)
        contentStackView.addArrangedSubview(kdjBtn)
        contentStackView.addArrangedSubview(rsiBtn)
        contentStackView.addArrangedSubview(subEyeBtn)
        
        selectedMainButton = maBtn
        selectedSubButton = macdBtn
    }
    
    private func initLayout() {
        contentStackView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(-TABBAR_BOTTOM)
        }
    }
    
    
    func changeMainSettingIndex(name: KRSeriesName?) {
        if let _name = name {
            for btn in contentStackView.subviews where btn is UIButton {
                if (btn as! UIButton).currentTitle == _name.rawValue {
                    mainButtonClick(sender: btn as! UIButton)
                    break
                }
            }
        } else {
            mainEyeButtonClick(mainEyeBtn)
        }
    }
    
    func changeSubSettingIndex(name: KRSeriesName?) {
        if let _name = name {
            for btn in contentStackView.subviews where btn is UIButton {
                if (btn as! UIButton).currentTitle == _name.rawValue {
                    subButtonClick(sender: btn as! UIButton)
                    break
                }
            }
        } else {
            subEyeButtonClick(subEyeBtn)
        }
    }
}

extension KRKLineFullSettingIndexView {
    @objc private func mainButtonClick(sender: UIButton) {
        if sender == selectedMainButton {
            return
        }
        selectedMainButton?.isSelected = false
        selectedMainButton = sender
        selectedMainButton?.isSelected = true
        
        mainEyeBtn.isSelected = false
        
        mainIndexChanged?(KRSeriesName(rawValue: sender.currentTitle ?? ""))
    }
    
    @objc private func mainEyeButtonClick(_ sender : UIButton) {
        sender.isSelected = true
        selectedMainButton?.isSelected = false
        selectedMainButton = nil
        
        mainIndexChanged?(nil)
    }
    
    @objc private func subButtonClick(sender: UIButton) {
        if sender == selectedSubButton {
            return
        }
        selectedSubButton?.isSelected = false
        selectedSubButton = sender
        selectedSubButton?.isSelected = true
        
        subEyeBtn.isSelected = false
        
        subIndexChanged?(KRSeriesName(rawValue: sender.currentTitle ?? ""))
    }
    
    @objc private func subEyeButtonClick(_ sender: UIButton) {
        sender.isSelected = true
        selectedSubButton?.isSelected = false
        selectedSubButton = nil
        
        subIndexChanged?(nil)
    }
}


// MARK: - KRKLineFullTimeView

class KRKLineFullTimeView: UIView {
    
    var currentTimeType: KRKLineTimeType = .k_5min
    
    var timeTypeChanged: ((KRKLineTimeType) -> Void)?

    private let timeTypes: [KRKLineTimeType] = [.k_timeline, .k_1min, .k_5min, .k_15min, .k_30min, .k_1hour, .k_4hour, .k_1day, .k_1week, .k_1mon]
    
    private lazy var defaultBgView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()
    
    private lazy var defaultStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.distribution = .fillEqually
        v.spacing = 0
        v.alignment = .fill
        return v
    }()
    
    private lazy var indicatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.ThemeLabel.colorHighlight
        line.layer.cornerRadius = 0.5
        line.layer.masksToBounds = true
        return line
    }()
    
    private var selectedDuration: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        backgroundColor = .black
        for (i, timeType) in timeTypes.enumerated() {
            let btn = createDurationButton(title: timeType.rawValue)
            btn.tag = i
            btn.addTarget(self, action: #selector(changeTimeType(sender:)), for: .touchUpInside)
            defaultStackView.addArrangedSubview(btn)
            if timeType == currentTimeType {
                selectedDuration = btn
            }
        }
        defaultStackView.addSubview(indicatorLine)
        defaultBgView.addSubview(defaultStackView)
        addSubview(defaultBgView)
    }
    
    private func initLayout() {
        defaultStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        defaultBgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        indicatorLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(20)
            make.centerX.equalTo(selectedDuration)
        }
        setNeedsLayout()
    }
    
    private func createDurationButton(title: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
        btn.setTitleColor(UIColor.ThemeLabel.colorDark, for: .normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .selected)
        return btn
    }
    
    @objc private func changeTimeType(sender: UIButton) {
        if selectedDuration == sender {
            return
        }
        selectedDuration.isSelected = false
        selectedDuration = sender
        selectedDuration.isSelected = true
        
        currentTimeType = KRKLineTimeType(rawValue: sender.currentTitle ?? "") ?? .k_5min
        
        updateIndicatorLineLayout(view: sender)
        
        timeTypeChanged?(currentTimeType)
    }
    
    private func updateIndicatorLineLayout(view: UIView) {
        self.indicatorLine.snp.remakeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(20)
            make.centerX.equalTo(view)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.defaultStackView.setNeedsLayout()
            self.defaultStackView.layoutIfNeeded()
        }
    }
    
    
    func changeTimeType(timeType: KRKLineTimeType) {
        if timeTypes.contains(timeType) {
            for btn in defaultStackView.subviews where btn is UIButton {
                if (btn as! UIButton).currentTitle == timeType.rawValue {
                    changeTimeType(sender: btn as! UIButton)
                    break
                }
            }
        }
    }
}
