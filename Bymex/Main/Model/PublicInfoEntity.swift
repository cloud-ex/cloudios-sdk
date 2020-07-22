//
//  PublicInfoEntity.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/8.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class PublicInfoEntity: SuperEntity {
    
    var recommendEntitys : [KRSettingVEntity] = []
    
    var assetrecommendEntitys : [KRSettingVEntity] = []
    
    var accountSetEntitys : [KRSettingVEntity] = []
    
    var online_swap_guide = "" // 合约指南
    var online_swap_ADL = "" // 自动减仓
    var online_swap_Close = "" // 强制平仓
    
    var default_country_code = "+86"   // 后台默认地区码 例如 +86
    var default_country_code_real = "156"  //后台默认国家码 例如 156
    
    // MARK:单例
    public static var sharedInstance : PublicInfoEntity {
        struct Static {
            static let instance : PublicInfoEntity = PublicInfoEntity()
        }
        return Static.instance
    }
    
    // 首页便捷跳转
    func getRecommends() -> [KRSettingVEntity] {
        let depositEntity = KRSettingVEntity()
        depositEntity.image_url = "home_deposit"
        depositEntity.name = "home_text_deposit".localized()
        
        let assetEntity = KRSettingVEntity()
        assetEntity.image_url = "home_transfer"
        assetEntity.name = "home_text_transfer".localized()
        
        let helpEntity = KRSettingVEntity()
        helpEntity.image_url = "home_help"
        helpEntity.name = "home_text_help".localized()
        
        let guideEntity = KRSettingVEntity()
        guideEntity.image_url = "home_guide"
        guideEntity.name = "home_text_guide".localized()
        
        recommendEntitys = [depositEntity,assetEntity,helpEntity,guideEntity]
        return recommendEntitys
    }
    
    // 账户页便捷跳转
    func getAccountCM() -> [KRSettingVEntity] {
        let transferEntity = KRSettingVEntity()
        transferEntity.image_url = "account_transfer"
        transferEntity.name = "account_text_transfer".localized()
        
        let accountEntity = KRSettingVEntity()
        accountEntity.image_url = "account_safe"
        accountEntity.name = "account_text_safe".localized()
        
        let settingEntity = KRSettingVEntity()
        settingEntity.image_url = "account_setting"
        settingEntity.name = "account_text_setting".localized()
        
        accountSetEntitys = [transferEntity,accountEntity,settingEntity]
        return accountSetEntitys
    }
    
    // 账户安全页面
    func getSecurityCM() -> [KRSettingSecEntity] {
        var securitySet : [KRSettingSecEntity] = []
        
        let doubleVerify = KRSettingSecEntity()
        doubleVerify.title = "二次验证".localized()
        let phoneEntity = KRSettingVEntity()
        phoneEntity.name = "register_text_phone".localized()
        phoneEntity.defaule = "未绑定".localized()
        phoneEntity.cellType = .defaultTC
        phoneEntity.vmType = .bingPhone
        
        let emailEntity = KRSettingVEntity()
        emailEntity.name = "register_text_mail".localized()
        emailEntity.defaule = "未绑定".localized()
        emailEntity.cellType = .defaultTC
        emailEntity.vmType = .bingEmail
        
        let googleEntity = KRSettingVEntity()
        googleEntity.name = "谷歌验证器".localized()
        googleEntity.defaule = "未绑定".localized()
        googleEntity.cellType = .defaultTC
        googleEntity.vmType = .google
        
        if let account = XUserDefault.getActiveAccount() {
            phoneEntity.defaule = account.phone != "" ? account.phone : phoneEntity.defaule
            emailEntity.defaule = account.email != "" ? account.email : emailEntity.defaule
            googleEntity.defaule = account.ga_key != "unbound" ? "已绑定" : googleEntity.defaule
        }
        
        doubleVerify.contents = [phoneEntity,emailEntity,googleEntity]
        
        let pwdSetting = KRSettingSecEntity()
        pwdSetting.title = "密码设置".localized()
        

        let assetEntity = KRSettingVEntity()
        assetEntity.name = "资金密码".localized()
        assetEntity.defaule = "未设置".localized()
        assetEntity.cellType = .defaultTC
        assetEntity.vmType = .assetPwd
        
        let tradeEntity = KRSettingVEntity()
        tradeEntity.name = "交易确认".localized()
        tradeEntity.switchType = XUserDefault.getOnComfirmSwapAlert() ? "1" : "0"
        tradeEntity.cellType = .switchTC
        
        if let account = XUserDefault.getActiveAccount() {
            switch account.asset_password_effective_time {
            case .AssetPasswordEffectiveNone:
                assetEntity.defaule = "未设置".localized()
                pwdSetting.contents = [assetEntity,tradeEntity]
            case .AssetPasswordLoseEffectiveness:
                assetEntity.defaule = "资金密码失效".localized()
                pwdSetting.contents = [assetEntity,tradeEntity]
            case .AssetPasswordEffectiveTimeNone,.AssetPasswordEffectiveTimeEffectiveneFIF,.AssetPasswordEffectiveTimeEffectiveneTH:
                assetEntity.defaule = "资金密码有效".localized()
                let effectiveEntity = KRSettingVEntity()
                effectiveEntity.name = "资金密码有效时长".localized()
                if account.asset_password_effective_time == .AssetPasswordEffectiveTimeNone {
                    effectiveEntity.defaule = "无时效".localized()
                } else if account.asset_password_effective_time == .AssetPasswordEffectiveTimeEffectiveneFIF {
                    effectiveEntity.defaule = "15分钟".localized()
                } else if account.asset_password_effective_time == .AssetPasswordEffectiveTimeEffectiveneTH {
                    effectiveEntity.defaule = "2小时".localized()
                }
                effectiveEntity.cellType = .defaultTC
                effectiveEntity.vmType = .effective
                pwdSetting.contents = [assetEntity,effectiveEntity,tradeEntity]
            }
        } else {
            pwdSetting.contents = [assetEntity,tradeEntity]
        }
        
        let loginSetting = KRSettingSecEntity()
        loginSetting.title = "登录设置".localized()
        let gesEntity = KRSettingVEntity()
        gesEntity.name = "手势密码".localized()
        gesEntity.switchType = (XUserDefault.getGesturesPassword() != nil) ? "1" : "0"
        gesEntity.cellType = .switchTC
        gesEntity.vmType = .gesture
        
        let faceEntity = KRSettingVEntity()
        faceEntity.name = "Face ID".localized()
        faceEntity.switchType = (XUserDefault.getFaceIdOrTouchIdPassword() != nil) ? "1" : "0"
        faceEntity.cellType = .switchTC
        faceEntity.vmType = .faceID
        loginSetting.contents = [gesEntity,faceEntity]
        
        securitySet = [doubleVerify,pwdSetting,loginSetting]
        return securitySet
    }
    
    // 应用设置页面
    func getSettingPage() -> [KRSettingSecEntity] {
        var setpage : [KRSettingSecEntity] = []
        
        let baseSet = KRSettingSecEntity()
        let lanEntity = KRSettingVEntity()
        lanEntity.name = "语言".localized()
        lanEntity.defaule = KRBasicParameter.isHan() ? "简体中文".localized() : "English".localized()
        lanEntity.cellType = .defaultTC
        
        let trendEntity = KRSettingVEntity()
        trendEntity.name = "涨跌色".localized()
        trendEntity.defaule = "红涨绿跌".localized()
        trendEntity.cellType = .defaultTC
        
        let dayNightEntity = KRSettingVEntity()
        dayNightEntity.name = "皮肤设置".localized()
        dayNightEntity.defaule = (KRThemeManager.current == KRThemeManager.night) ? "黑夜版" : "白天版"
        dayNightEntity.cellType = .defaultTC
        
        baseSet.contents = [lanEntity,trendEntity,dayNightEntity]
        baseSet.hasLogout = true
        setpage = [baseSet]
        
        return setpage
    }
    
    // 语言设置页面
    func getLanguagePage() -> [KRSettingSecEntity] {
        var lanPage : [KRSettingSecEntity] = []
        
        let LanEntity = KRSettingSecEntity()
        
        let cnEntity = KRSettingVEntity()
        cnEntity.name = "中文".localized()
        cnEntity.cellType = .baseTC
        cnEntity.isSelected = KRBasicParameter.isHan()
        
        let enEntity = KRSettingVEntity()
        enEntity.name = "English".localized()
        enEntity.cellType = .baseTC
        enEntity.isSelected = !KRBasicParameter.isHan()
        
        LanEntity.contents = [cnEntity,enEntity]
        lanPage = [LanEntity]
        return lanPage
    }
    
    // 设置涨跌色页面
    func getTrendColorPage() -> [KRSettingSecEntity] {
        var trendColorPage : [KRSettingSecEntity] = []
        
        let trendColorEntity = KRSettingSecEntity()
        
        let redUpEntity = KRSettingVEntity()
        redUpEntity.name = "红涨绿跌".localized()
        redUpEntity.cellType = .baseTC
        redUpEntity.isSelected = !KRKLineManager.isGreen()
        
        let greenUpEntity = KRSettingVEntity()
        greenUpEntity.name = "绿涨红跌".localized()
        greenUpEntity.cellType = .baseTC
        greenUpEntity.isSelected = KRKLineManager.isGreen()
        
        trendColorEntity.contents = [redUpEntity,greenUpEntity]
        trendColorPage = [trendColorEntity]
        return trendColorPage
    }
    
    // 设置皮肤页面
    func getSkinColorPage() -> [KRSettingSecEntity] {
        var skinColorPage : [KRSettingSecEntity] = []
        
        let skinColorEntity = KRSettingSecEntity()
        
        let nightEntity = KRSettingVEntity()
        nightEntity.name = "黑夜版".localized()
        nightEntity.cellType = .baseTC
        nightEntity.isSelected = (KRThemeManager.current == KRThemeManager.night)
        
        let dayEntity = KRSettingVEntity()
        dayEntity.name = "白天版".localized()
        dayEntity.cellType = .baseTC
        dayEntity.isSelected = !(KRThemeManager.current == KRThemeManager.night)
        
        skinColorEntity.contents = [nightEntity,dayEntity]
        skinColorPage = [skinColorEntity]
        return skinColorPage
    }
    
    // 设置个人信息页面
    func getPersonalInfoPage() -> [KRSettingSecEntity] {
        var personInfoPage : [KRSettingSecEntity] = []
        
        let personInfoEntity = KRSettingSecEntity()
        
        let iconEntity = KRSettingVEntity()
        iconEntity.name = "头像".localized()
        iconEntity.cellType = .iconTC
        iconEntity.image_url = ""
        iconEntity.vmType = .iconSet
        
        let nameEntity = KRSettingVEntity()
        nameEntity.name = "昵称".localized()
        nameEntity.cellType = .defaultTC
        if let account = XUserDefault.getActiveAccount() {
             nameEntity.defaule = account.account_name != "" ? account.account_name : "未设置".localized()
        }
        nameEntity.vmType = .nikeName
        
        personInfoEntity.contents = [iconEntity,nameEntity]
        
        personInfoPage = [personInfoEntity]
        return personInfoPage
    }
    
    // 设置资金密码有效时长
    // 设置皮肤页面
    func getEffectiveTimePage() -> [KRSettingSecEntity] {
        var effectiveTimePage : [KRSettingSecEntity] = []
        
        let effectiveTimeEntity = KRSettingSecEntity()
        
        let noneEntity = KRSettingVEntity()
        noneEntity.name = "无有效期".localized()
        noneEntity.cellType = .baseTC
        noneEntity.isSelected = false
        
        let fiftenEntity = KRSettingVEntity()
        fiftenEntity.name = "15分钟".localized()
        fiftenEntity.cellType = .baseTC
        fiftenEntity.isSelected = false
        
        let THEntity = KRSettingVEntity()
        THEntity.name = "2小时".localized()
        THEntity.cellType = .baseTC
        THEntity.isSelected = false
        
        if let account = XUserDefault.getActiveAccount() {
            if account.asset_password_effective_time == .AssetPasswordEffectiveTimeNone {
                noneEntity.isSelected = true
            } else if account.asset_password_effective_time == .AssetPasswordEffectiveTimeEffectiveneFIF {
                fiftenEntity.isSelected = true
            } else if account.asset_password_effective_time == .AssetPasswordEffectiveTimeEffectiveneTH {
                THEntity.isSelected = true
            }
        }
        effectiveTimeEntity.contents = [noneEntity,fiftenEntity,THEntity]
        effectiveTimePage = [effectiveTimeEntity]
        return effectiveTimePage
    }
}

