//
//  KRAssetVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/12.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRAssetVc: KRNavCustomVC {
    
    lazy var assetOverview : UILabel = {
        let object = UILabel.init(text: "资产总览".localized(), font: UIFont.ThemeFont.H3Medium, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    
    lazy var moreBtn: UIButton = {
        let object = UIButton()
        object.extSetImages([UIImage.themeImageNamed(imageName: "asset_more")], controlStates: [.normal])
        object.rx.tap.subscribe(onNext:{ [weak self] in
            
        }).disposed(by: disposeBag)
        return object
    }()
    
    let mainView : KRAssetView = {
        let view = KRAssetView()
        view.extUseAutoLayout()
        return view
    }()
    
    override func setNavCustomV() {
        self.navCustomView.addSubViews([assetOverview,moreBtn])
        self.navCustomView.setLeftModule([assetOverview],false,leftSize:[(150,30)],leftDistance:10)
        self.navCustomView.setRightModule([moreBtn], rightSize:[(30,30)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(navCustomView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-TABBAR_HEIGHT)
        }
        if #available(iOS 11.0, *) {
            mainView.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
}
