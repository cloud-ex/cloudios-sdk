//
//  KRAccountView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/16.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRAccountView: UITableView {
    
    var rowDatas : [KRSettingVEntity] = PublicInfoEntity.sharedInstance.getAccountCM()
    
    lazy var accountHeadView : KRAccountHeadView = {
        let object = KRAccountHeadView.init(frame:CGRect.init(x: 0, y: 0, width: 300/375 * SCREEN_WIDTH, height: 134))
        return object
    }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.backgroundColor = .clear
        self.extUseAutoLayout()
        self.extSetTableView(self, self)
        self.bounces = false
        self.extRegistCell([KRAccountTC.classForCoder()], ["KRAccountTC"])
        self.showsVerticalScrollIndicator = false
        self.rowHeight = 60
        self.tableHeaderView = accountHeadView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KRAccountView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = rowDatas[indexPath.row]
        let cell : KRAccountTC = tableView.dequeueReusableCell(withIdentifier: "KRAccountTC", for: indexPath) as! KRAccountTC
        cell.setCell(entity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let entity = rowDatas[indexPath.row]
            let settingVc = KRSettingVc.init(.systemSetting)
            settingVc.setTitle(entity.name)
            self.yy_viewController?.gy_sidePushViewController(viewController: settingVc)
            return
        }
        if KRBusinessTools.loginStatus() == false {
            KRBusinessTools.showLoginVc(self.yy_viewController)
        } else {
            let entity = rowDatas[indexPath.row]
            if indexPath.row == 0 {
                let transferVc = KRTransferVc()
                transferVc.setTitle(entity.name)
                self.yy_viewController?.gy_sidePushViewController(viewController: transferVc)
            } else if indexPath.row == 1 {
                let securityVc = KRSettingVc.init(.securitySetting)
                securityVc.setTitle(entity.name)
                self.yy_viewController?.gy_sidePushViewController(viewController: securityVc)
            }
        }
    }
}
