//
//  KRTextFieldStyle.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import RxSwift

class KRTextFieldStyle: NSObject {
    let disposebg = DisposeBag()
    static let `style` = KRTextFieldStyle()
    open class var commonStyle: KRTextFieldStyle {
        return style
    }
    
    func bindHighlight(textField:UITextField,effectView:UIView,isBorder:Bool = false) {
        textField.rx.controlEvent(UIControl.Event.editingDidBegin)
            .subscribe(onNext:{[weak self] _ in
                self?.showHilights(on: true, effectView: effectView, borderHighlight: isBorder)
            }).disposed(by: disposebg)
        textField.rx.controlEvent(UIControl.Event.editingDidEnd)
            .subscribe(onNext:{[weak self] _ in
                self?.showHilights(on: false, effectView: effectView, borderHighlight: isBorder)
            }).disposed(by: disposebg)
    }
    
    func showHilights(on:Bool,effectView:UIView,borderHighlight:Bool) {
        if borderHighlight {
            effectView.layer.borderWidth = on ? 2 : 1
            effectView.layer.borderColor = on ? UIColor.ThemeView.borderSelected.cgColor : UIColor.ThemeView.border.cgColor
        }else {
            effectView.backgroundColor = on ? UIColor.ThemeView.highlight : UIColor.ThemeTextField.seperator
        }
    }
    
    // lineField
    func bindLineFieldHighlight(textField:UITextField, lineView:UIView, titleLabel: UILabel, extraLabel: UIView?) {
        textField.rx.controlEvent(UIControl.Event.editingDidBegin)
            .subscribe(onNext:{[weak self] _ in
                self?.showLineFieldHilights(on: true, textField: textField, lineView: lineView, titleLabel: titleLabel, extraLabel: extraLabel)
            }).disposed(by: disposebg)
        textField.rx.controlEvent(UIControl.Event.editingDidEnd)
            .subscribe(onNext:{[weak self] _ in
                self?.showLineFieldHilights(on: false, textField: textField, lineView: lineView, titleLabel: titleLabel, extraLabel: extraLabel)
            }).disposed(by: disposebg)
    }
    
    func showLineFieldHilights(on:Bool,textField:UITextField, lineView:UIView, titleLabel: UILabel, extraLabel: UIView?) {
        if on == true {
            titleLabel.textColor = UIColor.ThemeLabel.colorHighlight
            lineView.backgroundColor = UIColor.ThemeView.borderSelected
            lineView.snp.updateConstraints { (make) in
                make.height.equalTo(2)
            }
            UIView.animate(withDuration: 0.1) {
                titleLabel.isHidden = false
                titleLabel.font = UIFont.ThemeFont.SecondaryRegular
                titleLabel.snp.updateConstraints { (make) in
                    make.centerY.equalTo(16)
                }
                textField.snp.updateConstraints { (make) in
                    make.centerY.equalTo(41)
                }
                if extraLabel != nil {
                    extraLabel!.snp.updateConstraints { (make) in
                        make.centerY.equalTo(41)
                    }
                }
                titleLabel.superview!.setNeedsLayout()
                titleLabel.superview!.layoutIfNeeded()
            }
        } else {
            titleLabel.textColor = UIColor.ThemeLabel.colorDark
            lineView.backgroundColor = UIColor.ThemeView.border
            lineView.snp.updateConstraints { (make) in
                make.height.equalTo(1)
            }
            textField.setPlaceHolderAtt(textField.placeholder ?? "", color: UIColor.ThemeLabel.colorDark, font: 16)
            if textField.text?.count ?? 0 > 0 {
                UIView.animate(withDuration: 0.1) {
                    titleLabel.isHidden = false
                    titleLabel.font = UIFont.ThemeFont.SecondaryRegular
                    titleLabel.snp.updateConstraints { (make) in
                        make.centerY.equalTo(16)
                    }
                    textField.snp.updateConstraints { (make) in
                        make.centerY.equalTo(41)
                    }
                    if extraLabel != nil {
                        extraLabel!.snp.updateConstraints { (make) in
                            make.centerY.equalTo(41)
                        }
                    }
                    titleLabel.superview!.setNeedsLayout()
                    titleLabel.superview!.layoutIfNeeded()
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    titleLabel.isHidden = true
                    titleLabel.font = UIFont.ThemeFont.HeadRegular
                    titleLabel.snp.updateConstraints { (make) in
                        make.centerY.equalTo(28)
                    }
                    textField.snp.updateConstraints { (make) in
                        make.centerY.equalTo(28)
                    }
                    if extraLabel != nil {
                        extraLabel!.snp.updateConstraints { (make) in
                            make.centerY.equalTo(28)
                        }
                    }
                    titleLabel.superview!.setNeedsLayout()
                    titleLabel.superview!.layoutIfNeeded()
                }
            }
        }
    }
}
