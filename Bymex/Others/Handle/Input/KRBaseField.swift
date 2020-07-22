//
//  KRBaseField.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum DecimalType {
    case zhang   // 法币精度
    case coin    //币种精度
}

class KRBaseField : UIView {
    var decimalType:DecimalType = .zhang
    var symbol:String = ""
    var decimal:String = ""
    var maxLenth:Int = 16 //默认最长32
    var forceInputLenth:Bool = false
    var rxhasError = BehaviorRelay<Bool>(value: false)
    var hasError:Bool {
        get {
            return rxhasError.value
        }
        set {
            rxhasError.accept(newValue)
        }
    }
    
    typealias TxtFieldDidBeginBlock = () -> ()
    typealias TxtFieldDidEndBlock = () -> ()
    typealias TxtFieldValueChanged = (String) -> ()
    var textfieldDidBeginBlock : TxtFieldDidBeginBlock?
    var textfieldDidEndBlock : TxtFieldDidEndBlock?
    var textfieldValueChangeBlock : TxtFieldValueChanged?
    
    func setPlaceHolder(placeHolder:String , font : CGFloat) {}
    func setText(text:String) {}
    func setTitle(title:String) {}
    
    func onCreate() {
        self.rxhasError.asObservable()
            .subscribe(onNext: { [weak self] error in
                guard let _ = self else { return }
                if error {

                }
            }).disposed(by: self.disposeBag)
    }
    
    func hideError(_ textField:UITextField) {
        if let placeHolder = textField.placeholder {
            textField.setPlaceHolderAtt(placeHolder)
        }
    }
    
    func addCreate() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.onCreate()
        self.addCreate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KRBaseField : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .numberPad ||
            textField.keyboardType == .decimalPad {
            let nsString = textField.text as NSString?
            let newString = nsString? .replacingCharacters(in: range, with: string)
            
            if let newStr = newString {
                //超长处理，其他往下走逻辑
                if newStr.count > maxLenth {
                    return false
                }
                if newStr.contains(".") == false  {
                    if newStr.kr_length >= 9 {
                        return false
                    }
                } else {
                    let arr = newStr.components(separatedBy: ".")
                    if arr.count == 2 {
                        let num = arr[0]
                        if num.kr_length >= 9 {
                            return false
                        }
                    }
                }
            }
            
            if textField.keyboardType == .numberPad{
                if KRBusinessTools.number(newString ?? ""){
                    return true
                }else{
                    EXAlert.showFail(msg: "userinfo_tip_inputPhone".localized())
                    return false
                }
            }
            
            if string.isEmpty {
                return true
            }else {
                //如果都没指定,都不管
                if symbol.isEmpty && decimal.isEmpty {
                    return true
                }else {
                    //无论法币精度还是币种精度,点开头都return false
                    let regex = "^[0][0-9]+$"
                    let regexDot = "^[.]+$"
                    let predicate0 = NSPredicate(format: "SELF MATCHES %@", regex)
                    let predicateDot = NSPredicate(format: "SELF MATCHES %@", regexDot)
                    let isZeroPrefix = predicate0.evaluate(with: newString)
                    let isDotPrefix = predicateDot.evaluate(with: newString)
                    if  isDotPrefix || isZeroPrefix {
                        return false
                    }else {
                        var decimalPrecision = 8
                        if decimalType == .coin { // 币
                            if decimal.count > 0 {
                                let decimal = Int(self.decimal)
                                if let symbolDecimal = decimal,symbolDecimal > 0 {
                                    decimalPrecision = symbolDecimal
                                }
                            } else {
//                                if let precision = PublicInfoManager.sharedInstance.getCoinEntity(self.symbol)?.showPrecision {
//                                    let decimal = Int(precision)
//                                    if let symbolDecimal = decimal,symbolDecimal > 0 {
//                                        decimalPrecision = symbolDecimal
//                                    }
//                                }
                                decimalPrecision = 0
                            }
                        } else { // 张
//                            if decimal.count > 0 {
//                                decimalPrecision = Int(decimal) ?? 8
//                            }else {
//                                decimalPrecision = 2 // 法币精度
//                            }
                            if decimal.count > 0 , decimal != "0" {
                                let decimal = Int(self.decimal)
                                if let symbolDecimal = decimal,symbolDecimal > 0 {
                                    decimalPrecision = symbolDecimal
                                }
                            } else {
                                if let newStr = newString {
                                    if newStr.contains(".") {
                                        return false
                                    }
                                }
                                decimalPrecision = 0
                            }
                        }
                        let regex = "^([0-9]*)?(\\.)?([0-9]{0,\(decimalPrecision)})?$"
                        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                        return predicate.evaluate(with: newString)
                    }
                }
            }
        } else {
            if forceInputLenth {
                let nsString = textField.text as NSString?
                let newString = nsString? .replacingCharacters(in: range, with: string)
                
                if let newStr = newString {
                    //超长处理，其他往下走逻辑
                    if newStr.count > maxLenth {
                        return false
                    }
                }
                
                return true
            }
            return true
        }
    }
}
