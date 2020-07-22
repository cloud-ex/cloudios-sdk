//
//  KRAssetVM.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/28.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class KRAssetVM: NSObject {
    let disposeBag = DisposeBag()
    let swapAssetsList = BehaviorRelay<[KRAssetEntity]>(value: [])
}

extension KRAssetVM {
    
}
