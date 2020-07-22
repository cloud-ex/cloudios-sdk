//
//  KRBannerItemEntity.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/15.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation


class KRHeaderBannerEntity: SuperEntity {
    var row_number = 0
    var colume_number = 0
    var show_time = 0
    var banners : [KRBannerItemEntity] = []
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "banners" {
            guard let values = value as? [[String : Any]]  else {
                return
            }
            for object in values {
                if let banner = KRBannerItemEntity.mj_object(withKeyValues: object) {
                    banners.append(banner)
                }
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
}

class KRBannerItemEntity: SuperEntity {
    var row_number = 0
    var colume_number = 0
    var name = ""
    var desc = ""
    var language = ""
    var platform = 0
    var image_url = ""
    var jump_url = ""
    var jump_type = 0
    var jump_params = ""
}