extension PublicInfoEntity {
    func getAssetRecommends() -> [KRSettingVEntity] {
        let depositEntity = KRSettingVEntity()
        depositEntity.image_url = "home_deposit"
        depositEntity.name = "home_text_deposit".localized()
        depositEntity.rmType = .deposit
        
        let withdrawEntity = KRSettingVEntity()
        withdrawEntity.image_url = "asset_withdraw"
        withdrawEntity.name = "asset_text_withdraw".localized()
        withdrawEntity.rmType = .withdraw
        
        let transferEntity = KRSettingVEntity()
        transferEntity.image_url = "home_transfer"
        transferEntity.name = "home_text_transfer".localized()
        transferEntity.rmType = .tranfer
        
        let fundRateEntity = KRSettingVEntity()
        fundRateEntity.image_url = "asset_fundRate"
        fundRateEntity.name = "asset_text_fundRate".localized()
        fundRateEntity.rmType = .fundrate
        
        assetrecommendEntitys = [depositEntity,withdrawEntity,transferEntity,fundRateEntity]
        return assetrecommendEntitys
    }
    
    func getAssetRecordDrawerEntitys(_ type :KRAssetRecordType) -> [KRDrawerSiftSecEntity] {
        var sections : [KRDrawerSiftSecEntity] = []
        switch type {
        case .deposit,.withdraw:
            let section = KRDrawerSiftSecEntity()
            section.title = "币种".localized()
            // 获取币种
            let row = KRDrawerSiftRowEntity()
            row.name = "全部".localized()
            row.isSelect = true
            
            let row1 = KRDrawerSiftRowEntity()
            row1.name = "USDT".localized()
            
            let row2 = KRDrawerSiftRowEntity()
            row2.name = "BTC".localized()
            
            let row3 = KRDrawerSiftRowEntity()
            row3.name = "BTC".localized()
            
            section.content = [row,row1,row2,row3]
            sections = [section]
        case .wallet:
            let section = KRDrawerSiftSecEntity()
            section.title = "类型".localized()
            // 获取币种
            let row = KRDrawerSiftRowEntity()
            row.name = "全部".localized()
            row.isSelect = true
            let row1 = KRDrawerSiftRowEntity()
            row1.name = "充值".localized()
            let row2 = KRDrawerSiftRowEntity()
            row2.name = "提现".localized()
            let row3 = KRDrawerSiftRowEntity()
            row3.name = "转入".localized()
            let row4 = KRDrawerSiftRowEntity()
            row4.name = "转出".localized()
            section.content = [row,row1,row2,row3,row4]
            
            let section1 = KRDrawerSiftSecEntity()
            section1.title = "币种".localized()
            // 获取币种
            let secrow = KRDrawerSiftRowEntity()
            secrow.name = "全部".localized()
            secrow.isSelect = true
            
            let secrow1 = KRDrawerSiftRowEntity()
            secrow1.name = "USDT".localized()
            
            let secrow2 = KRDrawerSiftRowEntity()
            secrow2.name = "BTC".localized()
            
            let secrow3 = KRDrawerSiftRowEntity()
            secrow3.name = "ETH".localized()
            
            section1.content = [secrow,secrow1,secrow2,secrow3]
            sections = [section,section1]
        default:
            break
        }
        return sections
    }
    
