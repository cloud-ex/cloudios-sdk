//
//  KRSwapDetailDepthTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/8.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSwapDetailDepthTC: UITableViewCell {
    lazy var depthView: KRKLineDepthView = {
        let view = KRKLineDepthView()
        return view
    }() 
    
    private lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    private lazy var leftTitle: UILabel = UILabel(text: "买盘 数量".localized() + "(" + "张".localized() + ")", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
    
    private lazy var middleTitle: UILabel = UILabel(text: "价格".localized() + "(USDT)", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
    
    private lazy var rightTitle: UILabel = UILabel(text: "卖盘 数量".localized() + "(" + "张".localized() + ")", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        if reuseIdentifier == "KRSwapDetailDepthView" {
            contentView.addSubview(depthView)
            depthView.snp_makeConstraints { (make) in
                make.left.top.right.bottom.equalToSuperview()
            }
        } else if reuseIdentifier == "KRMarketDetailDepthCell_ID" {
            self.contentView.addSubViews([topLineView, leftTitle, middleTitle, rightTitle])
            self.initLayout()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        
        topLineView.snp_remakeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        leftTitle.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        middleTitle.snp_makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        rightTitle.snp_makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    func setMiddleUnit(_ unit : String) {
        middleTitle.text = String(format: "价格(%@)".localized(), unit)
    }
}
