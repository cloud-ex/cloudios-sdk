//
//  KRKeyBoardButtonView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

enum KeyBoardButtonStyle {
    case keyBoardNumberButtonStyle  // 数字键
    case keyBoardLetterButtonStyle  // 字母键
    case keyBoardPointButtonStyle   // 小数点
    case keyBoardDeleteButtonStyle  // 删除键
    case keyBoardConfirmButtonStyle // 完成按钮
}

protocol KRKeyBoardButtonViewDelegate: NSObjectProtocol {
    func didSelectButtonClick(view: KRKeyBoardButtonView, buttonStyle: KeyBoardButtonStyle, sender: UIButton)
}

class KRKeyBoardButtonView: UIView {
    var style: KeyBoardButtonStyle! {
        didSet {
            if style == .keyBoardNumberButtonStyle {
                setFont(UIFont.ThemeFont.H2Medium)
                setTitleColor(colorName: "#FFFFFF", state: .normal)
                setBackgroundImage(image: UIImage.exImage(color: UIColor.ThemeBtn.normal1)!, state: .normal)
                setBackgroundImage(image: UIImage.exImage(color: UIColor.ThemeBtn.highlight1)!, state: .highlighted)
            } else if style == .keyBoardDeleteButtonStyle {
                setBackgroundImage(image: UIImage.exImage(color: UIColor.ThemeBtn.normal1)!, state: .normal)
                setBackgroundImage(image: UIImage.exImage(color: UIColor.ThemeBtn.highlight1)!, state: .highlighted)
            } else if style == .keyBoardConfirmButtonStyle {
                setFont(UIFont.ThemeFont.H2Regular)
                setTitle("确定", state: .normal)
                setTitleColor(colorName: "#000000", state: .normal)
                setBackgroundImage(image: UIImage.exImage(color: UIColor.ThemeBtn.normal)!, state: .normal)
                setBackgroundImage(image: UIImage.exImage(color: UIColor.ThemeBtn.highlight)!, state: .highlighted)
            }
        }
    }
    weak var delegate: KRKeyBoardButtonViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        addSubview(self.button)
    }
    
    func setFont(_ font :UIFont) {
        button.titleLabel?.font = font
    }
    
    func setTitle(_ title: String, state: UIControl.State) {
        button.setTitle(title, for: state)
    }
    
    func setTitleColor(colorName: String, state: UIControl.State) {
        button.setTitleColor(UIColor.extColorWithHex(colorName), for: state)
    }
    
    func setImage(imageNamed: String, state: UIControl.State) {
        guard !imageNamed.isEmpty else {
            button.setImage(nil, for: state)
            return
        }
        button.setImage(UIImage.init(named: imageNamed), for: state)
    }
    
    open func setBackgroundImage(image: UIImage, state: UIControl.State) {
        button.setBackgroundImage(image, for: state)
    }
    
    open func setBackgroundColor(color: UIColor) {
        button.backgroundColor = color
    }
    
    open func setTag(_ tag: Int) {
        button.tag = tag
    }
    
    lazy var button : UIButton = {
        let object = UIButton.init(type: .custom)
        object.frame = self.bounds
        // 设置圆角
        object.layer.cornerRadius = 5
        object.layer.masksToBounds = true
        object.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        object.addTarget(self, action: #selector(selectButton(sender:)), for: .touchUpInside)
        return object
    }()

    @objc func selectButton(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        delegate?.didSelectButtonClick(view: self, buttonStyle: style, sender: sender)
        sender.isUserInteractionEnabled = true
    }
}
