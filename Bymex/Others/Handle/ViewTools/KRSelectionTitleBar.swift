//
//  KRSelectionTitleBar.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/7.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class KRSelectionBarStyle :NSObject {
    var titleFont :UIFont = UIFont.ThemeFont.HeadBold
    var titleColor:UIColor = UIColor.ThemeLabel.colorMedium
    var titleHighLightColor:UIColor = UIColor.ThemeLabel.colorLite
    
    var indicatorWidth :CGFloat = 15.0
    var indicatorHeight :CGFloat = 3.0
    var horizonGap :CGFloat = 40
    var startX :CGFloat = 15
}

class KRSelectionTitleBar: UIView {
    
    var titleBtns:[KRTitleBarItem] = []
    
    lazy var baseScroll: UIScrollView = {
        let object = UIScrollView.init()
        return object
    }()
    
    lazy var seperator: UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    
    var titleBarCallback:((Int)->())?
    
    var style:KRSelectionBarStyle = KRSelectionBarStyle()
    func onCreate() {
        themeNoti()
        addSubViews([baseScroll,seperator])
        baseScroll.snp.makeConstraints { (make) in
            make.top.right.bottom.left.equalToSuperview()
        }
        seperator.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func hideSeperator() {
        seperator.isHidden = true
    }
    
    func themeNoti() {
        _ = NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: THEME_CHANGE_NOTI))
            .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
            .subscribe(onNext: {[weak self] notification in
                guard let `self` = self else {return}
                self.reloadUI()
            })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        onCreate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadUI() {
        self.backgroundColor = UIColor.ThemeView.bg
        for bar in self.titleBtns {
            bar.backgroundColor = UIColor.ThemeView.bg
        }
    }
    
    func setSelected(atIdx:Int) {
        for (idx,btn) in self.titleBtns.enumerated() {
            btn.isSelected = (idx == atIdx)
        }
    }
    
    func bindTitleBar(with titles:[String],indicatorColors:[UIColor]=[UIColor.ThemeLabel.colorHighlight,UIColor.ThemeLabel.colorHighlight]) {
        if self.titleBtns.count > 0 {
            for btn in titleBtns {
                btn.removeFromSuperview()
            }
            self.titleBtns.removeAll()
        }
        
        var lastItem:KRTitleBarItem?
        for (idx,title)  in titles.enumerated() {
            let titleBtn = KRTitleBarItem()
            titleBtn.width = style.indicatorWidth
            titleBtn.btnItem.tag = idx
            titleBtn.setFont(style.titleFont)
            titleBtn.setTitle(title)
            titleBtn.setTitleColor(self.style.titleColor, state:.normal)
            titleBtn.setTitleColor(self.style.titleHighLightColor, state: .selected)
            if indicatorColors.count > idx {
                let color = indicatorColors[idx]
                titleBtn.selectedColor = color
            }
            titleBtn.btnItem.addTarget(self, action: #selector(onTitleBtnAction(sender:)), for: .touchUpInside)
            self.baseScroll.addSubview(titleBtn)
            self.titleBtns.append(titleBtn)
        
            if  titles.count == 1 {
                titleBtn.snp.makeConstraints { (make) in
                    make.left.equalTo(style.startX)
                    make.right.lessThanOrEqualTo(baseScroll.snp.right)
                    make.centerY.equalToSuperview()
                    make.top.bottom.equalToSuperview()
                }
            }else {
                if let btn = lastItem {
                    if idx == titles.count - 1 {
                        titleBtn.snp.makeConstraints { (make) in
                            make.left.equalTo(btn.snp.right).offset(self.style.horizonGap)
                            make.right.lessThanOrEqualTo(baseScroll.snp.right)
                            make.centerY.equalToSuperview()
                            make.top.bottom.equalToSuperview()
                        }
                    }else {
                        titleBtn.snp.makeConstraints { (make) in
                            make.left.equalTo(btn.snp.right).offset(self.style.horizonGap)
                            make.centerY.equalToSuperview()
                            make.top.bottom.equalToSuperview()
                        }
                    }
                }else {
                    titleBtn.snp.makeConstraints { (make) in
                        make.left.equalTo(style.startX)
                        make.centerY.equalToSuperview()
                        make.top.bottom.equalToSuperview()
                    }
                }
            }
            lastItem = titleBtn
        }
        self.setSelected(atIdx: 0)
    }
    
    @objc func onTitleBtnAction(sender:UIButton) {
        for btn in titleBtns {
            btn.isSelected = (btn.btnItem == sender)
        }
        self.titleBarCallback?(sender.tag)
    }
}
