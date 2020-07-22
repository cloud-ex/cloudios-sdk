//
//  KRTabbarModel.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/10.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRTabbarModel : NSObject {
    
    var localTx = ""
    
    var localDefIcon = ""
    
    var localSelIcon = ""
    
    var onlineTx = ""
    
    var onlineDefIcon = ""
    
    var onlineSelIcon = ""
}

class KRTabbarModels : NSObject {
    lazy var homeModel : KRTabbarModel = {  //首页
        let model = KRTabbarModel()
        model.localTx = "common_tabbar_home".localized()
        model.localDefIcon = "tabbar_home_default"
        model.localSelIcon = "tabbar_home_selected"
        return model
    }()
    
    lazy var swapModel : KRTabbarModel = {  //合约
        let model = KRTabbarModel()
        model.localTx = "common_tabbar_swap".localized()
        model.localDefIcon = "tabbar_swap_default"
        model.localSelIcon = "tabbar_swap_selected"
        return model
    }()
    
    lazy var assetModel : KRTabbarModel = { //资产
        let model = KRTabbarModel()
        model.localTx = "common_tabbar_assets".localized()
        model.localDefIcon = "tabbar_asset_default"
        model.localSelIcon = "tabbar_asset_selected"
        return model
    }()
}
