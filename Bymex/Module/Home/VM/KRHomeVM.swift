//
//  KRHomeVM.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/19.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import RxSwift

class KRHomeVM: NSObject {
    let disposeBag = DisposeBag()
    
    var bannerEntity : KRHeaderBannerEntity = KRHeaderBannerEntity()
    
    weak var vc : KRHomeVc?
    func setVC(_ vc : KRHomeVc){
        self.vc = vc
    }
}

extension KRHomeVM {
    // 获取banner图片
    func getBannerEntity(_ completeHandle: @escaping ((KRHeaderBannerEntity) -> ())) {
        appAPI.rx.request(AppAPIEndPoint.banners).MJObjectMap(CommonAryModel.self).subscribe(onSuccess: { [weak self] (entity) in
            if entity.data.count > 0 {
                var bannersEntity: [KRHeaderBannerEntity] = []
                for item in entity.data {
                    if let model = KRHeaderBannerEntity.mj_object(withKeyValues: item){
                        bannersEntity.append(model)
                    }
                }
                if bannersEntity.isEmpty == false {
                    self?.bannerEntity = bannersEntity[0]
                }
            }
            completeHandle(self?.bannerEntity ?? KRHeaderBannerEntity())
        }) { (error) in
            print(error)
        }.disposed(by: self.disposeBag)
    }
    
    // 日盈利排行榜
    func getDayProfit(_ completeHandle: @escaping ((KRHeaderBannerEntity) -> ())) {
        
    }
}
