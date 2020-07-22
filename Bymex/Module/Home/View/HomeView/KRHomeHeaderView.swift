//
//  KRHomeHeaderView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/15.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRHomeHeaderView: KRBaseV {
    var bannerHeight : CGFloat = pagewheelHeight//banner高度
    
    var recommendHeight : CGFloat = 100//推荐高度 10
    
    lazy var headerContainer:UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        return container
    }()
    
    // banner
    lazy var pageWheelView : KRPageWheelView = {
        let view = KRPageWheelView()
        view.extUseAutoLayout()
        return view
    }()
    
    // 推荐
    lazy var recommendedView : KRRecommendedView = {
        let view = KRRecommendedView()
        view.extUseAutoLayout()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeNav.bg
        self.addSubview(headerContainer)
        headerContainer.addArrangedSubview(pageWheelView)
        headerContainer.addArrangedSubview(recommendedView)
        
        headerContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        pageWheelView.snp.makeConstraints { (make) in
            make.height.equalTo(pagewheelHeight)
        }
        recommendedView.snp.updateConstraints { (make) in
            make.height.equalTo(recommendHeight)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置banner元素
    func setBannerView(_ entity : KRHeaderBannerEntity){
        pageWheelView.setView(entity)
    }
    
    // 设置Recommend
    func setRecommend(_ entity : [KRSettingVEntity]) {
        recommendedView.setView(entity)
    }
}
