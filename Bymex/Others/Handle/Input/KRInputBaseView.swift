//
//  KRInputBaseView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//基类
class InputBaseView : UIView{
    
    var showTextBoder = true
    
    var sysheight = UIColor.ThemeView.highlight
    
    var sysnormal = UIColor.ThemeView.bg
    
    //MARK:输入框
    lazy var textfiled : UITextField = {
        let textfiled = UITextField()
        textfiled.extUseAutoLayout()
        textfiled.textColor = UIColor.ThemeLabel.colorLite
        textfiled.font = UIFont.systemFont(ofSize: 14)
       // 1.关闭首字母大写：
        textfiled.autocapitalizationType = UITextAutocapitalizationType.none
       // 2.关闭自动联想功能：
        textfiled.autocorrectionType = UITextAutocorrectionType.no

        return textfiled
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        self.addSubViews([textfiled])
        addConstraints()
        textfiled.rx.controlEvent(UIControl.Event.editingDidBegin).asObservable().subscribe { [weak self](event) in
            guard let mySelf = self else{return}
            mySelf.select(true)
        }.disposed(by: disposeBag)
        textfiled.rx.controlEvent(UIControl.Event.editingDidEnd).asObservable().subscribe {[weak self] (event) in
            guard let mySelf = self else{return}
            mySelf.select(false)
        }.disposed(by: disposeBag)
    }
    
    func select(_ bool : Bool){
        if showTextBoder == true{
            if bool{
                self.extSetBorderWidth(1, color: sysheight)
            }else{
                self.extSetBorderWidth(1, color: sysnormal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        
    }
    
    //设置placeHolder的富文本
    func setPlaceHolderAtt(_ str : String , color : UIColor = UIColor.ThemeLabel.colorMedium , font : CGFloat = 13){
        self.textfiled.setPlaceHolderAtt(str, color: color, font: font)
    }
    
    //设置高亮
    func setHighLight(_ status : Bool){
        let color = status ? UIColor.ThemeView.highlight: UIColor.clear
        textfiled.extSetBorderWidth(1, color: color)
    }
}

