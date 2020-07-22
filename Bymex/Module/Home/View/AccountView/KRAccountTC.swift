//
//  KRAccountTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/17.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRAccountTC: UITableViewCell {
    lazy var iconView : UIImageView = {
        let object = UIImageView()
        return object
    }()
    lazy var nameLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViewsLayout() {
        contentView.addSubViews([iconView,nameLabel])
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        iconView.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.left.equalTo(15)
            make.centerY.equalTo(contentView)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(8)
            make.centerY.equalTo(iconView)
            make.height.equalTo(20)
        }
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor.ThemeView.bg
    }
    
    func setCell(_ entity : KRSettingVEntity) {
        iconView.image = UIImage.themeImageNamed(imageName: entity.image_url)
        nameLabel.text = entity.name
    }
}
