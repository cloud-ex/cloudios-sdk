//
//  KRKLineView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/7.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class KRKLineView: UIView {

    var isFullScreen = false {
        didSet {
            if oldValue != isFullScreen {
                let sWidth = isFullScreen ? SCREEN_HEIGHT : SCREEN_WIDTH
                let xTickInterval = chartView.style.sections.first!.xAxis.tickInterval
                let scale: CGFloat = 1 - (1/CGFloat(xTickInterval))
                
                chartView.range = Int(sWidth*scale/chartView.plotWidth)
                chartView.maxRange = Int(sWidth/chartView.plotWidth)
                chartView.minRangeWhenRightSpace = Int(sWidth*scale/chartView.plotWidth)
            }
        }
    }
    
    var kLineDataArray: [KRChartItem] = []
    
    var chartXAxisPrevDay = ""
    
    /// 主图当前指标
    var currentMainName: KRSeriesName? = .ma
    
    /// 价格精度
    var px_unit: Int = 0
    var qty_unit: Int = 0
    
    var scrollEnabled = true {
        didSet {
            chartView.enablePan = scrollEnabled
            chartView.enableTap = scrollEnabled
            chartView.enablePinch = scrollEnabled
        }
    }
    
    private lazy var chartView: KRKLineChartView = {
        let chartView = KRKLineChartView(frame: .zero)
        chartView.delegate = self
        chartView.style = .growdex
        
        let sWidth = isFullScreen ? SCREEN_HEIGHT : SCREEN_WIDTH
        let xTickInterval = chartView.style.sections.first!.xAxis.tickInterval
        let scale: CGFloat = 1 - (1/CGFloat(xTickInterval))
        
        chartView.range = Int(sWidth*scale/chartView.plotWidth)
        chartView.maxRange = Int(sWidth/chartView.plotWidth)
        chartView.minRangeWhenRightSpace = Int(sWidth*scale/chartView.plotWidth)
        return chartView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        addSubViews([chartView])
    }
    
    private func initLayout() {
        chartView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    func changeKLineStyle(timeType: KRKLineTimeType, mainName: KRSeriesName?, subName: KRSeriesName?) {
        let style: KRKLineChartStyle = .growdex
        
        guard let priceSection = style.sections.first(where: { (section) -> Bool in
            return section.key == .price
        }) else { return }
        
        guard let trendSection = style.sections.first(where: { (section) -> Bool in
            return section.key == .analysis
        }) else { return }
        
        priceSection.series = []
        trendSection.series = []
        
        let upcolor = (UIColor.ThemekLine.up, true)
        let downcolor = (UIColor.ThemekLine.down, true)
        
        var algorithms = style.algorithms
        algorithms = [KRChartAlgorithm.ma(5),
                      KRChartAlgorithm.ma(10),
                      KRChartAlgorithm.ma(30)]
        
        let isTimeLine = (timeType == .k_timeline)
        
        if isTimeLine {
            priceSection.name = "timeline"
            // 时分线
            let timelineSeries = KRSeries.getLightingTimeLine(
                color: UIColor.ThemeLabel.colorHighlight,
                section: priceSection,
                showGuide: false,
                lineWidth: 1)
            priceSection.series.append(timelineSeries)
            algorithms.append(KRChartAlgorithm.timeline)
        } else {
            priceSection.name = ""
            /// 蜡烛线
            let candleSeries = KRSeries.getCandlePrice(
                upStyle: upcolor,
                downStyle: downcolor,
                titleColor: UIColor(white: 0.9, alpha: 1),
                section: priceSection,
                showGuide: true,
                ultimateValueStyle: .line(UIColor(white: 0.9, alpha: 1)))
            priceSection.series.append(candleSeries)
        }
        
        if !isTimeLine {
            switch mainName {
            case .ma:
                let maColor = [
                    UIColor.extColorWithHex("#F4DB92"),
                    UIColor.extColorWithHex("#1DCE8A"),
                    UIColor.extColorWithHex("#9B72C7"),
                ]
                let priceMASeries = KRSeries.getPriceMA(
                    isEMA: false,
                    num: [5,10,30],
                    colors:maColor,
                    section: priceSection)
                priceSection.series.append(priceMASeries)
            case .boll:
                algorithms.append(contentsOf: [KRChartAlgorithm.ma(20),
                                               // 计算BOLL，必须先计算到同周期的MA
                                               KRChartAlgorithm.boll(20, 2)])
                let priceBOLLSeries = KRSeries.getBOLL(
                    UIColor.extColorWithHex("#F4DB92"),
                    ubc: UIColor.extColorWithHex("#1DCE8A"),
                    lbc: UIColor.extColorWithHex("#9B72C7"),
                    section: priceSection)
                priceSection.series.append(priceBOLLSeries)
            default:
                break
            }
        }
        trendSection.hidden = false
        switch subName {
        case .macd:
            algorithms.append(contentsOf: [
            KRChartAlgorithm.ema(12),       //计算MACD，必须先计算到同周期的EMA
            KRChartAlgorithm.ema(26),       //计算MACD，必须先计算到同周期的EMA
            KRChartAlgorithm.macd(12, 26, 9)])
            let macdSeries = KRSeries.getMACD(UIColor.extColorWithHex("#F4DB92"),
                                              deac: UIColor.extColorWithHex("#1DCE8A"),
                                              barc: UIColor.extColorWithHex("#9B72C7"),
                                              upStyle: upcolor, downStyle: downcolor,
                                              section: trendSection)
            macdSeries.title = "MACD(12,26,9)"
            macdSeries.symmetrical = true
            
            trendSection.series.append(macdSeries)
        case .kdj:
            algorithms.append(KRChartAlgorithm.kdj(9, 3, 3))
            let kdjSeries = KRSeries.getKDJ(UIColor.extColorWithHex("#F4DB92"),
                                            dc: UIColor.extColorWithHex("#1DCE8A"),
                                            jc: UIColor.extColorWithHex("#9B72C7"),
                                            section: trendSection)
            kdjSeries.title = "KDJ(14,1,3)"
            trendSection.series.append(kdjSeries)
        case .rsi:
            algorithms.append(contentsOf: [KRChartAlgorithm.rsi(14)])
            let rsiSeries = KRSeries.getRSI(num: [14], colors: [UIColor.extColorWithHex("#F4DB92")], section: trendSection)
            trendSection.series.append(rsiSeries)
        default:
            trendSection.hidden = true
            break
        }
        style.algorithms = algorithms
        chartView.style = style
        chartView.reloadData()
    }
}

