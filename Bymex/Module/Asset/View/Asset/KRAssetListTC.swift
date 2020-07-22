//
//  KRAssetListTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/28.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRAssetListTC: UITableViewCell {
    lazy var nameLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.HeadRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()

    lazy var rightsView : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.extUseAutoLayout()
        object.setTopText("权益".localized())
        return object
    }()
    
    lazy var freezeView : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.extUseAutoLayout()
        object.setTopText("冻结".localized())
        return object
    }()
    
    lazy var avaiView : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.extUseAutoLayout()
        object.contentAlignment = .right
        object.setTopText("可用".localized())
        return object
    }()
    
    lazy var lineV : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(_ entity : KRAssetEntity) {
        nameLabel.text = entity.coin_code
        rightsView.setBottomText("0")
        freezeView.setBottomText(entity.freeze_vol)
        avaiView.setBottomText("0")
    }
}

extension KRAssetListTC {
    private func setupSubviewsLayout() {
        addSubViews([nameLabel,rightsView,freezeView,avaiView,lineV])
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(15)
            make.height.equalTo(20)
        }
        rightsView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(34)
        }
        freezeView.snp.makeConstraints { (make) in
            make.left.equalTo(rightsView.snp.right).offset(10)
            make.top.height.width.equalTo(rightsView)
        }
        avaiView.snp.makeConstraints { (make) in
            make.left.equalTo(freezeView.snp.right).offset(10)
            make.top.height.width.equalTo(rightsView)
            make.left.equalToSuperview().offset(-20)
        }
        lineV.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(rightsView.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
    }
}
