//
//  KRAssetRecordHeadView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/1.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRAssetRecordHeadView: KRBaseV {
    lazy var iconV : UIImageView = {
        let object = UIImageView()
        return object
    }()
    
    lazy var statusLabel : UILabel = {
        let object = UILabel.init(text: "成功", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .center)
        return object
    }()
    
    lazy var volumeLabel : UILabel = {
        let object = UILabel.init(text: "-- USDT", font: UIFont.ThemeFont.H3Medium, textColor: UIColor.ThemeLabel.colorMedium, alignment: .center)
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([iconV,statusLabel,volumeLabel])
        iconV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconV.snp.bottom).offset(8)
            make.centerX.equalTo(iconV)
            make.height.equalTo(18)
        }
        volumeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconV)
            make.top.equalTo(statusLabel.snp.bottom).offset(8)
            make.height.equalTo(24)
        }
    }
    
    func setHeadV(_ status : Int ,volume:String) {
        var imgStr = "asset_status_wait"
        var statusStr = "审核中".localized()
        switch status {
        case KRSellerStatus.SETTLE_STATUS_REJECTED.rawValue: // 审核拒绝
            imgStr = "asset_status_failure"
            statusStr = "失败".localized()
            break
        case KRSellerStatus.SETTLE_STATUS_FAILED.rawValue: // 转账失败
            imgStr = "asset_status_failure"
            statusStr = "失败".localized()
            break
        case KRSellerStatus.SETTLE_STATUS_SUCCESS.rawValue: // 成功
            imgStr = "asset_status_success"
            statusStr = "成功".localized()
            break
        case KRSellerStatus.SETTLE_STATUS_SIGNED.rawValue,KRSellerStatus.SETTLE_STATUS_PENDING.rawValue: // 转账中
            imgStr = "asset_status_success"
            statusStr = "转账中".localized()
            break
        default:
            break
        }
        statusLabel.text = statusStr
        volumeLabel.text = volume
        iconV.image = UIImage.themeImageNamed(imageName: imgStr)
    }
    
}