// MARK: - load data
extension KRKLineView {
    func reloadData(data: [KRChartItem]) {
        if data.count == 0 {
            return
        }
        self.kLineDataArray = data
        self.chartView.reloadData(toPosition: KRChartViewScrollPosition.end, resetData: true)
    }
    
    func appendData(data: [KRChartItem]) {
        let lastestTime = self.kLineDataArray.last?.time ?? 0
        for item in data {
            if item.time > lastestTime {
                if self.kLineDataArray.count > 0 {
                    self.kLineDataArray.append(item)
                    self.chartView.reloadData(toPosition: .none, resetData: false)
                }
            } else if item.time == lastestTime {
                self.kLineDataArray.removeLast()
                self.kLineDataArray.append(item)
                self.chartView.reloadData()
            }
        }
    }
}


extension KRKLineView : KRKLineChartDelegate {
    
    func numberOfPointsInKLineChart(chart: KRKLineChartView) -> Int {
        return kLineDataArray.count
    }
    
    func kLineChart(chart: KRKLineChartView, valueForPointAtIndex index: Int) -> KRChartItem {
        if let item = self.kLineDataArray[safe: index] {
            return item
        } else {
            return KRChartItem()
        }
    }
    
    func kLineChart(chart: KRKLineChartView, labelOnYAxisForValue value: CGFloat, atIndex index: Int, section: KRSection) -> String {
        let strValue = value.kr_toString(maxF: self.px_unit)
        return strValue
    }
    
    func kLineChart(chart: KRKLineChartView, labelOnXAxisForIndex index: Int) -> String {
        guard index < kLineDataArray.count else {
            return ""
        }
        let data = kLineDataArray[index]
        let timestamp = data.time
        let dayText = Date.kr_getTimeByStamp(timestamp, format: "MM-dd")
        let timeText = Date.kr_getTimeByStamp(timestamp, format: "HH:mm")
        var text = ""
        //跨日，显示日期
        if dayText != self.chartXAxisPrevDay && index > 0 {
            text = dayText
        } else {
            text = timeText
        }
        self.chartXAxisPrevDay = dayText
        return text
    }
    
    func kLineChart(chart: KRKLineChartView, viewOfYAxis yAxis: UILabel, viewOfXAxis: UILabel) {
        viewOfXAxis.height = 12
        viewOfXAxis.backgroundColor = UIColor.ThemeLabel.colorHighlight
        viewOfXAxis.layer.cornerRadius = 2
        viewOfXAxis.layer.masksToBounds = true
        viewOfXAxis.textColor = .black
    }

    func updateRangesInKLineChart(in chart: KRKLineChartView) -> KRRangeModle {
        let xTickInterval = chartView.style.sections.first!.xAxis.tickInterval
        let scale: CGFloat = 1 - (1/CGFloat(xTickInterval))
        
        let rangeModel = KRRangeModle()
        rangeModel.range = Int(ceil(chartView.bounds.width*scale/chartView.plotWidth))
        rangeModel.maxRange = Int(ceil(chartView.bounds.width/chartView.plotWidth))
        rangeModel.minRangeWhenRightSpace = Int(ceil(chartView.bounds.width*scale/chartView.plotWidth))
        
        return rangeModel
    }
    
    /// 自定义分区图标题
    func kLineChart(chart: KRKLineChartView, titleForHeaderInSection section: KRSection, index: Int, item: KRChartItem) -> NSAttributedString? {
        var start = 0
        let titleString = NSMutableAttributedString()
        var key = ""
        switch section.index {
        case 0:
            key = currentMainName?.rawValue ?? ""
        default:
            if (section.selectedIndex < section.series.count) {
                key = section.series[section.selectedIndex].key
            } else {
                key = ""
            }
        }
        
        //获取该线段的标题值及颜色，可以继续自定义
        guard let attributes = section.getTitleAttributesByIndex(index, seriesKey: key) else {
            return nil
        }
        
        //合并为完整字符串
        for (title, color) in attributes {
            titleString.append(NSAttributedString(string: title))
            let range = NSMakeRange(start, title.kr_length)
            let newAttribute = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 9)]
            titleString.addAttributes(newAttribute, range: range)
            start += title.kr_length
        }
        
        return titleString
    }
}


