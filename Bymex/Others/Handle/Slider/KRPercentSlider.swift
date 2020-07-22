//
//  KRPercentSlider.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/21.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRPercentSlider: UIControl {
    /// 最小值
    var minLevel = 1
    /// 最大值
    var maxLevel = 100
    
    var valueChangedCallback: ((Int) -> ())?
    
    var startEdit: (() -> ())?
    
    /// 滑块大小
    let thumbWH = 10
    
    /// 节点数量
    let numberOfPart = 5
    
    var partViewArray: [UIButton] = []
    
    lazy var slider: SLCustomSlider = {
        let slider = SLCustomSlider()
        slider.minimumValue = Float(self.minLevel)
        slider.maximumValue = Float(self.maxLevel)
        slider.value = 1
        slider.backgroundColor = UIColor.clear
        slider.isContinuous = true
        slider.setThumbImage(UIImage.themeImageNamed(imageName: "contract_slider"), for: .normal)
        slider.setThumbImage(UIImage.themeImageNamed(imageName: "contract_slider"), for: .disabled)
        slider.setMinimumTrackImage(UIImage.yy_image(with: UIColor.clear), for: .normal)
        slider.setMaximumTrackImage(UIImage.yy_image(with: UIColor.clear), for: .normal)
        slider.setMinimumTrackImage(UIImage.yy_image(with: UIColor.clear), for: .disabled)
        slider.setMaximumTrackImage(UIImage.yy_image(with: UIColor.clear), for: .disabled)
        slider.isUserInteractionEnabled = false
        slider.alpha = 1.0
        return slider
    }()
    
    /// 滑动条
    private lazy var sliderMaskView: UIStackView = {
        let view = UIStackView()
        let normalView = UIView()
        normalView.backgroundColor = UIColor.ThemeBtn.disable
        let selectView = UIView()
        selectView.backgroundColor = UIColor.ThemeLabel.colorHighlight
        view.addSubViews([normalView, selectView])
        
        normalView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-4)
            make.height.equalTo(5)
            make.centerY.equalToSuperview()
        }
        selectView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(4)
            make.height.centerY.equalTo(normalView)
            make.width.equalTo(0)
        }
        
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .fill
        return view
    }()
    
    /// 滑块
