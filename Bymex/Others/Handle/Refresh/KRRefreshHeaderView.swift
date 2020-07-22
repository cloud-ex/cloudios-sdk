//
//  KRRefreshHeaderView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/13.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import MJRefresh
import YYImage
import FLAnimatedImage

class KRRefreshHeaderView: MJRefreshHeader {
    var container:UIView = UIView()
    lazy var logo : FLAnimatedImageView = {
        let object = FLAnimatedImageView()
        return object
    }()
    
    var img = FLAnimatedImage()
    
    override var state: MJRefreshState {
        didSet {
            if state == MJRefreshState.idle {
                logo.stopAnimating()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {[weak self] in
                    self?.logo.removeFromSuperview()
                }
            } else if state == MJRefreshState.pulling {
                container.addSubview(logo)
                logo.snp.makeConstraints { (make) in
                    make.left.equalToSuperview()
                    make.top.bottom.equalToSuperview()
                    make.centerX.equalToSuperview()
                    make.height.width.equalTo(64)
                }
                logo.animatedImage = img
                logo.startAnimating()
            } else if state == MJRefreshState.refreshing {
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        self.mj_h = 64
        self.addSubview(container)
        let imgData = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "/SLContractSDK.bundle/bymex_loading", ofType: "gif")!))
        img = FLAnimatedImage.init(animatedGIFData:imgData)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        container.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
//        logo.snp.makeConstraints { (make) in
//            make.left.equalToSuperview()
//            make.top.bottom.equalToSuperview()
//            make.centerX.equalToSuperview()
//            make.height.width.equalTo(64)
//        }
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
    }
    
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
    }
    
    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewPanStateDidChange(change)
    }
}
