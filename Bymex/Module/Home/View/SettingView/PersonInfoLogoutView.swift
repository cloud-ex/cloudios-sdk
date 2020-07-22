//
//  PersonInfoLogoutView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/22.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class PersonInfoLogoutView: UIView {
    lazy var logoutBtn : EXButton = {
        let object = EXButton()
        object.extUseAutoLayout()
        object.setTitle("common_action_logout".localized(), for: .normal)
        object.setTitleColor(UIColor.ThemeBtn.colorTitle, for: .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            self?.logout()
        }).disposed(by: disposeBag)
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PersonInfoLogoutView {
    private func logout() {
        let view = KRNormalAlert()
        view.configAlert(title: "",message:"common_tip_logoutDesc".localized())
        view.alertCallback = {(tag) in
            if tag == 0{
                PublicInfoManager.handleLogout()
                EXAlert.showSuccess(msg: "common_action_logout".localized())
                self.yy_viewController?.navigationController?.popToRootViewController(animated: true)
            }
        }
        EXAlert.showAlert(alertView: view)
    }
}
