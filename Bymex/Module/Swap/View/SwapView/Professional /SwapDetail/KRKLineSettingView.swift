//
//  KRKLineSettingView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/2.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class KRKLineSettingView: UIView {

    var timeTypeChanged: ((KRKLineTimeType) -> Void)?
    var settingIndexChanged: ((String) -> Void)?
    
    var currentDuration: KRKLineTimeType = .k_5min
    
    private var selectedDuration: UIButton!
    
    private let timeTypes: [KRKLineTimeType] = [.k_timeline, .k_5min, .k_15min, .k_4hour]
    private let moreTimeTypes: [KRKLineTimeType] = [.k_1min, .k_30min, .k_1hour, .k_1day, .k_1week, .k_1mon]
    
    private lazy var defaultBgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.ThemeTab.bg
        return v
    }()
    
    private lazy var defaultStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.distribution = .fillEqually
        v.spacing = 0
        v.alignment = .fill
        v.backgroundColor = UIColor.ThemeTab.bg
        return v
    }()
    
    private lazy var moreStackView: UIView = {
        let view = UIView()
        let v = UIStackView()
        v.axis = .horizontal
        v.distribution = .fillEqually
        v.spacing = 0
        v.alignment = .fill
        view.extSetBorderWidth(1, color: UIColor.ThemeView.border)
        
        for (i, timeType) in moreTimeTypes.enumerated() {
            
            let btn = createDurationButton(title: timeType.rawValue)
            btn.tag = i
            btn.addTarget(self, action: #selector(changeMoreTimeType(sender:)), for: .touchUpInside)
            v.addArrangedSubview(btn)
        }
        
        view.isHidden = true
        view.backgroundColor = UIColor.ThemeTab.bg
        view.addSubview(v)
        
        v.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return view
    }()
    
    lazy var settingIndexView: KRKLineSettingIndexView = {
        let v = KRKLineSettingIndexView()
        v.backgroundColor = UIColor.ThemeTab.bg
        v.isHidden = true
        v.setNeedsLayout()
        return v
    }()
    
    private lazy var moreButton: UIButton = {
        let object = createDurationButton(title: "更多".localized())
        object.addTarget(self, action: #selector(clickMore), for: .touchUpInside)
        return object
    }()
    private lazy var moreImg : UIImageView = {
        let imgV = UIImageView.init(image: UIImage.themeImageNamed(imageName: "swap_unkline_more"))
        return imgV
    }()
    private lazy var settingButton: UIButton = {
        let btn = createDurationButton(title: "指标".localized())
        btn.addTarget(self, action: #selector(clickSetting), for: .touchUpInside)
        return btn
    }()
    
    private lazy var indicatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.ThemeLabel.colorHighlight
        line.layer.cornerRadius = 0.5
        line.layer.masksToBounds = true
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initLayout()
        moreButton.addSubview(moreImg)
        moreImg.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-5)
            make.width.height.equalTo(6)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01 ){
            return nil
        }
        let resultView  = super.hitTest(point, with: event)
        if resultView != nil {
            return resultView
        }else{
            for subView in self.subviews.reversed() {
                let convertPoint : CGPoint = subView.convert(point, from: self)
                let hitView = subView.hitTest(convertPoint, with: event)
                if (hitView != nil) {
                    return hitView
                }
            }
        }
        return nil
    }
    
    private func initUI() {
        for (i, timeType) in timeTypes.enumerated() {
            let btn = createDurationButton(title: timeType.rawValue)
            btn.tag = i
            btn.addTarget(self, action: #selector(changeTimeType(sender:)), for: .touchUpInside)
            defaultStackView.addArrangedSubview(btn)
            if i == 1 {
                selectedDuration = btn
            }
        }
        defaultStackView.addArrangedSubview(moreButton)
        defaultStackView.addArrangedSubview(settingButton)
        defaultStackView.addSubview(indicatorLine)
        defaultBgView.addSubview(defaultStackView)
        addSubViews([moreStackView, settingIndexView, defaultBgView])
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
            make.bottom.equalToSuperview()
            make.width.equalTo(20)
            make.centerX.equalTo(selectedDuration)
        }
        moreStackView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(0)
            make.height.equalToSuperview()
        }
        settingIndexView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(0)
            make.height.equalTo(30)
        }
        setNeedsLayout()
    }
    
    private func createDurationButton(title: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(UIColor.ThemeLabel.colorDark, for: .normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .selected)
        return btn
    }
    
    private func hiddenMoreStackView() {
        moreStackView.snp.remakeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(0)
            make.height.equalTo(35)
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }) { (_) in
            self.moreStackView.isHidden = true
        }
    }
    
    private func hiddenSettingIndexView() {
        settingIndexView.snp.remakeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(0)
            make.height.equalToSuperview()
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }) { (_) in
            self.settingIndexView.isHidden = true
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
        } else if moreTimeTypes.contains(timeType) {
            for btn in moreStackView.subviews.first!.subviews where btn is UIButton {
                if (btn as! UIButton).currentTitle == timeType.rawValue {
                    changeMoreTimeType(sender: btn as! UIButton)
                    break
                }
            }
        }
    }
}

extension KRKLineSettingView {
    @objc private func changeTimeType(sender: UIButton) {
        if (!moreStackView.isHidden) {
            hiddenMoreStackView()
        }
        if (!settingIndexView.isHidden) {
            hiddenSettingIndexView()
        }
        moreButton.setTitle("更多", for: .normal)
        moreImg.image = UIImage.themeImageNamed(imageName: "swap_unkline_more")
        if selectedDuration == sender {
            return
        }
        selectedDuration.isSelected = false
        selectedDuration = sender
        selectedDuration.isSelected = true
        
        currentDuration = KRKLineTimeType(rawValue: sender.currentTitle ?? "") ?? .k_5min
        
        updateIndicatorLineLayout(view: sender)
        
        timeTypeChanged?(currentDuration)
    }
    
