//
//  KRSwapSegmentView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/23.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

class KRSwapSegmentView: KRBaseV {
    
    var subject : PublishSubject<Int> = PublishSubject.init()
    
    lazy var openBtn : UIButton = {
        let object = UIButton()
        object.extSetTitle("", 16, UIColor.ThemeLabel.colorDark, .normal)
        object.setTitleColor(UIColor.ThemeLabel.colorLite, for: .selected)
        object.tag = 1001
        object.extSetAddTarget(self, #selector(clickBtn(_:)))
        object.isSelected = true
        return object
    }()
    lazy var closeBtn : UIButton = {
        let object = UIButton()
        object.extSetTitle("", 16, UIColor.ThemeLabel.colorDark, .normal)
        object.setTitleColor(UIColor.ThemeLabel.colorLite, for: .selected)
        object.tag = 1002
        object.extSetAddTarget(self, #selector(clickBtn(_:)))
        return object
    }()
    lazy var selectedLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.borderSelected
        return object
    }()
    /// 合约计算器
    lazy var calculatorBtn : UIButton = {
        let object = UIButton()
        object.extSetAddTarget(self, #selector(clickBtn(_:)))
        object.tag = 101
        return object
    }()
    /// K线详情页
    lazy var kLineBtn : UIButton = {
        let object = UIButton()
        object.extSetAddTarget(self, #selector(clickBtn(_:)))
        object.tag = 102
        return object
    }()
    lazy var bottomLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([openBtn,closeBtn,selectedLine,calculatorBtn,kLineBtn,bottomLine])
        openBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(proportion_width * 0.5)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(openBtn.snp.right)
            make.top.height.width.equalTo(openBtn)
        }
        kLineBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(openBtn)
            make.width.height.equalTo(25)
        }
        calculatorBtn.snp.makeConstraints { (make) in
            make.right.equalTo(kLineBtn.snp.left).offset(-16)
            make.width.height.centerY.equalTo(kLineBtn)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(openBtn)
            make.right.equalTo(kLineBtn)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        selectedLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.width.equalTo(openBtn)
            make.height.equalTo(2)
            make.centerX.equalTo(openBtn)
        }
        bringSubviewToFront(selectedLine)
    }
}

extension KRSwapSegmentView  {
    @objc func clickBtn(_ btn : UIButton){
        if btn.tag > 1000 { // 开平仓
            btn.isSelected = true
            if btn == openBtn {
                closeBtn.isSelected = false
            } else {
                openBtn.isSelected = false
            }
            selectedLine.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.width.equalTo(openBtn)
                make.height.equalTo(2)
                make.centerX.equalTo(btn)
            }
        }
        subject.onNext(btn.tag)
    }
}

extension KRSwapSegmentView  {
    public func setViewInfo(_ titles: [String] ,images:[String]) {
        openBtn.setTitle(titles[0], for: .normal)
        closeBtn.setTitle(titles[1], for: .normal)
        calculatorBtn.setImage(UIImage.themeImageNamed(imageName: images[0]), for: .normal)
        kLineBtn.setImage(UIImage.themeImageNamed(imageName: images[1]), for: .normal)
    }
}
