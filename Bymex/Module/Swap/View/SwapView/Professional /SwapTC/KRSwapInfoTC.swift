//
//  KRSwapInfoTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/2.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSwapInfoTC: UITableViewCell {
    lazy var contentLabel : KRHorDetailLabel = {
        let object = KRHorDetailLabel()
        object.rightLabel.textColor = UIColor.ThemeLabel.colorMedium
        object.rightLabel.font = UIFont.ThemeFont.SecondaryRegular
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        extSetCell()
        setupSubViewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViewsLayout() {
        contentView.addSubViews([contentLabel])
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    func setCell(_ entity : KRSwapInfoEntity) {
        contentLabel.setLeftText(entity.name)
        contentLabel.setRightText(entity.value)
        if entity.showLine {
            contentLabel.addTapLabel()
        }
    }
}

class KRSwapInfoEntity: NSObject {
    var name = ""
    var value = ""
    var showLine = false
    
    public convenience init(_ name : String,_ value: String,_ showLine: Bool = false) {
        self.init()
        self.name = name
        self.value = value
        self.showLine = showLine
    }
}
