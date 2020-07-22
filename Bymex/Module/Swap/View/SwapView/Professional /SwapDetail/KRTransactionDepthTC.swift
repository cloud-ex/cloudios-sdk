//
//  KRTransactionDepthTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/8.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRTransactionDepthTC: UITableViewCell {
    var row: Int = 0
    
    var buyScale : Double = 0
    
    var sellScale : Double = 0
    
    // 买盘数量
    lazy var buyNumLabel: UILabel = UILabel(text: "--", font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
    
    /// 买价格
    lazy var buyPriceLabel: UILabel = UILabel(text: "--", font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemekLine.up, alignment: .right)
    
    /// 卖价格
    lazy var sellPriceLabel: UILabel = UILabel(text: "--", font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemekLine.down, alignment: .left)
    
    /// 卖盘数量
    lazy var sellNumLabel : UILabel = UILabel(text: "--", font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
    
    /// 买背景
    lazy var buyBackV: UIView = {
        let view = UIView.init(frame: CGRect.init(x: SCREEN_WIDTH * 0.5 - 15 , y: 0.5, width: 1, height: 24))
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemekLine.up
        view.alpha = 0.15
        return view
    }()
    
    /// 卖背景
    lazy var sellBackV: UIView = {
        let view = UIView.init(frame: CGRect.init(x: SCREEN_WIDTH * 0.5 - 15, y: 0.5, width: 1, height: 24))
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemekLine.down
        view.alpha = 0.15
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        backgroundColor = UIColor.ThemeView.bg
        contentView.addSubViews([buyNumLabel, buyPriceLabel, sellPriceLabel, sellNumLabel, buyBackV, sellBackV])
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.bottom.equalToSuperview()
        }
        buyNumLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        buyPriceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.centerX).offset(-5)
            make.centerY.equalTo(buyNumLabel)
            make.height.equalTo(13)
        }
        sellPriceLabel.snp.makeConstraints { (make ) in
            make.left.equalTo(contentView.snp.centerX).offset(5)
            make.centerY.equalTo(buyNumLabel)
            make.height.equalTo(13)
        }
        sellNumLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.height.equalTo(buyNumLabel)
        }
//        buyBackV.snp.makeConstraints { (make) in
//            make.right.equalTo(contentView.snp.centerX)
//            make.bottom.top.equalToSuperview()
//            make.width.equalTo(0)
//        }
//        sellBackV.snp.makeConstraints { (make) in
//            make.left.equalTo(contentView.snp.centerX)
//            make.bottom.top.equalToSuperview()
//            make.width.equalTo(0)
//        }
    }
    
    /// 数据更新
    func updateCell(buyModel: SLOrderBookModel?, sellModel: SLOrderBookModel?, maxBidVol: Double,maxAskVol: Double) {
        var buyPriceStr: String = "--"
        var buyVolStr: String = "--"
        var buysScale: Double = 0.0
        if let _buyModel = buyModel {
            buyPriceStr = _buyModel.px
            buyVolStr = _buyModel.qty.elementsEqual("0") ? "--" : _buyModel.qty
            if maxBidVol == 0 {
                buysScale = 0.1
            } else {
                buysScale = KRBasicParameter.handleDouble(_buyModel.addupQty ?? "0") / maxBidVol
            }
        }
        self.buyPriceLabel.text = buyPriceStr
        let buyQty = (buyVolStr.count > 0 ? BTFormat.depthValue(fromNumberStr: buyVolStr) : "0") ?? "0"
        self.buyNumLabel.text = buyQty
        setOrderBookBuyScale(buysScale)
        
        var sellPriceStr: String = "--"
        var sellVolStr: String = "--"
        var buyScale: Double = 0.0
        if let _sellModel = sellModel {
            sellPriceStr = _sellModel.px
            sellVolStr = _sellModel.qty.elementsEqual("0") ? "--" : _sellModel.qty
            if maxAskVol == 0 {
                buyScale = 0.1
            } else {
                buyScale = KRBasicParameter.handleDouble(_sellModel.addupQty ?? "0") / maxAskVol
            }
        }
        self.sellPriceLabel.text = sellPriceStr
        let sellQty = (sellVolStr.count > 0 ? BTFormat.depthValue(fromNumberStr: sellVolStr) : "0") ?? "0"
        self.sellNumLabel.text = sellQty
        setOrderBookSellScale(buyScale)
    }
    
    func setOrderBookBuyScale(_ scale: Double) {
        guard scale != self.buyScale else { return }
        self.buyScale = scale
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.buyBackV.frame = CGRect.init(x: (SCREEN_WIDTH * 0.5 - 15)*CGFloat(1-scale),
                                               y: 0.5,
                                               width: (SCREEN_WIDTH * 0.5 - 15)*CGFloat(scale),
                                               height: 24)
        }, completion: nil)
    }
    
    func setOrderBookSellScale(_ scale: Double) {
        guard scale != self.sellScale else { return }
        self.sellScale = scale
        let w = (SCREEN_WIDTH * 0.5 - 15)*CGFloat(scale)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.sellBackV.frame = CGRect.init(x: (SCREEN_WIDTH * 0.5 - 15),
                                               y: 0.5,
                                               width: w,
                                               height: 24)
        }, completion: nil)
    }
}
