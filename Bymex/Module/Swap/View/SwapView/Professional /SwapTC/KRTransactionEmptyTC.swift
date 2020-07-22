//
//  KRTransactionEmptyTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/7.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRTransactionEmptyTC: UITableViewCell {
    lazy var emptyImage : UIImageView = {
        let object = UIImageView()
        object.image = UIImage.themeImageNamed(imageName: "swap_empty_order")
        return object
    }()
    lazy var emptyTips : UILabel = {
        let object = UILabel.init(text: "赶快开仓吧，你离暴富只差一步", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .center)
        object.numberOfLines = 0
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([emptyImage,emptyTips])
        emptyImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.top.equalTo(30)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(SCREEN_HEIGHT - NAV_SCREEN_HEIGHT - TABBAR_BOTTOM - 84 - 130))
        }
        emptyTips.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(emptyImage.snp.bottom).offset(24)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
