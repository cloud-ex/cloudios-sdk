//
//  KRDepositVM.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/28.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class KRDepositVM: NSObject {
    let disposeBag = DisposeBag()
    weak var vc : KRDepositVc?
    func setVC(_ vc : KRDepositVc){
        self.vc = vc
    }
}

extension KRDepositVM {
    func getDepositAddress(_ code:String) {
        settlesAPI.rx.request(SettlesAPIPoint.depositAddress(coin: code)).MJObjectMap(KRSettlesEntity.self).subscribe(onSuccess: {[weak self](entity) in
            self?.vc!.depositV.setEntity(entity)
        }) { (error) in
            print(error)
        }.disposed(by: self.disposeBag)
    }
}
