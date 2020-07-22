//
//  KRKeyBoardView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

//间隔
private let BTNSPACE:CGFloat = 6.0
//按键的高宽比
private let KEYRATIO:CGFloat = 23.0  / 43.0
//按键的宽
private let BTN_WIDTH:CGFloat = (SCREEN_WIDTH - BTNSPACE) / 4.0 - BTNSPACE
//按键的高
private let BTN_HEIGHT:CGFloat = BTN_WIDTH * KEYRATIO
//item的高
private let ITEM_HEIGHT:CGFloat = BTN_HEIGHT + BTNSPACE
//底部安全区高度
private let SAFE_BOTTOM:CGFloat = (UIScreen.main.bounds.height == 812.0) ? 34.0 : 0.0
//总高
private let TOTAL_HEIGHT:CGFloat = ITEM_HEIGHT * 4 + BTNSPACE + SAFE_BOTTOM

class KRKeyBoardView: UIView {
    // 输入源
    weak public var inputSource:UIView?
    var numberSource = KRKeyBoardUtil.getNumberSourceBy()
    
    init() {
        super.init(frame: .zero)
        self.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: TOTAL_HEIGHT)
        configKeyboardUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var deleteButton : KRKeyBoardButtonView = {
        let object = KRKeyBoardButtonView.init(frame: CGRect.init(x: 3.0*(BTN_WIDTH + BTNSPACE) + BTNSPACE, y: BTNSPACE, width: BTN_WIDTH, height: BTN_HEIGHT))
        object.style = .keyBoardDeleteButtonStyle
        object.delegate = self
        return object
    }()
    
    lazy var comfigButton : KRKeyBoardButtonView = {
        let object = KRKeyBoardButtonView.init(frame: CGRect.init(x: 3.0*(BTN_WIDTH + BTNSPACE) + BTNSPACE, y: BTNSPACE + ITEM_HEIGHT, width: BTN_WIDTH, height: ITEM_HEIGHT * 3.0 - BTNSPACE))
        object.style = .keyBoardConfirmButtonStyle
        object.delegate = self
        return object
    }()
}

// mark: - 键盘单元格按钮点击方法
extension KRKeyBoardView: KRKeyBoardButtonViewDelegate {
    func didSelectButtonClick(view: KRKeyBoardButtonView, buttonStyle: KeyBoardButtonStyle, sender: UIButton) {
        switch buttonStyle {
        case .keyBoardNumberButtonStyle: do {
            let model = numberSource[sender.tag]
            let textFieldText = model.keyBoadString ?? ""
            inputString(textFieldText)
            break
            }
        case .keyBoardLetterButtonStyle: do {
            break
            }
            
        case .keyBoardPointButtonStyle: do {
            break
            }
            
        case .keyBoardDeleteButtonStyle: do {
            handleClearClick()
            break
            }
            
        case .keyBoardConfirmButtonStyle: do {
            guard let inputSource = self.inputSource else {
                return
            }
            inputSource.endEditing(true)
            break
            }
        }
    }
}

// mark: - layout
extension KRKeyBoardView {
    func configKeyboardUI() {
        backgroundColor = UIColor.extColorWithHex("#202020")
        for idx in 0..<numberSource.count {
            let btnModel = self.numberSource[idx]
            let numberBtn : KRKeyBoardButtonView
            if idx == 9 { // "0"
                numberBtn = KRKeyBoardButtonView.init(frame: CGRect.init(x: BTNSPACE, y: BTNSPACE + ITEM_HEIGHT * 3.0, width: BTN_WIDTH * 2.0 + BTNSPACE, height: BTN_HEIGHT))
                numberBtn.style = .keyBoardNumberButtonStyle
                numberBtn.setTitle(btnModel.keyBoadString ?? "0", state: .normal)
            } else if idx == 10 { // "."
                numberBtn = KRKeyBoardButtonView.init(frame: CGRect.init(x: BTN_WIDTH * 2.0 + BTNSPACE * 3, y: BTNSPACE + ITEM_HEIGHT * 3.0, width: BTN_WIDTH, height: BTN_HEIGHT))
                numberBtn.style = .keyBoardNumberButtonStyle
                numberBtn.setTitle(btnModel.keyBoadString ?? ".", state: .normal)
            } else {
                let row = Float(idx).truncatingRemainder(dividingBy: 3.0)
                let ver = Int(Float(idx) / 3.0)
                numberBtn = KRKeyBoardButtonView.init(frame: CGRect.init(x: BTNSPACE + CGFloat(row)*(BTN_WIDTH + BTNSPACE), y: BTNSPACE + CGFloat(ver) * ITEM_HEIGHT, width: BTN_WIDTH, height: BTN_HEIGHT))
                numberBtn.style = .keyBoardNumberButtonStyle
                numberBtn.setTitle(btnModel.keyBoadString ?? "-", state: .normal)
            }
            numberBtn.setTag(idx)
            numberBtn.delegate = self
            self.addSubview(numberBtn)
        }
        self.addSubview(deleteButton)
        self.addSubview(comfigButton)
    }
}

