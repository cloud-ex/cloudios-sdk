//
//  KRSwapBidAskTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/25.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSwapBidAskTC: UITableViewCell {
    
    var row: Int = 0
    
    private var scale: Float = 0
    
    lazy var pxLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: nil, alignment: .left)
        return object
    }()
    lazy var qtyLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .right)
        return object
    }()
    lazy var scaleView : UIView = {
        let object = UIView()
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.ThemeView.bg
        if reuseIdentifier == "KRSwapAskTC" {
            pxLabel.textColor = UIColor.ThemekLine.down
            scaleView.backgroundColor = UIColor.ThemekLine.down.withAlphaComponent(0.15)
        } else if reuseIdentifier == "KRSwapBidTC" {
            pxLabel.textColor = UIColor.ThemekLine.up
            scaleView.backgroundColor = UIColor.ThemekLine.up.withAlphaComponent(0.15)
        }
        setupSubviewsLayout()
    }
    
    func setupSubviewsLayout() {
        contentView.addSubViews([pxLabel,qtyLabel,scaleView])
        pxLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(15)
            make.centerY.equalToSuperview()
        }
        qtyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(pxLabel.snp.right).offset(5)
            make.centerY.height.width.equalTo(pxLabel)
            make.right.equalToSuperview()
        }
    }
    
    func setCell(_ entity: SLOrderBookModel?) {
        pxLabel.text = entity?.px ?? "--"
        qtyLabel.text = entity?.qty ?? "--"
        
        //深度比例
        var sellDiv = Float(entity?.max_volume ?? "0")
        if sellDiv == 0 {
            sellDiv = Float(Int.max)
        }
        setDepthVolScale(Float(entity?.qty ?? "0")!/sellDiv!)
    }
    
    func setCoinCell(_ entity: SLOrderBookModel?,_ swapInfo : BTContractsModel?) {
        guard entity != nil , swapInfo != nil else {
            return
        }
        pxLabel.text = entity?.px ?? "--"
        let qty = SLFormula.ticket(toCoin: entity?.qty ?? "0", price: entity?.px ?? "0", contract: swapInfo!).toSmallValue(withContract: swapInfo?.instrument_id ?? 0)
        qtyLabel.text = qty ?? "--"
        
        //深度比例
        var sellDiv = Float(entity?.max_volume ?? "0")
        if sellDiv == 0 {
            sellDiv = Float(Int.max)
        }
        setDepthVolScale(Float(entity?.qty ?? "0")!/sellDiv!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDepthVolScale(_ scale: Float) {
        guard scale != self.scale else { return }
        self.scale = scale
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.scaleView.frame = CGRect.init(x: (self.scaleView.superview?.bounds.width ?? 0)*CGFloat(1-scale),
                                               y: 0.5,
                                               width: (self.scaleView.superview?.bounds.width ?? 0)*CGFloat(scale),
                                               height: (self.scaleView.superview?.bounds.height ?? 0)-1)
        }, completion: nil)
    }
}