//    private lazy var thumbImageView: UIImageView = {
//        let imageView = UIImageView(image: UIImage.themeImageNamed(imageName: "contract_slider_glide"))
//        imageView.contentMode = .scaleAspectFit
//        imageView.frame = CGRect(x: 0, y: 0, width: thumbWH, height: thumbWH)
//        return imageView
//    }()
    
    init(frame: CGRect, minLevel: Int, maxLevel: Int) {
        super.init(frame: frame)
        
        self.maxLevel = maxLevel
        self.minLevel = minLevel
        
        self.addSubViews([self.sliderMaskView, self.slider])
        let margin = Int(round((Float(maxLevel) - Float(minLevel)) / Float((numberOfPart-1))))
        
        for index in 0..<numberOfPart {
            let button = UIButton(buttonType: .custom, image: UIImage.themeImageNamed(imageName: "swap_selection"))
            button.setImage(UIImage.themeImageNamed(imageName: "swap_after_selection"), for: .selected)
            button.setBackgroundImage(UIImage.themeImageNamed(imageName: "swap_after_selection"), for: .selected)
            button.setBackgroundImage(UIImage.themeImageNamed(imageName: "swap_selection"), for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            self.sliderMaskView.addArrangedSubview(button)
            
            self.partViewArray.append(button)
            
            var text: String
            if index == 0 {
                text = String(format: "%d%%", self.minLevel)
            } else if index == numberOfPart-1 {
                text = String(format: "%d%%", self.maxLevel)
            } else {
                text = String(format: "%d%%", margin*index+Int(minLevel))
            }
            let label = UILabel(text: text, font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .center)
            self.sliderMaskView.addSubview(label)
            label.snp_remakeConstraints { (make) in
                make.centerX.equalTo(button)
                make.top.equalTo(button.snp_bottom).offset(10)
            }
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture(recognizer:)))
        self.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(recognizer:)))
        self.addGestureRecognizer(pan)
        
        self.initLayout()
    }
    
    init(frame: CGRect, maxLevel: Int) {
        super.init(frame: frame)
        
        self.maxLevel = maxLevel
        
        self.addSubViews([self.sliderMaskView, self.slider])
        let margin = Int(round((Float(maxLevel) - Float(minLevel)) / Float((numberOfPart-1))))
        
        for index in 0..<numberOfPart {
            let button = UIButton()
            button.setBackgroundImage(UIImage.themeImageNamed(imageName: "swap_after_selection"), for: .selected)
            button.setBackgroundImage(UIImage.themeImageNamed(imageName: "swap_selection"), for: .normal)
            button.contentMode = .scaleAspectFit
            button.frame = CGRect(x: 0, y: 0, width: 10, height: 13)
            self.sliderMaskView.addArrangedSubview(button)
            
            self.partViewArray.append(button)
            
            var text: String
            if index == 0 {
                text = String(format: "%d%%", self.minLevel)
            } else if index == numberOfPart-1 {
                text = String(format: "%d%%", self.maxLevel)
            } else {
                text = String(format: "%d%%", margin*index+Int(minLevel))
            }
            let label = UILabel(text: text, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .center)
            self.sliderMaskView.addSubview(label)
            label.snp_remakeConstraints { (make) in
                make.centerX.equalTo(button)
                make.top.equalTo(button.snp_bottom).offset(10)
            }
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture(recognizer:)))
        self.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(recognizer:)))
        self.addGestureRecognizer(pan)
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initLayout() {
        self.slider.snp_makeConstraints { (make) in
            make.left.equalTo(Double(thumbWH/2))
            make.right.equalTo(Double(-thumbWH/2))
            make.height.equalTo(13)
        }
        self.sliderMaskView.snp_makeConstraints { (make) in
            make.top.height.equalTo(self.slider)
            make.left.equalTo(Double(thumbWH/2)-5)
            make.right.equalTo(Double(-thumbWH/2)+5)
        }
    }
    
    @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
        self.startEdit?()
        let point = recognizer.location(in: self.slider)
        let percent = Float(point.x / self.slider.width)
        let value = round((self.slider.maximumValue - self.slider.minimumValue) * percent + self.slider.minimumValue)
        self.updateSliderValue(value: value)
    }
    
    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        self.startEdit?()
        let point = recognizer.location(in: self.slider)
        let percent = Float(point.x / self.slider.width)
        let value = round((self.slider.maximumValue - self.slider.minimumValue) * percent + self.slider.minimumValue)
        self.updateSliderValue(value: value)
    }
    
    func updateSliderValue(value: Float) {
        var value = value
        if (value < self.slider.minimumValue) {
            value = self.slider.minimumValue
        }
        if (value > self.slider.maximumValue) {
            value = self.slider.maximumValue
        }
        self.slider.setValue(value, animated: true)
        let normalView = self.sliderMaskView.subviews.first!
        let selectView = self.sliderMaskView.subviews[1]
        var scale = (self.slider.value - self.slider.minimumValue) / (self.slider.maximumValue - self.slider.minimumValue)
        if scale > 1 {
            scale = 1.0
        }
        selectView.snp_remakeConstraints { (make) in
            make.left.equalToSuperview().offset(4)
            make.height.centerY.equalTo(normalView)
            make.width.equalTo(normalView).multipliedBy(scale)
        }
        
        let maxValue = self.slider.maximumValue - self.slider.minimumValue
        let maxPart = Float(self.numberOfPart - 1)
        var count = 0
        if value >= maxValue {
            count = self.partViewArray.count
        } else if value >= (maxValue * ((maxPart-1)/maxPart)) {
            count = 4
        } else if value >= (maxValue * ((maxPart-2)/maxPart)) {
            count = 3
        } else if value >= (maxValue * ((maxPart-3)/maxPart)) {
            count = 2
        } else {
            count = 1
        }
        for index in 0..<count {
            self.partViewArray[index].isSelected = true
        }
        for index in count..<self.partViewArray.count {
            self.partViewArray[index].isSelected = false
        }
        
        if (value < Float(self.minLevel)) {
            value = Float(self.minLevel)
        }
        
        self.valueChangedCallback?(Int(ceil(value)))
    }
}
