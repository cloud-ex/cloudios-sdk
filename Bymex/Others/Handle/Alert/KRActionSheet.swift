//
//  KRActionSheet.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/28.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRActionSheet: KRBaseV {
    typealias ActionCallback = (Int,String) -> ()
    typealias CancelCallback = () -> ()
    
    var actionIdxCallback : ActionCallback?//选择类型,index回调
    var actionCancelCallback : CancelCallback?//取消回调
    
    lazy var cancelBtn : UIButton = {
        let object = UIButton.init(buttonType: .custom, title: "取消".localized(), titleFont: UIFont.systemFont(ofSize: 17), titleColor: UIColor.ThemeLabel.colorMedium)
        object.extSetAddTarget(self, #selector(clickCancel))
        return object
    }()
    
    lazy var middleLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.bg
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeTab.bg
        addSubViews([cancelBtn,middleLine])
        cancelBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(isiPhoneX ? -34 : 0 )
            make.height.equalTo(52)
        }
        middleLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(8)
            make.bottom.equalTo(cancelBtn.snp.top)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configButtonTitles(buttons:Array<String>,selectedIdx:Int = -1) {
        cancelBtn.setTitle("common_text_btnCancel".localized(), for: .normal)
        
        for (idx,btnTitle) in buttons.enumerated() {
            let btn = UIButton()
            btn.extSetTitle(btnTitle, 16, UIColor.ThemeLabel.colorMedium, UIColor.ThemeLabel.colorHighlight)
            btn.addTarget(self, action: #selector(onClickAction(sender:)), for: .touchUpInside)
            btn.tag = idx
            if selectedIdx >= 0, selectedIdx < buttons.count, selectedIdx == idx {
                btn.isSelected = true
            }
            addSubview(btn)
            let itemHeight = CGFloat(idx * 52)
            btn.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.equalTo(SCREEN_WIDTH)
                make.height.equalTo(52)
                make.top.equalToSuperview().offset(itemHeight)
            }
            if idx < btnTitle.count - 2 {
                let line = UIView()
                line.backgroundColor = UIColor.ThemeView.seperator
                btn.addSubview(line)
                line.snp.makeConstraints { (make) in
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(1)
                }
            }
        }
        
        let contentHeight = CGFloat(buttons.count * 52)
        let totalHeight = contentHeight + 60 + (isiPhoneX ? 34 : 0 )

        if totalHeight >= CONTENTVIEW_HEIGHT {
            self.snp.updateConstraints { (make) in
                make.height.equalTo(CONTENTVIEW_HEIGHT)
            }
        }else{
            self.snp.updateConstraints { (make) in
                make.height.equalTo(totalHeight)
            }
        }
    }
}

extension KRActionSheet {
    
    @objc func onClickAction(sender: UIButton) {
        EXAlert.dismiss()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.actionIdxCallback?(sender.tag,sender.titleLabel?.text ?? "")
        }
    }
    
    @objc func clickCancel() {
        EXAlert.dismiss()
        self.actionCancelCallback?()
    }
}
