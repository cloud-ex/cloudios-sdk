//
//  KRTextFieldEx.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

extension UITextField{
    //设置placeHolder的富文本
    func setPlaceHolderAtt(_ str : String , color : UIColor = UIColor.ThemeLabel.colorDark , font : CGFloat = 13){
        let placeHolderAtt = NSMutableAttributedString().add(string: str, attrDic: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: font) , NSAttributedString.Key.foregroundColor : color])
        self.attributedPlaceholder = placeHolderAtt
    }
    
    // MARK: -添加自定义清除按钮
    func setModifyClearButton() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage.themeImageNamed(imageName: "delete"), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        clearButton.contentMode = .scaleAspectFit
        clearButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 0)
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        let container = UIView(frame: clearButton.frame)
        container.backgroundColor = .clear
        container.addSubview(clearButton)
        
        self.rightView = container
        self.rightViewMode = .whileEditing
    }
    
    /// 点击清除按钮，清空内容
    @objc func clear(sender: AnyObject) {
        self.text = ""
        self.sendActions(for: .valueChanged)
    }
}

