//
//  KRThemeImages.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import SwiftTheme

extension UIImage {
    static func themeImageNamed(imageName:String) -> UIImage {
        if KRThemeManager.isNight() {
            let temp = UIImage.init(named:imageName + "_night")
            if let exsitImg = temp {
                return exsitImg
            } else {
                if let img = UIImage.init(named: imageName) {
                    return img
                }
            }
            return UIImage()
        }else {
            let temp = UIImage.init(named:imageName + "_daytime")
            if let exsitImg = temp {
                return exsitImg
            }else {
                if let img = UIImage.init(named: imageName) {
                    return img
                }
            }
            return UIImage()
        }
    }
}
