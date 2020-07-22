//
//  KRSettingVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/21.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

enum SettingVcType {
    case securitySetting // 安全设置
    case systemSetting  // 系统设置
    case setLanguage    // 设置语言
    case setTrendColor  // 设置涨跌色
    case setSkinColor  // 设置皮肤
    case setPersonalInfo //个人信息
    case selectCoin     // 选择币种
    case setEffectiveTime // 设置有效时长
}

class KRSettingVc: KRNavCustomVC {
    
    typealias ClickCellBlock = (String) -> ()
    var clickCellBlock : ClickCellBlock?
    
    var tableViewRowDatas : [KRSettingSecEntity] = []
    
    var vcType = SettingVcType.systemSetting
    
    lazy var tableView : UITableView = {
        let tableV = UITableView()
        tableV.extUseAutoLayout()
        tableV.extSetTableView(self, self)
        tableV.separatorStyle = .none
        tableV.backgroundColor = UIColor.ThemeView.bg
        if vcType == .securitySetting {
            tableV.extRegistCell([KRSettingTC.classForCoder(),KRSwitchTC.classForCoder()], ["KRSettingTC","KRSwitchTC"])
        } else if vcType == .systemSetting {
            tableV.extRegistCell([KRSettingTC.classForCoder()], ["KRSettingTC"])
        } else if vcType == .setLanguage || vcType == .setTrendColor || vcType == .setSkinColor {
            tableV.extRegistCell([BaseSettingTC.classForCoder()], ["BaseSettingTC"])
        } else if vcType == .setPersonalInfo {
            tableV.extRegistCell([KRSettingTC.classForCoder(),SettingIconTC.classForCoder()], ["KRSettingTC","SettingIconTC"])
        } else if vcType == .selectCoin {
            tableV.extRegistCell([SelectedTC.classForCoder()], ["SelectedTC"])
        } else if vcType == .setEffectiveTime {
            tableV.extRegistCell([BaseSettingTC.classForCoder()], ["BaseSettingTC"])
        }
        tableV.rowHeight = 48
        tableV.bounces = false
        return tableV
    }()
    
    public convenience init(_ type : SettingVcType) {
        self.init()
        self.vcType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        setSettingDatas(self.vcType)
    }
    
    func setSettingDatas(_ type : SettingVcType) {
        if type == .securitySetting {
            self.tableViewRowDatas = PublicInfoEntity.sharedInstance.getSecurityCM()
        } else if type == .systemSetting {
            self.tableViewRowDatas = PublicInfoEntity.sharedInstance.getSettingPage()
        } else if type == .setLanguage {
            self.tableViewRowDatas = PublicInfoEntity.sharedInstance.getLanguagePage()
        } else if type == .setTrendColor {
            self.tableViewRowDatas = PublicInfoEntity.sharedInstance.getTrendColorPage()
        } else if type == .setSkinColor {
            self.tableViewRowDatas = PublicInfoEntity.sharedInstance.getSkinColorPage()
        } else if vcType == .setPersonalInfo {
            self.tableViewRowDatas = PublicInfoEntity.sharedInstance.getPersonalInfoPage()
        } else if vcType == .setEffectiveTime {
            self.tableViewRowDatas = PublicInfoEntity.sharedInstance.getEffectiveTimePage()
        } else if vcType == .selectCoin {
            
        }
        tableView.reloadData()
    }
}

