//
//  KRSignInVM.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/27.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

class KRSignInVM: NSObject {
    
    let disposeBag = DisposeBag()
    
    weak var vc : UIViewController?
    
    func setVC(_ vc : UIViewController){
        self.vc = vc
    }
}

extension KRSignInVM {
    func requestToSignin(_ name : String, _ password:String,_ completeHandle:((Bool)->())?) {
        let verifyTool = KRVerifyCodeTool.sharedInstance
        verifyTool.showNetsVerifyCodeOnView(vc!.view)
        verifyTool.finishVerifyBlock = { [weak self] (result,validate,message) in
            guard let mySelf = self else {
                completeHandle?(false)
                return
            }
            if result {
                var nameType = 1
                if name.contains("@") {
                    nameType = 2
                }
                appAPI.rx.request(AppAPIEndPoint.login(loginType: nameType, userName: name, password: password,validate:validate)).MJObjectMap(KRAccountEntity.self).subscribe(onSuccess: {(entity) in
                    EXAlert.dismiss()
                    entity.dwq = password
                    PublicInfoManager.handleLoginSuccess(entity)
                    completeHandle?(true)
                    mySelf.vc?.navigationController?.popToRootViewController(animated: true)
                }) { (error) in
                    print(error)
                    completeHandle?(false)
                }.disposed(by: mySelf.disposeBag)
            } else {
                completeHandle?(false)
            }
        }
        verifyTool.cancelVerifyBlock = {
            completeHandle?(false)
        }
    }
}
