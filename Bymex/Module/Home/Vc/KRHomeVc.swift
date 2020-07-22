//
//  KRHomeVc.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/12.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class KRHomeVc: KRNavCustomVC {
    
    lazy var userBtn: UIButton = {
        let object = UIButton()
        object.extSetImages([UIImage.themeImageNamed(imageName: "home_account")], controlStates: [.normal])
        object.rx.tap.subscribe(onNext:{ [weak self] in
            let vc = KRAccountVc()
            self?.gy_showSide(configuration: { (config) in
                
            }, viewController: vc)
        }).disposed(by: disposeBag)
        return object
    }()
    
    lazy var userName: UILabel = {
        let object = UILabel.init(text: "Hi", font: UIFont.ThemeFont.H3Regular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        object.extUseAutoLayout()
        object.isHidden = true
        return object
    }()
    
    lazy var signInOrUp: UIButton = {
        let object = UIButton()
        object.extSetTitle("home_text_signInOrUp".localized(), 16, UIColor.ThemeLabel.colorLite, .normal)
        object.rx.tap.subscribe(onNext:{ [weak self] in
            let registerVc = KRSignVc()
            self?.navigationController?.pushViewController(registerVc, animated: true)
        }).disposed(by: disposeBag)
        return object
    }()
    
    let mainView : KRHomeView = {
        let view = KRHomeView()
        view.extUseAutoLayout()
        return view
    }()
    
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
        setNotification()
    }
    
    override func setNavCustomV() {
        super.setNavCustomV()
        self.navCustomView.backgroundColor = .clear
        self.navCustomView.addSubViews([signInOrUp,userBtn,userName])
        self.navCustomView.setLeftModule([userBtn,userName], false, leftSize: [(30, 30),(100, 30)])
        self.navCustomView.setRightModule([signInOrUp], rightSize:[(80,22)])
    }
    
    func setNotification() {
        let notificationName = Notification.Name(rawValue: KRLoginStatus)
        _ = NotificationCenter.default.rx
            .notification(notificationName)
            .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
            .subscribe(onNext: {[weak self] notification in
                if let objc = notification.object as? [String:String] ,let status = objc["status"] {
                    if status == "1" && XUserDefault.getToken() != "" {
                        self?.userName.isHidden = false
                        self?.signInOrUp.isHidden = true
                        if let account = XUserDefault.getActiveAccount() {
                            self?.userName.text = "Hi," + (account.account_name != "" ? account.account_name : "User" )
                        }
                    } else if status == "0" {
                        self?.userName.isHidden = true
                        self?.signInOrUp.isHidden = false
                    }
                    self?.navCustomView.layoutIfNeeded()
                }
            })
    }
}