extension KRSettingVc: UITableViewDelegate ,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contents = tableViewRowDatas[section].contents
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contents = tableViewRowDatas[indexPath.section].contents
        let entity = contents[indexPath.row]
        if entity.cellType == .defaultTC {
            let cell : KRSettingTC = tableView.dequeueReusableCell(withIdentifier: "KRSettingTC") as! KRSettingTC
            cell.setCell(entity)
            return cell
        } else if entity.cellType == .switchTC {
            let cell : KRSwitchTC = tableView.dequeueReusableCell(withIdentifier: "KRSwitchTC") as! KRSwitchTC
            cell.clickSwitchBlock = { [weak self] isOn in
                if entity.vmType == .faceID {
                    if isOn {
                        let faceVc = KRBiometricsVc.init(.openFace)
                        faceVc.settingBiometricsBlock = {res in
                            if res == false {
                                cell.setSwitch(false)
                            }
                        }
                        self?.navigationController?.pushViewController(faceVc, animated: true)
                    } else {
                        KRBiometricsTool.sharedInstance.authorizeBiometrics { (result) in // 生物识别
                            if !result  {
                                cell.setSwitch(true)
                            } else {
                                XUserDefault.setFaceIdOrTouchId("")
                            }
                        }
                    }
                } else if entity.vmType == .finger {
                    if isOn {
                        let fingerVc = KRBiometricsVc.init(.openFinger)
                        fingerVc.settingBiometricsBlock = {res in
                            if res == false {
                                cell.setSwitch(false)
                            }
                        }
                        self?.navigationController?.pushViewController(fingerVc, animated: true)
                    } else {
                        KRBiometricsTool.sharedInstance.authorizeBiometrics { (result) in // 生物识别
                            if !result  {
                                cell.setSwitch(true)
                            } else {
                                XUserDefault.setFaceIdOrTouchId("")
                            }
                        }
                    }
                } else if entity.vmType == .gesture {
                    if isOn {
                        let gestureVc = KRGestureVerifyVc.init(.remindSet)
                        gestureVc.settingGesturePwdBlock = {res in
                            if res == false {
                                cell.setSwitch(false)
                            }
                        }
                        self?.navigationController?.pushViewController(gestureVc, animated: true)
                    } else {
                        let gestureVc = KRGestureVerifyVc.init(.closeVerify)
                        self?.navigationController?.pushViewController(gestureVc, animated: true)
                        gestureVc.settingGesturePwdBlock = {res in
                            if res == false {
                                cell.setSwitch(true)
                            }
                        }
                    }
                }
            }
            cell.setCell(entity)
            return cell
        } else if entity.cellType == .baseTC {
            let cell : BaseSettingTC = tableView.dequeueReusableCell(withIdentifier: "BaseSettingTC") as! BaseSettingTC
            cell.setCell(entity)
            return cell
        } else if entity.cellType == .iconTC {
            let cell : SettingIconTC = tableView.dequeueReusableCell(withIdentifier: "SettingIconTC") as! SettingIconTC
            cell.setCell(entity)
            return cell
        } else if entity.cellType == .selectTC {
            let cell : SelectedTC = tableView.dequeueReusableCell(withIdentifier: "SelectedTC") as! SelectedTC
            cell.setCell(entity)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionEntity = tableViewRowDatas[section]
        if sectionEntity.title.count > 0 {
            let v = createHeaderViewWithTitle(sectionEntity.title)
            return v
        } else {
            if section == 0 {
                return UIView.init(frame:CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 20))
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionEntity = tableViewRowDatas[section]
        if sectionEntity.hasLogout {
            let view = PersonInfoLogoutView()
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionEntity = tableViewRowDatas[section]
        if sectionEntity.hasLogout {
            return 120
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionEntity = tableViewRowDatas[section]
        if sectionEntity.title.count > 0 {
           return 50
        } else {
            if section == 0 {
                return 20
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contents = tableViewRowDatas[indexPath.section].contents
        let entity = contents[indexPath.row]
        if self.vcType == .securitySetting { // 安全设置
            self.onCellClick(entity)
        } else if self.vcType == .systemSetting { // 系统设置
            var jumpType = SettingVcType.setLanguage
            if indexPath.row == 1 {
                jumpType = .setTrendColor
            } else if indexPath.row == 2 {
                jumpType = .setSkinColor
            }
            let jumpVc : KRSettingVc =  KRSettingVc.init(jumpType)
            jumpVc.setTitle(entity.name)
            self.navigationController?.pushViewController(jumpVc, animated: true)
        } else if self.vcType == .setLanguage { // 设置语言
            setLanguage(entity)
        } else if self.vcType == .setTrendColor { // 设置涨跌色
            setTrendColor(entity)
        } else if self.vcType == .setSkinColor { // 设置皮肤
            setSkin(entity)
        } else if self.vcType == .setPersonalInfo { // 个人信息
            onCellClick(entity)
        } else if self.vcType == .selectCoin { // 选择币种
            self.clickCellBlock?(entity.name)
            self.navigationController?.popViewController(animated: true)
        } else if self.vcType == .setEffectiveTime { // 设置有效时长
            var time = 0
            if indexPath.row == 1 {
                time = 900
            } else if indexPath.row == 1 {
                time = 7200
            }
            configAssetPasswordEffectiveTime(time)
        }
    }
    
    func createHeaderViewWithTitle(_ title : String) -> UIView {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
        v.backgroundColor = UIColor.ThemeView.bg
        let titleLabel = UILabel.init(text: title, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        v.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(30)
            make.height.equalTo(16)
        }
        return v
    }
    
    func onCellClick(_ entity : KRSettingVEntity) {
        switch entity.vmType {
        case .iconSet:
            EXAlert.showMessageAlert("目前暂时不支持头像修改，修改头像会很快上线哦！")
            break
        case .nikeName:
            if entity.defaule != XUserDefault.getActiveAccount()?.account_name {
                let vc = KRSetAccountVc.init(.nikeName)
                vc.setTitle("修改昵称".localized())
                vc.handleRequestBlock = {[weak self] result in
                    guard let mySelf = self else {return}
                    mySelf.setSettingDatas(mySelf.vcType)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                EXAlert.showMessageAlert("昵称暂不支持修改")
            }
        case .bingPhone:
            if entity.defaule != XUserDefault.getActiveAccount()?.phone {
                let vc = KRSetAccountVc.init(.bingPhone)
                vc.setTitle("绑定手机".localized())
                vc.handleRequestBlock = {[weak self] result in
                    guard let mySelf = self else {return}
                    mySelf.setSettingDatas(mySelf.vcType)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .bingEmail:
            if entity.defaule != XUserDefault.getActiveAccount()?.email {
                let vc = KRSetAccountVc.init(.bingEmail)
                vc.setTitle("绑定邮箱".localized())
                vc.handleRequestBlock = {[weak self] result in
                    guard let mySelf = self else {return}
                    mySelf.setSettingDatas(mySelf.vcType)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .assetPwd:
            let vc = KRSetAccountVc.init(.assetPwd)
            vc.setTitle("资金密码".localized())
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .google:
            if entity.defaule == "unbound" {
                let vc = KRSetAccountVc.init(.google)
                vc.setTitle("绑定谷歌".localized())
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .effective:
            let vc = KRSettingVc.init(.setEffectiveTime)
            vc.setTitle("设置有效时长".localized())
            vc.clickCellBlock = {[weak self] str in
                guard let mySelf = self else {return}
                mySelf.setSettingDatas(mySelf.vcType)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
}

// MARK:- 发送请求
extension KRSettingVc {
    // 设置有效时长
    func configAssetPasswordEffectiveTime(_ effectiveTime:Int) {
        let verifySheet = KRVerifySheet(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 380))
        verifySheet.setUserInfo(4)
        verifySheet.clickFinishVerifyBlock = {[weak self] code in
            guard let mySelf = self else {return}
            appAPI.rx.request(AppAPIEndPoint.assetPasswordEffectiveTime(password: code, effectiveTime: effectiveTime)).MJObjectMap(KRAccountEntity.self).subscribe(onSuccess: { (result) in
                PublicInfoManager.updataAccountPasswordEffective(result.asset_password_effective_time)
                mySelf.clickCellBlock?("")
                mySelf.navigationController?.popViewController(animated: true)
            }) { (error) in
                
            }.disposed(by: mySelf.disposeBag)
            EXAlert.dismiss()
        }
        EXAlert.showSheet(sheetView: verifySheet)
    }
    
    // 设置皮肤
    func setSkin(_ entity:KRSettingVEntity) {
        if entity.name == "黑夜版".localized() {
            if KRThemeManager.current == KRThemeManager.night {
                self.navigationController?.popViewController(animated: true)
            } else {
                KRThemeManager.switchTo(theme: .night)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    self.navigationController?.popToRootViewController(animated: false)
                    KRBusinessTools.reloadWindow()
                })
            }
        } else if entity.name == "白天版".localized() {
            if KRThemeManager.current == KRThemeManager.day {
                self.navigationController?.popViewController(animated: true)
            } else {
                KRThemeManager.switchTo(theme: .day)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    self.navigationController?.popToRootViewController(animated: false)
                    KRBusinessTools.reloadWindow()
                })
            }
        }
    }
    
    // 设置语言
    func setLanguage(_ entity:KRSettingVEntity) {
        if entity.name == "中文".localized() {
            if KRBasicParameter.isHan() {
                return
            }
            KRLaunguageTools.shareInstance.setLanguage(langeuage: "zh-CN")
        } else if entity.name == "English".localized() {
            if !KRBasicParameter.isHan() {
                return
            }
            KRLaunguageTools.shareInstance.setLanguage(langeuage: "en-US")
        }
        KRBusinessTools.reloadWindow()
        self.navigationController?.popViewController(animated: true)
        KRLaunguageTools.shareInstance.initUserLanguage()
        KRLaunguageBase.sharedInstance.subject.onNext(1)
    }
    
    // 设置涨跌色
    func setTrendColor(_ entity:KRSettingVEntity) {
        if entity.name == "红涨绿跌".localized() {
            if !KRKLineManager.isGreen() {
                return
            }
            KRKLineManager.switchTo(theme: .red)
        } else if entity.name == "绿涨红跌".localized() {
            if KRKLineManager.isGreen() {
                return
            }
            KRKLineManager.switchTo(theme: .green)
        }
        KRBusinessTools.reloadWindow()
        self.navigationController?.popViewController(animated: true)
    }
}
