//
//  KRTextFieldPresenter.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import RxSwift

// 设置颜色
public protocol KRTextFieldConfigurable {
    var baseField: UITextField { get }
    var baseHighlight: UIView { get }
    func configPlaceHolder(placeHolder:String)
    func configText(text:String)
    func showError()
}

public extension KRTextFieldConfigurable where Self:UIView {
    
    func configPlaceHolder(placeHolder:String) {
        self.baseField.setPlaceHolderAtt(placeHolder)
    }
    
    func configText(text:String) {
        self.baseField.text = text
        self.baseField.sendActions(for: UIControl.Event.valueChanged)
    }
    
    func currentTxtField()->UITextField {
        return self.baseField
    }
    
    func showError(){
        self.baseHighlight.backgroundColor = UIColor.ThemeState.fail
        if let placeHolder = self.baseField.placeholder {
            self.baseField.setPlaceHolderAtt(placeHolder,color:UIColor.ThemeState.fail)
        }
    }
}

protocol KRTextFieldProtocol {
    func textValueChanged(value:String)
    func inputDidBeginEditing()
    func inputDidEndEditing()
}

class KRTextFieldPresenter: NSObject {
    var presenter: KRTextFieldProtocol!
    let disposebg = DisposeBag()
    init(presenter:KRTextFieldProtocol) {
        self.presenter = presenter;
    }
    
    func configWithTextField(input:UITextField) {
        input.rx.text.orEmpty.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext:{[weak self] text in
                self?.presenter.textValueChanged(value:text)
            }).disposed(by: disposebg)
        
        input.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext:{[weak self] _ in
                self?.presenter.inputDidBeginEditing()
            }).disposed(by: disposebg)
        
        input.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext:{[weak self] _ in
                self?.presenter.inputDidEndEditing()
            }).disposed(by: disposebg)
    }
}
