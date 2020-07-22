//
//  KRDetailLabelView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/28.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

/// 两个左右分布的 label
class KRHorDetailLabel: UIView {
    typealias ClickMiddleBtnBlock = () -> ()
       var clickMiddleBtnBlock : ClickMiddleBtnBlock?
    
    
    typealias ClickRightLabelBlock = () -> ()
          var clickRightLabelBlock : ClickRightLabelBlock?
    
    var isShowTipButton: Bool = false {
        didSet {
            self.tipButton.isHidden = !isShowTipButton
        }
    }
    
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorDark
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    lazy var tipButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.themeImageNamed(imageName: "contract_prompt"), for: .normal)
        button.isHidden = true
        self.addSubview(button)
        button.extSetAddTarget(self, #selector(clickTipButton))
        return button
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        label.textAlignment = .right
        return label
    }()
    
    lazy var bottomLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeLabel.colorMedium
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([leftLabel, rightLabel])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        self.leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.lessThanOrEqualTo(self.snp.centerX)
            make.height.equalTo(14)
            make.centerY.equalToSuperview()
        }
        self.rightLabel.snp.makeConstraints { (make) in
            make.height.equalTo(14)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
        self.tipButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftLabel.snp.right).offset(5)
            make.height.width.equalTo(15)
            make.centerY.equalTo(self.leftLabel.snp.centerY)
        }
    }
    
    func setLeftText(_ text: String) {
        self.leftLabel.text = text
    }
    
    func setRightText(_ text: String) {
        self.rightLabel.text = text
    }
    
    @objc func clickTipButton(_ btn : UIButton) {
        clickMiddleBtnBlock?()
    }
    
    func addTapLabel() {
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.right.equalTo(rightLabel)
            make.top.equalTo(rightLabel.snp_bottom)
            make.height.equalTo(1)
            make.left.equalTo(rightLabel)
        }
        let tapGesture = UITapGestureRecognizer()
        rightLabel.isUserInteractionEnabled = true
        rightLabel.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: {[weak self] recognizer in
            self?.clickRightLabelBlock?()
        }).disposed(by: disposeBag)
    }
}

class KRVerDetailLabel: UIView {
    typealias ClickMiddleBtnBlock = () -> ()
       var clickMiddleBtnBlock : ClickMiddleBtnBlock?
    
    typealias ClickBottomLabelBlock = () -> ()
    var clickBottomLabelBlock : ClickBottomLabelBlock?
    
    var isShowTipButton: Bool = false {
        didSet {
            self.tipButton.isHidden = !isShowTipButton
            if isShowTipButton {
                self.topLabel.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview()
                    make.height.equalTo(12)
                    make.top.equalToSuperview()
                }
                self.tipButton.snp.remakeConstraints { (make) in
                    make.left.equalTo(self.topLabel.snp.right).offset(5)
                    make.height.width.equalTo(15)
                    make.centerY.equalTo(self.topLabel.snp.centerY)
                }
            }
        }
    }
    
    var contentAlignment: NSTextAlignment = .left {
        didSet {
            self.topLabel.textAlignment = contentAlignment
            self.bottomLabel.textAlignment = contentAlignment
            if contentAlignment == .left {
                bottomLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(topLabel.snp_bottom)
                    make.left.equalToSuperview()
                    make.width.lessThanOrEqualToSuperview()
                    make.height.equalTo(18)
                }
            } else {
                bottomLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(topLabel.snp_bottom)
                    make.right.equalToSuperview()
                    make.width.lessThanOrEqualToSuperview()
                    make.height.equalTo(18)
                }
            }
        }
    }
    
    func showEqualLabel() {
        addSubview(equalLabel)
        equalLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bottomLabel.snp.right)
            make.height.equalTo(18)
            make.centerY.equalTo(bottomLabel)
            make.width.lessThanOrEqualTo(80)
        }
    }
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorDark
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    lazy var tipButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.themeImageNamed(imageName: "contract_prompt"), for: .normal)
        button.isHidden = true
        self.addSubview(button)
        button.extSetAddTarget(self, #selector(clickTipButton))
        return button
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        return label
    }()
    
    lazy var bottomLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeLabel.colorMedium
        return object
    }()
    
    lazy var equalLabel : UILabel = {
        let object = UILabel.init(text: "≈$0", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([topLabel, bottomLabel])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        topLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(16)
            make.top.equalToSuperview()
        }
        bottomLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp_bottom)
            make.left.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.height.equalTo(18)
        }
    }
    
    func setTopText(_ text: String) {
        self.topLabel.text = text
    }
    
    func setBottomText(_ text: String) {
        self.bottomLabel.text = text
    }
    
    func addTapLabel() {
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(bottomLabel)
            make.top.equalTo(bottomLabel.snp_bottom)
            make.height.equalTo(1)
        }
        let tapGesture = UITapGestureRecognizer()
        bottomLabel.isUserInteractionEnabled = true
        bottomLabel.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: {[weak self] recognizer in
            self?.clickBottomLabelBlock?()
        }).disposed(by: disposeBag)
    }
    
    func setTapColor(_ color :UIColor) {
        bottomLabel.textColor = color
        bottomLine.backgroundColor = color
    }
    
    @objc func clickTipButton(_ btn : UIButton) {
        clickMiddleBtnBlock?()
    }
}


class KRHorLabel: UIView {
    typealias ClickMiddleBtnBlock = () -> ()
       var clickMiddleBtnBlock : ClickMiddleBtnBlock?
    
    
    typealias ClickRightLabelBlock = () -> ()
          var clickRightLabelBlock : ClickRightLabelBlock?
    
    var isShowTipButton: Bool = false {
        didSet {
            self.tipButton.isHidden = !isShowTipButton
        }
    }
    
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorDark
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    lazy var tipButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.themeImageNamed(imageName: "contract_prompt"), for: .normal)
        button.isHidden = true
        self.addSubview(button)
        button.extSetAddTarget(self, #selector(clickTipButton))
        return button
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        return label
    }()
    
    lazy var bottomLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeLabel.colorMedium
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([leftLabel, rightLabel])
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(14)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(100)
        }
//        tipButton.snp.makeConstraints { (make) in
//            make.left.equalTo(leftLabel.snp.right).offset(5)
//            make.height.width.equalTo(15)
//            make.centerY.equalTo(leftLabel.snp.centerY)
//        }
        rightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right).offset(3)
            make.height.equalTo(14)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(110)
        }
    }
    
    func setLeftText(_ text: String) {
        self.leftLabel.text = text
    }
    
    func setRightText(_ text: String) {
        self.rightLabel.text = text
    }
    
    @objc func clickTipButton(_ btn : UIButton) {
        clickMiddleBtnBlock?()
    }
    
    func addTapLabel() {
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.right.equalTo(rightLabel)
            make.top.equalTo(rightLabel.snp_bottom)
            make.height.equalTo(1)
            make.left.equalTo(rightLabel)
        }
        let tapGesture = UITapGestureRecognizer()
        rightLabel.isUserInteractionEnabled = true
        rightLabel.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: {[weak self] recognizer in
            self?.clickRightLabelBlock?()
        }).disposed(by: disposeBag)
    }
}
