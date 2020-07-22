//
//  KRAssetItemView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/28.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRAssetItemView: UIButton {
    lazy var iconV : UIImageView = {
        let object = UIImageView()
        return object
    }()
    
    lazy var nameLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        return object
    }()
    
    lazy var balanceLabel : UILabel = {
        let object = UILabel.init(text: "0.00 BTC", font: UIFont.systemFont(ofSize: 16), textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    
    lazy var convertLabel : UILabel = {
        let object = UILabel.init(text: "≈ 0.00 CNY", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViewsLayout() {
        extSetImages([UIImage.themeImageNamed(imageName: "Asset_unselected"),UIImage.themeImageNamed(imageName: "Asset_selected")], controlStates: [.normal,.highlighted])
        addSubViews([iconV,nameLabel,balanceLabel,convertLabel])
        iconV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconV)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(iconV.snp.bottom).offset(4)
            make.height.equalTo(30)
        }
        balanceLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        convertLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(balanceLabel)
            make.top.equalTo(balanceLabel.snp.bottom)
            make.height.equalTo(18)
        }
    }
}

extension KRAssetItemView {
    public func setView(_ imgN : String, _ name : String) {
        iconV.image = UIImage.themeImageNamed(imageName: imgN)
        nameLabel.text = name
    }
}
