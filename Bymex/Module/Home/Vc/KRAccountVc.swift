//
//  KRAccountVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/16.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRAccountVc: KRNavCustomVC {
    
    lazy var accountView : KRAccountView = {
        let object = KRAccountView()
        return object
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navCustomView.isHidden = true
        view.backgroundColor = UIColor.ThemeTab.bg
        accountView.backgroundColor = UIColor.ThemeTab.bg
        contentView.addSubview(accountView)
        accountView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
