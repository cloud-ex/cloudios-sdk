//
//  KRKLineDepthView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/8.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRKLineDepthView: KRBaseV {
    /// 价格阙值
    var thresholdPrice = 0.15
    
    /// 深度数据
    var depthDatas: [KRKDepthChartItem] = [KRKDepthChartItem]()
    
    /// 最大深度
    var maxAmount: Double = 0
    
    /// 精度
    var precision = "0.01"
    
    /// 最新价
    var pricevalue = "0"
    
    private lazy var titleView: UIStackView = UIStackView()
    
    /// 买盘
    private lazy var buyLabel: DepthViewTitleLabel = DepthViewTitleLabel(text: "买盘".localized(), font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .right)
    
    /// 卖盘
    private lazy var sellLabel: DepthViewTitleLabel = DepthViewTitleLabel(text: "卖盘".localized(), font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .right)
    
    /// 深度图
    private lazy var depthView: KRDepthChartView = {
        let view = KRDepthChartView()
        view.delegate = self
        view.style = EXKLineDepthStyle.depthStyle()
        view.yAxis.referenceStyle = .none
        return view
    }()
    
    /// 中间价格
//    private lazy var priceLabel: UILabel = UILabel(text: "--", font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .center)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buyLabel.fillcolor = UIColor.ThemekLine.up
        sellLabel.fillcolor =  UIColor.ThemekLine.down
        
        titleView.addSubViews([buyLabel, sellLabel])
        
        self.addSubViews([depthView, titleView])
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        titleView.snp_makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(14)
            make.width.equalTo(100)
        }
        buyLabel.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
        }
        sellLabel.snp.makeConstraints { (make) in
           make.right.centerY.equalToSuperview()
        }
        depthView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalTo(titleView.snp_bottom).offset(2)
        }
//        priceLabel.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-4)
//            make.height.equalTo(18)
//        }
    }
}

extension KRKLineDepthView {
    func updateView(_ lastestPrice: String) {
        self.handleDepthData(lastestPrice: lastestPrice)
        self.depthView.reloadData()
    }
    
    private func handleDepthData(lastestPrice: String) {
        
        let bids = SLPublicSwapInfo.sharedInstance()!.getBidOrderBooks(20) ?? []
        let asks = SLPublicSwapInfo.sharedInstance()!.getAskOrderBooks(20) ?? []
        let count = min(bids.count, asks.count)
        var sumBuysVol: Double = 0
        var sumSellsVol: Double = 0
        var bidDepthDatas: [KRKDepthChartItem] = [] // 买
        var askDepthDatas: [KRKDepthChartItem] = [] // 卖
        for i in 0..<count {
            let buyItem = KRKDepthChartItem()
            let sellItem = KRKDepthChartItem()
            let buyModel = bids[i]
            let sellModel = asks[i]
            buyItem.type = .bid
            buyItem.value = CGFloat(KRBasicParameter.handleDouble(buyModel.px ?? "0"))
            buyItem.amount = CGFloat(KRBasicParameter.handleDouble(buyModel.qty ?? "0"))
            sellItem.type = .ask
            sellItem.value = CGFloat(KRBasicParameter.handleDouble(sellModel.px ?? "0"))
            sellItem.amount = CGFloat(KRBasicParameter.handleDouble(sellModel.qty ?? "0"))
            
            sumBuysVol += KRBasicParameter.handleDouble(buyModel.qty ?? "0")
            sumSellsVol += KRBasicParameter.handleDouble(sellModel.qty ?? "0")
            
            bidDepthDatas.append(buyItem)
            askDepthDatas.append(sellItem)
        }
        
//        self.pricevalue = self.dealPrice(bidDepthDatas, askDepthDatas, lastestPrice: lastestPrice)
//        self.priceLabel.text = self.pricevalue
        self.depthDatas = bidDepthDatas + askDepthDatas
        self.maxAmount = max(sumBuysVol, sumSellsVol)
    }
    