    @objc private func clickMore() {
        if (!settingIndexView.isHidden) {
            hiddenSettingIndexView()
        }
        if moreStackView.isHidden {
            moreStackView.isHidden = false
            moreStackView.snp.remakeConstraints { (make) in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(self.height)
                make.height.equalTo(35)
            }
            UIView.animate(withDuration: 0.25) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        } else {
            hiddenMoreStackView()
        }
    }
    
    @objc private func changeMoreTimeType(sender: UIButton) {
        selectedDuration.isSelected = false
        selectedDuration = moreButton
        selectedDuration.isSelected = true
        
        moreButton.setTitle(sender.currentTitle, for: .normal)
        moreImg.image = UIImage.themeImageNamed(imageName: "swap_kline_more")
        hiddenMoreStackView()
        
        currentDuration = KRKLineTimeType(rawValue: sender.currentTitle ?? "") ?? .k_5min
        
        updateIndicatorLineLayout(view: moreButton)
        
        timeTypeChanged?(currentDuration)
    }
    
    @objc private func clickSetting() {
        if (!moreStackView.isHidden) {
            hiddenMoreStackView()
        }
        if settingIndexView.isHidden {
            settingIndexView.isHidden = false
            settingIndexView.snp.remakeConstraints { (make) in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(self.height)
                make.height.equalTo(73)
            }
            UIView.animate(withDuration: 0.25) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        } else {
            hiddenSettingIndexView()
        }
    }
    
    private func updateIndicatorLineLayout(view: UIView) {
        self.indicatorLine.snp.remakeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.width.equalTo(20)
            make.centerX.equalTo(view)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.defaultStackView.setNeedsLayout()
            self.defaultStackView.layoutIfNeeded()
        }
    }
}


class KRKLineSettingIndexView: UIView {
    
    var mainIndexChanged: ((_ algorithm: KRSeriesName?) -> Void)?
    var subIndexChanged: ((_ algorithm: KRSeriesName?) -> Void)?
    
    private var selectedMainButton: UIButton?
    private var selectedSubButton: UIButton?
    
    private var normalColor = UIColor.ThemeLabel.colorDark
    private var selectedColor = UIColor.ThemeLabel.colorHighlight
    
    /// 主图
    private lazy var mainTitle: UILabel = {
        let label = UILabel()
        label.text = "主图".localized()
        label.textAlignment = .center
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    private lazy var mainLine: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.ThemeView.seperator
        return v
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
    private lazy var middleLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
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
    private lazy var subLine: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.ThemeView.seperator
        return v
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
        layer.borderColor = UIColor.ThemeView.border.cgColor
        layer.borderWidth = 1
        addSubViews([mainTitle, mainLine, maBtn, bollBtn, mainEyeBtn, middleLine, subTitle, subLine, macdBtn, kdjBtn, rsiBtn, subEyeBtn])
        
        selectedMainButton = maBtn
        selectedSubButton = macdBtn
    }
    
    private func initLayout() {
        mainTitle.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.top.equalToSuperview()
            make.width.equalTo(50)
        }
        mainLine.snp.makeConstraints { (make) in
            make.left.equalTo(mainTitle.snp.right)
            make.centerY.equalTo(mainTitle)
            make.width.equalTo(1)
            make.height.equalTo(12)
        }
        maBtn.snp.makeConstraints { (make) in
            make.left.equalTo(mainLine.snp.right)
            make.centerY.top.equalTo(mainTitle)
            make.width.equalTo(60)
        }
        bollBtn.snp.makeConstraints { (make) in
            make.left.equalTo(maBtn.snp.right)
            make.centerY.top.equalTo(maBtn)
            make.width.equalTo(60)
        }
        middleLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(maBtn.snp.bottom)
            make.height.equalTo(1)
        }
        mainEyeBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.top.equalTo(bollBtn)
            make.width.equalTo(60)
        }
        subTitle.snp.makeConstraints { (make) in
            make.left.equalTo(mainTitle)
            make.height.equalTo(mainTitle)
            make.top.equalTo(mainTitle.snp.bottom)
            make.width.equalTo(mainTitle)
        }
        subLine.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(mainLine)
            make.centerY.equalTo(subTitle)
        }
        macdBtn.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(maBtn)
            make.centerY.equalTo(subTitle)
        }
        kdjBtn.snp.makeConstraints { (make) in
            make.left.equalTo(macdBtn.snp.right)
            make.centerY.top.equalTo(macdBtn)
            make.width.equalTo(bollBtn)
        }
        rsiBtn.snp.makeConstraints { (make) in
            make.left.equalTo(kdjBtn.snp.right)
            make.centerY.top.equalTo(kdjBtn)
            make.width.equalTo(kdjBtn)
        }
        subEyeBtn.snp.makeConstraints { (make) in
            make.right.width.equalTo(mainEyeBtn)
            make.height.centerY.equalTo(subTitle)
        }
    }
    
    
    func changeMainSettingIndex(name: KRSeriesName?) {
        if let _name = name {
            for btn in subviews where btn is UIButton {
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
            for btn in subviews where btn is UIButton {
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

extension KRKLineSettingIndexView {
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
    
    @objc private func subEyeButtonClick(_ sender : UIButton) {
        sender.isSelected = true
        selectedSubButton?.isSelected = false
        selectedSubButton = nil
        subIndexChanged?(nil)
    }
}
