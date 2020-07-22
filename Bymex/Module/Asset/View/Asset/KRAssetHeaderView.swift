//
//  KRAssetHeaderView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/28.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRAssetHeaderView: KRBaseV {
    
    var recommendHeight : CGFloat = 100
    
    lazy var totalConvertLabel : UILabel = {
        let object = UILabel.init(text: "总资产折合".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    
    lazy var eyeBtn : UIButton = {
        let object = UIButton()
        object.extSetImages([UIImage.themeImageNamed(imageName: "visible"),UIImage.themeImageNamed(imageName: "hide")], controlStates: [.normal,.selected])
        return object
    }()
    
    lazy var totalAssetsLabel : UILabel = {
        let object = UILabel.init(text: "0.00".localized(), font: UIFont.systemFont(ofSize: 20), textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    
    lazy var convertLabel : UILabel = {
        let object = UILabel.init(text: "≈ 0.00 CNY".localized(), font: UIFont.ThemeFont.HeadRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    
    // 推荐
    lazy var recommendedView : KRRecommendedView = {
        let view = KRRecommendedView()
        view.setView(PublicInfoEntity.sharedInstance.getAssetRecommends())
        view.extUseAutoLayout()
        return view
    }()
    
    // 合约账户
    lazy var swapAssetView : KRAssetItemView = {
        let object = KRAssetItemView()
        object.setView("tabbar_swap_default", "合约账户".localized())
        return object
    }()
    
    // 钱包账户
    lazy var walletAssetView : KRAssetItemView = {
        let object = KRAssetItemView()
        object.setView("tabbar_asset_default", "钱包账户".localized())
        return object
    }()
    
    override func setupSubViewsLayout() {
        super.setupSubViewsLayout()
        addSubViews([totalConvertLabel,totalAssetsLabel,convertLabel,recommendedView,swapAssetView,walletAssetView,eyeBtn])
        totalConvertLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(22)
        }
        eyeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(totalConvertLabel)
            make.left.equalTo(totalConvertLabel.snp.right).offset(5)
            make.width.height.equalTo(20)
        }
        totalAssetsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(totalConvertLabel)
            make.top.equalTo(totalConvertLabel.snp.bottom).offset(10)
            make.height.equalTo(26)
        }
        convertLabel.snp.makeConstraints { (make) in
            make.left.equalTo(totalAssetsLabel.snp.right).offset(6)
            make.right.equalToSuperview().offset(-16)
            make.centerY.height.equalTo(totalAssetsLabel)
        }
        recommendedView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(totalAssetsLabel.snp.bottom).offset(10)
            make.height.equalTo(recommendHeight)
        }
        swapAssetView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(recommendedView.snp.bottom).offset(10)
            make.height.equalTo(148)
//            make.bottom.equalToSuperview().offset(-10)
        }
        walletAssetView.snp.makeConstraints { (make) in
            make.left.equalTo(swapAssetView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-20)
            make.top.height.width.equalTo(swapAssetView)
        }
    }
}
