//
//  KRSegmentedControl.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/7.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    public convenience init(titles: [Any]?,tintColor : UIColor = UIColor.ThemeView.highlight,selectedIndex: Int = 0) {
        self.init(items: titles)
        if #available(iOS 13.0, *) {
            self.setTitleTextAttributes([.foregroundColor : UIColor.ThemeLabel.colorLite], for: .selected)
            self.setTitleTextAttributes([.foregroundColor : UIColor.ThemeLabel.colorDark], for: .normal)
            self.selectedSegmentTintColor = tintColor
        } else{
            self.setTitleTextAttributes([.foregroundColor : UIColor.ThemeLabel.colorLite], for: .selected)
            self.setTitleTextAttributes([.foregroundColor : UIColor.ThemeLabel.colorDark], for: .normal)
            self.extSetCornerRadius(4)
            self.extSetBorderWidth(1, color: UIColor.ThemeView.highlight)
        }
        self.selectedSegmentIndex = selectedIndex
    }
    
    func setTitles(_ titles : [String]) {
        for (i,title) in titles.enumerated() {
            setTitle(title, forSegmentAt: i)
        }
    }
}
