//
//  KRAssetDrawerV.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/2.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRAssetDrawerV: KRBaseV {
    
    var entity : KRDrawerSiftSecEntity = KRDrawerSiftSecEntity()
    
    var itemsArr : [KRFlatBtn] = []
    
    var btnW : CGFloat = 0
    
    var btnH : CGFloat = 32
    
    var spaceW : CGFloat = 0
    
    var spaceH : CGFloat = 0
    
    public convenience init(frame: CGRect,_ data : KRDrawerSiftSecEntity) {
        self.init(frame: frame)
        entity = data
        titleLabel.text = entity.title
        btnW = (SCREEN_WIDTH * CGFloat(300.0/375.0) - CGFloat(MarginSpace)) / 3.0 - CGFloat(MarginSpace)
        spaceW = btnW + CGFloat(MarginSpace)
        spaceH = btnH + CGFloat(MarginSpace)
        handleSubViewsBtns()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.ThemeTab.bg
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel : UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        object.frame = CGRect.init(x: CGFloat(MarginSpace), y: CGFloat(MarginSpace), width: 100, height: 16)
        return object
    }()
    
    func handleSubViewsBtns() {
        for i in 0..<entity.content.count {
            let rowItem = entity.content[i]
            let object = KRFlatBtn()
            object.extSetTitle(rowItem.name, 14, UIColor.ThemeLabel.colorHighlight, .selected)
            object.extSetTitle(rowItem.name, 14, UIColor.ThemeLabel.colorMedium, .normal)
            object.tag = rowItem.type
            object.isSelected = rowItem.isSelect
            addSubview(object)
            itemsArr.append(object)
            let ver = i % 3
            let row  = i / 3
            object.frame = CGRect.init(x: CGFloat(ver) * spaceW + CGFloat(MarginSpace), y: CGFloat(row) * spaceH + CGFloat(MarginSpace) * 3, width: btnW, height: btnH)
        }
    }
}
