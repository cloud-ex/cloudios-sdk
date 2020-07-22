//
//  KRLevelSlider.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/22.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRLevelSlider: UIControl {
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
                text = String(format: "%dx", self.minLevel)
            } else if index == numberOfPart-1 {
                text = String(format: "%dx", self.maxLevel)
            } else {
                text = String(format: "%dx", margin*index+Int(minLevel))
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
                text = String(format: "%dx", self.minLevel)
            } else if index == numberOfPart-1 {
                text = String(format: "%dx", self.maxLevel)
            } else {
                text = String(format: "%dx", margin*index+Int(minLevel))
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

class SLCustomSlider: UISlider {
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        var rect = bounds
        rect.origin.x = rect.origin.x-10
        rect.size.width=rect.size.width+20;
        return super.thumbRect(forBounds: bounds, trackRect: rect, value: value).insetBy(dx: 10, dy: 10)
    }
}


class SLLeverageField: UIView {
    lazy var input : UITextField = {
        let textField = UITextField()
        textField.keyboardType = UIKeyboardType.numberPad
        textField.textColor = UIColor.ThemeLabel.colorLite
        textField.font = UIFont.ThemeFont.H1Bold
        textField.textAlignment = .center
        return textField
    }()
    
    lazy var line : UIView = {
        let lineView:UIView = UIView()
        return lineView
    }()
    
    lazy var label : UILabel = {
        let label = UILabel(text: "X", font: UIFont.ThemeFont.H1Bold, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        self.addSubViews([label,line,input])
        self.label.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.width.equalTo(20)
            make.bottom.equalToSuperview().offset(-2)
        }
        self.line.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.right.equalTo(self.label.snp.left)
            make.height.equalTo(2)
        }
        self.input.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-2)
            make.right.equalTo(self.label.snp.left)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawLineOfDashByCAShapeLayer(lineView: self.line, lineLength: 3, lineSpacing: 2, lineColor: UIColor.ThemeView.seperator, isHorizonal: true)
    }
    
    /**
     *  通过 CAShapeLayer 方式绘制虚线
     *
     *  param lineView:       需要绘制成虚线的view
     *  param lineLength:     虚线的宽度
     *  param lineSpacing:    虚线的间距
     *  param lineColor:      虚线的颜色
     *  param lineDirection   虚线的方向  true 为水平方向， false 为垂直方向
     **/
    func drawLineOfDashByCAShapeLayer(lineView:UIView!,
                                      lineLength:Int,
                                      lineSpacing:Int,
                                      lineColor:UIColor,
                                      isHorizonal:Bool) {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = lineView.bounds
        if (isHorizonal){
            shapeLayer.position = CGPoint(x: lineView.frame.width/2, y: lineView.frame.height)
        }else{
            shapeLayer.position = CGPoint(x: lineView.frame.size.width/2, y: lineView.frame.size.height/2)
        }
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        //设置线宽
        if (isHorizonal){
            shapeLayer.lineWidth = lineView.frame.size.height
        }else{
            shapeLayer.lineWidth = lineView.frame.size.width
        }
        //  设置线宽，线间距
        shapeLayer.lineDashPattern = [NSNumber(integerLiteral: lineLength),NSNumber(integerLiteral: lineSpacing)]
        
        //  设置路径
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: lineView.height/2), transform: .identity)
        
        if isHorizonal {
            path.addLine(to: CGPoint(x: lineView.frame.width, y: lineView.height/2), transform: .identity)
        } else {
            path.addLine(to: CGPoint(x: 0, y: lineView.frame.height), transform: .identity)
        }
        shapeLayer.path = path
        //  把绘制好的虚线添加上来
        lineView.layer.addSublayer(shapeLayer)
    }
}
