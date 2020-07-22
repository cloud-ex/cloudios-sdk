//
//  KRRecommendCell.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/15.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import YYWebImage

class KRRecommendCell: UICollectionViewCell {
    
    lazy var iconView : UIImageView = {
        let object = UIImageView.init(image: UIImage.themeImageNamed(imageName: ""))
        return object
    }()
    
    lazy var nameLabel : UILabel = {//名字
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .center)
        object.extUseAutoLayout()
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([iconView,nameLabel])
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(48)
            make.top.equalTo(10)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(14)
            make.top.equalTo(iconView.snp.bottom).offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(_ entity : KRSettingVEntity){
//        if let url = URL.init(string: entity.image_url){
//            iconView.yy_setImage(with: url , placeholder: UIImage.init(named: "banner"), options: YYWebImageOptions.allowBackgroundTask, completion: nil)
//        }else{
//            iconView.image = UIImage.init(named: "banner")
//        }
        iconView.image = UIImage.themeImageNamed(imageName: entity.image_url)
        nameLabel.text = entity.name
    }
}
