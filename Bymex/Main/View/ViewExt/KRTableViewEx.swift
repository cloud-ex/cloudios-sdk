//
//  KRTableViewEx.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/10.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

extension UIScrollView {
    func adjustBehaviorDisable() {
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }else {
            
        }
    }
}

extension UITableView{
    func extSetTableView(_ delegate : Any ,_ dataSource : Any ,_ backgroundColor : UIColor = UIColor.ThemeView.bg , _ sepStyle : UITableViewCell.SeparatorStyle = .none){
        self.delegate = delegate as? UITableViewDelegate
        self.dataSource = dataSource as? UITableViewDataSource
        self.backgroundColor = backgroundColor
        self.separatorStyle = sepStyle
    }
    
    func extRegistCell(_ cells : [AnyClass] , _ identifiers : [String]){
        for i in 0..<cells.count{
            self.register(cells[i], forCellReuseIdentifier: identifiers[i])
        }
    }
    
}

extension UITableViewCell{
    func extSetCell(_ backgroundColor : UIColor = UIColor.ThemeView.bg , selStyle : UITableViewCell.SelectionStyle = .none){
        self.contentView.backgroundColor = backgroundColor
        self.selectionStyle = selStyle
    }
}
