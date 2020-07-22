//
//  KRPageWheelItemCell.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/15.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import YYWebImage

class KRPageWheelItemCell: UICollectionViewCell {
    lazy var imgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        return imgV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imgV)
        imgV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(_ entity : KRBannerItemEntity){
        if let url = URL.init(string: entity.image_url){
            imgV.yy_setImage(with: url , placeholder: UIImage.init(named: "banner"), options: YYWebImageOptions.allowBackgroundTask, completion: nil)
        }else{
            imgV.image = UIImage.init(named: "banner")
        }
        
    }
}
