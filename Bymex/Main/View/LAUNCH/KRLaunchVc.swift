//
//  KRLaunchView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/16.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import FLAnimatedImage

class KRLaunchVc: UIViewController {
    
    lazy var imgView : FLAnimatedImageView = {
        let object = FLAnimatedImageView()
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(SCREEN_HEIGHT * 0.45)
            make.height.equalTo(100)
        }
    }
    
    func show(_ didPlayFinishHandle : (() -> Void)? = nil) {
        let imgData = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "/SLContractSDK.bundle/bymex_launch", ofType: "gif")!))
        let img = FLAnimatedImage(animatedGIFData: imgData)
        imgView.animatedImage = img
        imgView.loopCompletionBlock = { (count: UInt) in
            self.imgView.removeFromSuperview()
            didPlayFinishHandle?()
        }
    }
}