    func getSwapOrdersDrawerEntitys() -> [KRDrawerSiftSecEntity] {
        var sections : [KRDrawerSiftSecEntity] = []
        let section = KRDrawerSiftSecEntity()
        section.title = "方向".localized()
        // 获取币种
        let row = KRDrawerSiftRowEntity()
        row.name = "全部".localized()
        row.isSelect = true
        let row1 = KRDrawerSiftRowEntity()
        row1.name = "开多".localized()
        let row2 = KRDrawerSiftRowEntity()
        row2.name = "开空".localized()
        let row3 = KRDrawerSiftRowEntity()
        row3.name = "平多".localized()
        let row4 = KRDrawerSiftRowEntity()
        row4.name = "平空".localized()
        section.content = [row,row1,row2,row3,row4]
        
        let section1 = KRDrawerSiftSecEntity()
        section1.title = "状态".localized()
        // 获取币种
        let secrow = KRDrawerSiftRowEntity()
        secrow.name = "全部".localized()
        secrow.isSelect = true
        
        let secrow1 = KRDrawerSiftRowEntity()
        secrow1.name = "已成交".localized()
        
        let secrow2 = KRDrawerSiftRowEntity()
        secrow2.name = "已撤销".localized()
        
        let secrow3 = KRDrawerSiftRowEntity()
        secrow3.name = "部分成交".localized()
        
        section1.content = [secrow,secrow1,secrow2,secrow3]
        sections = [section,section1]
        return sections
    }
}