// mark: 文字处理方法
extension KRKeyBoardView {
    /// - Parameter string: 输入的文字
    private func inputString(_ string:String) {
        guard let inputSource = self.inputSource else {
            return
        }
        // UITextField
        if(inputSource.isKind(of: UITextField.self)){
            // 获取输入空控件
            let tmp = inputSource as! UITextField
            //判断是否实现了代理，是否实现了shouldChangeCharactersIn代理
            if(tmp.delegate != nil && (tmp.delegate?.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))) ?? false)){
                //当前输入框了的选择范围，默认时输入末尾
                var range = NSRange.init(location: tmp.text?.count ?? 0, length: 0)
                //有可能不是输入末尾，且选择了几个字符
                if let rag = tmp.selectedTextRange {
                    //光标偏移量，即选中开始位置
                    let currentOffset = tmp.offset(from: tmp.beginningOfDocument, to: rag.start)
                    //选中结束位置
                    let endOffset =  tmp.offset(from: tmp.beginningOfDocument, to: rag.end)
                    //选中字符长度
                    let length = endOffset - currentOffset
                    //选中范围
                    range = NSRange.init(location: currentOffset, length:length)
                }
                //代理是否允许输入字符
                let ret = tmp.delegate?.textField?(tmp, shouldChangeCharactersIn: range, replacementString: string) ?? false
                //允许输入字符时，输入字符
                if(ret){
                    tmp.insertText(string)
                }
            } else {
                //直接输入字符
                tmp.insertText(string)
            }
        }
    }
    
    /// - Parameter button: 删除按钮
    private func handleClearClick() {
        guard let inputSource = self.inputSource else {
            return
        }
        if (inputSource.isKind(of: UITextField.self)) {
            let tmp = inputSource as! UITextField
            
            var currentOffset = (tmp.text?.count ?? 0)
            var length = 1
            //有可能不是输入末尾，且选择了几个字符
            if let rag = tmp.selectedTextRange {
                //光标偏移量，即选中开始位置
                currentOffset = tmp.offset(from: tmp.beginningOfDocument, to: rag.start)
                //选中结束位置
                let endOffset =  tmp.offset(from: tmp.beginningOfDocument, to: rag.end)
                //选中字符长度
                length = endOffset - currentOffset
            }
            //判断是否实现了代理，是否实现了shouldChangeCharactersIn代理
            if(!(currentOffset == 0 && length == 0 ) && (tmp.text?.count ?? 0) > 0 && tmp.delegate != nil && (tmp.delegate?.responds(to: #selector(UITextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:))) ?? false)){
                
                if(length == 0 && currentOffset > 0){
                    currentOffset -= 1
                }
                //至少删除一个字符
                if(length == 0){
                    length = 1
                }
                //删除位置
                let range = NSRange.init(location:currentOffset, length: length)
                //代理是否允许输入字符
                let ret = tmp.delegate?.textField?(tmp, shouldChangeCharactersIn: range, replacementString: "") ?? false
                //允许输入字符时，直接删除
                if(ret){
                    tmp.deleteBackward()
                }
            } else {
                //直接删除
                tmp.deleteBackward()
            }
        }
    }
}