    /// 处理最新成交价
    private func dealPrice(_ bidDepthDatas: [KRKDepthChartItem], _ askDepthDatas: [KRKDepthChartItem], lastestPrice: String) -> String {
        var priceValue = lastestPrice
        // 买单最大值
        var bidMax = "0"
        if bidDepthDatas.count > 0 {
            bidMax = "\(bidDepthDatas.last!.value)"
        }
        // 卖单最小值
        var askMin = "0"
        if askDepthDatas.count > 0 {
            askMin = "\(askDepthDatas.first!.value)"
        }
        if askMin == "0" && bidMax == "0" {
            return priceValue
        }
        
        // 如果最新成交价在买1和卖1中间 则返回最新成交价
        if (bidMax as NSString).ob_compare(lastestPrice) == .orderedAscending && (askMin as NSString).ob_compare(lastestPrice) == .orderedDescending {
            return priceValue
        } else if bidMax == "0"{//
            if (askMin as NSString).ob_compare(lastestPrice) == .orderedDescending {
                return priceValue
            } else {
                return askMin
            }
        } else if askMin == "0" {//
            if (bidMax as NSString).ob_compare(lastestPrice) == .orderedAscending {
                return priceValue
            } else {
                return bidMax
            }
        } else {//如果不在则买1+卖1除以2 算出最新成交价
            priceValue = ((bidMax as NSString).adding(askMin, decimals: 10) as NSString).dividing(by: "2", decimals: 10)
        }
        return priceValue
    }
}

// MARK: - CHKDepthChartDelegate
extension KRKLineDepthView: CHKDepthChartDelegate {
    /// 价格的小数位
    func depthChartOfDecimal(chart: KRDepthChartView) -> Int {
        return 2
    }
    
    /// 量的小数位
    func depthChartOfVolDecimal(chart: KRDepthChartView) -> Int {
        return 6
    }
    
    /// 图表的总条数
    /// 总数 = 买方 + 卖方
    /// - Parameter chart:
    /// - Returns:
    func numberOfPointsInDepthChart(chart: KRDepthChartView) -> Int {
        return self.depthDatas.count
    }
    
    /// 每个点显示的数值项
    ///
    /// - Parameters:
    ///   - chart:
    ///   - index:
    /// - Returns:
    func depthChart(chart: KRDepthChartView, valueForPointAtIndex index: Int) -> KRKDepthChartItem {
        return self.depthDatas[index]
    }
    
    /// y轴以基底值建立
    ///
    /// - Parameter depthChart:
    /// - Returns:
    func baseValueForYAxisInDepthChart(in depthChart: KRDepthChartView) -> Double {
        return 0
    }
    
    /// y轴以基底值建立后，每次段的增量
    ///
    /// - Parameter depthChart:
    /// - Returns:
    func incrementValueForYAxisInDepthChart(in depthChart: KRDepthChartView) -> Double {
        // 计算一个显示5个辅助线的友好效果
        let step = self.maxAmount * 1.1 / 5
        return Double(step)
    }
    
    /**
     获取图表Y轴的显示的内容
    
    - parameter chart:
    - parameter value:     计算得出的y值
    
    - returns:
    */
    func depthChart(chart: KRDepthChartView, labelOnYAxisForValue value: CGFloat) -> String {
        if value == 0 {
            return ""
        }
        let strValue = KRBasicParameter.dealVolumFormate("\(value)")
        return strValue
    }
}


class DepthViewTitleLabel :UILabel {
    
    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 12.0
    @IBInspectable var rightInset: CGFloat = 0.0
    private let squareWidth:CGFloat = 6
    
    var fillcolor = UIColor.clear{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath.init(rect: CGRect(x: 0, y:(self.height - squareWidth)/2, width: squareWidth, height: squareWidth))
        self.fillcolor.setFill()
        path.fill()
        super.drawText(in: rect)
    }
    
    override func drawText(in rect: CGRect) {
        let labelInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: labelInset))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}


class EXKLineDepthStyle: NSObject {
    
    static func depthStyle()->KRKLineChartStyle {
        let style = KRKLineChartStyle()
        //字体大小
        style.labelFont = UIFont.systemFont(ofSize: 10)
        //分区框线颜色
        style.lineColor = UIColor.ThemeView.seperator
        //背景颜色
        style.backgroundColor = UIColor.ThemeView.bg
        //文字颜色
        style.textColor = UIColor.ThemeLabel.colorMedium
        //整个图表的内边距
        style.padding = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        //Y轴是否内嵌式
        style.isInnerYAxis = true
        //Y轴显示在右边
        style.showYAxisLabel = .right
        //边界宽度
        style.borderWidth = (0, 0, 0.5, 0)
        
        style.bidChartOnDirection = .left
        style.showXAxisLabel = true
        style.enableTap = false
        //买方深度图层的颜色 UIColor(hex:0xAD6569) UIColor(hex:0x469777)
        style.bidColor = (UIColor.ThemekLine.up,UIColor.ThemekLine.up15, 1)
        //买方深度图层的颜色
        style.askColor = (UIColor.ThemekLine.down, UIColor.ThemekLine.down15, 1)
        
        return style
    }
}
