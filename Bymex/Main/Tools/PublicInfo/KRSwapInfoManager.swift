//
//  KRSwapInfoManager.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/19.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSwapInfoManager: NSObject {

    //MARK:单例
    public static var sharedInstance : KRSwapInfoManager{
        struct Static {
            static let instance : KRSwapInfoManager = KRSwapInfoManager()
        }
        return Static.instance
    }
}


extension KRSwapInfoManager {
    class func getSwapLightMoreEntity() -> [KRBouncedModel] {
        var models = [KRBouncedModel]()
        let model = KRBouncedModel()
        model.img = "swap_exchange_line"
        model.name = "资金划转".localized()
        models.append(model)
        
        let model1 = KRBouncedModel()
        model1.img = "swap_contractinfo_line"
        model1.name = "合约信息".localized()
        models.append(model1)
        
        let model2 = KRBouncedModel()
        model2.img = "swap_positioninfo_line"
        model2.name = "仓位信息".localized()
        models.append(model2)
        
        let model3 = KRBouncedModel()
        model3.img = "swap_orders_line"
        model3.name = "委托信息".localized()
        models.append(model3) // 资金划转
        
        let model4 = KRBouncedModel()
        model4.img = "swap_setting_line"
        model4.name = "合约设置".localized()
        models.append(model4) // 合约信息
        
        return models
    }
    
    class func getSwapProfesionMoreEntity() -> [KRBouncedModel] {
        var models = [KRBouncedModel]()
        let model = KRBouncedModel()
        model.img = "swap_setting_line"
        model.name = "合约设置".localized()
        models.append(model)
        
        let model1 = KRBouncedModel()
        model1.img = "swap_exchange_line"
        model1.name = "资金划转".localized()
        models.append(model1)
        
        let model2 = KRBouncedModel()
        model2.img = "swap_contractinfo_line"
        model2.name = "合约信息".localized()
        models.append(model2)
        
        let model3 = KRBouncedModel()
        model3.img = "swap_positioninfo_line"
        model3.name = "仓位信息".localized()
        models.append(model3)
        
        let model4 = KRBouncedModel()
        model4.img = "swap_flashlight_line"
        model4.name = "模式切换".localized()
        models.append(model4) // 合约信息
        
        return models
    }
}
