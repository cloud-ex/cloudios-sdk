//
//  KRKLineConfig.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/7/6.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

enum KRKLineTimeType: String {
    case k_timeline = "Line"
    case k_1min = "1min"
    case k_5min = "5min"
    case k_15min = "15min"
    case k_30min = "30min"
    case k_1hour = "1hour"
    case k_4hour = "4hour"
    case k_1day = "1day"
    case k_1week = "1week"
    case k_1mon = "1mon"
}

class KRKLineConfig: NSObject {
    /// 主图当前指标
    var currentMainName: KRSeriesName? = .ma
    
    /// 副图当前指标
    var currentSubName: KRSeriesName? = .macd
    
    var currentTimeType: KRKLineTimeType = .k_5min
}


// MARK: - 扩展样式
public extension KRKLineChartStyle {
    static var growdex: KRKLineChartStyle {
                    
        let style = KRKLineChartStyle()
        //字体大小
        style.labelFont = UIFont.systemFont(ofSize: 10)
        //分区框线颜色
        style.lineColor = UIColor(white: 0.2, alpha: 1)
        //选中价格显示的背景颜色
        style.selectedBGColor = UIColor(white: 0.4, alpha: 1)
        //文字颜色
        style.textColor = UIColor.ThemeLabel.colorDark //UIColor(white: 0.8, alpha: 1)
        //背景颜色
        style.backgroundColor = UIColor.ThemeView.bg
        //选中点的显示的文字颜色
        style.selectedTextColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        //整个图表的内边距
        style.padding = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        //整个图标边框线条
        style.borderWidth = (0, 0, 0.5, 0)
        //Y轴是否内嵌式
        style.isInnerYAxis = true
        //显示X轴坐标内容在哪个分区仲
        style.showXAxisOnSection = 2
        //Y轴显示在右边
        style.showYAxisLabel = .right
        //是否显示选中的内容
        style.showSelection = false
        style.showSelectBoardView = true
        //配置图表处理算法
        style.algorithms = [
            KRChartAlgorithm.ma(5),
            KRChartAlgorithm.ma(10),
            KRChartAlgorithm.ma(30),
            KRChartAlgorithm.ema(12),       //计算MACD，必须先计算到同周期的EMA
            KRChartAlgorithm.ema(26),       //计算MACD，必须先计算到同周期的EMA
            KRChartAlgorithm.macd(12, 26, 9),
            KRChartAlgorithm.kdj(9, 3, 3),
            KRChartAlgorithm.rsi(14)
        ]
        
        //分区点线样式
        //表示上涨的颜色
        let upcolor = (UIColor.ThemekLine.up, true)
        //表示下跌的颜色
        let downcolor = (UIColor.ThemekLine.down, true)
        let priceSection = KRSection()
        priceSection.backgroundColor = style.backgroundColor
        //分区上显示选中点的数据文字是否在分区外显示
        priceSection.titleShowOutSide = false
        //是否显示选中点的数据文字
        priceSection.showTitle = true
        //分区标题字体
        priceSection.labelFont = UIFont.systemFont(ofSize: 10)
        //分区的类型
        priceSection.valueType = .master
        //分区唯一键值
        priceSection.key = .price
        //是否隐藏分区
        priceSection.hidden = false
        //分区所占图表的比重，0代表不使用比重，采用固定高度
        priceSection.ratios = 4
        priceSection.logo = UIImage.init(named: "swap_kline_logo_night")
        //Y轴辅助线的样式，实线
        priceSection.yAxis.tickInterval = 4
        priceSection.yAxis.referenceStyle = .solid(color: UIColor.ThemeView.seperator)
        priceSection.xAxis.tickInterval = 5
        priceSection.xAxis.referenceStyle = .solid(color: UIColor.ThemeView.seperator)
        //分区内边距
        priceSection.padding = UIEdgeInsets(top: 48, left: 2, bottom: 0, right: 2)
        
        let maColor = [
            UIColor.extColorWithHex("#F4DB92"),
            UIColor.extColorWithHex("#1DCE8A"),
            UIColor.extColorWithHex("#9B72C7"),
        ]
        
        // 时分线
        let timelineSeries = KRSeries.getLightingTimeLine(
            color: UIColor.ThemeLabel.colorHighlight,
            section: priceSection,
            showGuide: false,
            lineWidth: 1)
        timelineSeries.hidden = true
        
        /// 蜡烛线
        let priceSeries = KRSeries.getCandlePrice(
            upStyle: upcolor,
            downStyle: downcolor,
            titleColor: UIColor(white: 0.9, alpha: 1),
            section: priceSection,
            showGuide: true,
            ultimateValueStyle: .line(UIColor(white: 0.9, alpha: 1)))

        //MA线
        let priceMASeries = KRSeries.getPriceMA(
            isEMA: false,
            num: [5,10,30],
            colors:maColor,
            section: priceSection)
        
        //EMA线
        let priceEMASeries = KRSeries.getPriceMA(
            isEMA: true,
            num: [5,10,30],
            colors: maColor,
            section: priceSection)
        
        priceEMASeries.hidden = true
        priceSection.series = [timelineSeries, priceSeries, priceMASeries, priceEMASeries]
        
        //交易量柱形线
        let volumeSection = KRSection()
        volumeSection.backgroundColor = style.backgroundColor
        //分区的类型
        volumeSection.valueType = .assistant
        //分区唯一键值
        volumeSection.key = .volume
        volumeSection.hidden = false
        volumeSection.showTitle = true
        volumeSection.labelFont = UIFont.systemFont(ofSize: 10)
        volumeSection.ratios = 1
        volumeSection.yAxis.referenceStyle = .none
        volumeSection.yAxis.tickInterval = 1
        volumeSection.xAxis.tickInterval = priceSection.xAxis.tickInterval
        volumeSection.xAxis.referenceStyle = priceSection.xAxis.referenceStyle
        volumeSection.padding = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        let volumeSeries = KRSeries.getDefaultVolume(upStyle: upcolor, downStyle: downcolor, section: volumeSection)
        let volumeMASeries = KRSeries.getVolumeMA(
            isEMA: false,
            num: [5,10,30],
            colors: maColor, section:
            volumeSection)
        
        let volumeEMASeries = KRSeries.getVolumeMA(
            isEMA: true,
            num: [5,10,30],
            colors: maColor,
            section: volumeSection)
        
        volumeEMASeries.hidden = true
        volumeSection.series = [volumeSeries, volumeMASeries, volumeEMASeries]
        
        let trendSection = KRSection()
        trendSection.backgroundColor = style.backgroundColor
        //分区的类型
        trendSection.valueType = .assistant
        //分区唯一键值
        trendSection.key = .analysis
        trendSection.hidden = false
        trendSection.showTitle = true
        trendSection.labelFont = UIFont.systemFont(ofSize: 10)
        trendSection.ratios = 1
        trendSection.paging = true
        trendSection.yAxis.referenceStyle = priceSection.yAxis.referenceStyle
        trendSection.yAxis.tickInterval = 1
        trendSection.xAxis.tickInterval = priceSection.xAxis.tickInterval
        trendSection.xAxis.referenceStyle = priceSection.xAxis.referenceStyle
        trendSection.padding = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        let kdjSeries = KRSeries.getKDJ(UIColor.extColorWithHex("F4DB92"),
                                        dc: UIColor.extColorWithHex("1DCE8A"),
                                        jc: UIColor.extColorWithHex("9B72C7"),
                                        section: trendSection)
        
        kdjSeries.title = "KDJ(14,1,3)"
        
        let macdSeries = KRSeries.getMACD(UIColor.extColorWithHex("F4DB92"),
                                          deac: UIColor.extColorWithHex("1DCE8A"),
                                          barc: UIColor.extColorWithHex("9B72C7"),
                                          upStyle: upcolor, downStyle: downcolor,
                                          section: trendSection)
        macdSeries.title = "MACD(12,26,9)"
        macdSeries.symmetrical = true
        trendSection.series = [
            macdSeries,
            kdjSeries,
        ]
        
        style.sections = [priceSection, volumeSection, trendSection]
        
        return style
    }
}

/**
 *  分时线样式模型
 */
class KRTimeLineModel: KRChartModel {
    
    /**
     画点线
     
     - parameter startIndex:     起始索引
     - parameter endIndex:       结束索引
     - parameter plotPaddingExt: 点与点之间间断所占点宽的比例
     */
    open override func drawSerie(_ startIndex: Int, endIndex: Int) -> CAShapeLayer {
        
        let serieLayer = CAShapeLayer()
        
        let modelLayer = CAShapeLayer()
        modelLayer.strokeColor = self.upStyle.color.cgColor
        modelLayer.fillColor = UIColor.clear.cgColor
        modelLayer.lineWidth = self.lineWidth
        modelLayer.lineCap = CAShapeLayerLineCap.round
        modelLayer.lineJoin = CAShapeLayerLineJoin.bevel
        
        //每个点的间隔宽度
        let plotWidth = self.plotWidth //(self.section.frame.size.width - self.section.padding.left - self.section.padding.right) / CGFloat(endIndex - startIndex)
        
        //使用bezierPath画线段
        let linePath = UIBezierPath()
        
        var maxValue: CGFloat = 0       //最大值的项
        var maxPoint: CGPoint?          //最大值所在坐标
        var minValue: CGFloat = CGFloat.greatestFiniteMagnitude       //最小值的项
        var minPoint: CGPoint?          //最小值所在坐标
        
        var isStartDraw = false
        
        var endX: CGFloat = 0
        
        //循环起始到终结
        for i in stride(from: startIndex, to: endIndex, by: 1) {
            //开始的点
            guard let value = self[i].value else {
                continue //无法计算的值不绘画
            }
            //开始X
            let ix = self.section.frame.origin.x + self.section.padding.left + CGFloat(i - startIndex) * plotWidth
            //结束X
            //            let iNx = self.section.frame.origin.x + self.section.padding.left + CGFloat(i + 1 - startIndex) * plotWidth
            
            //把具体的数值转为坐标系的y值
            let iys = self.section.getLocalY(value)
            //            let iye = self.section.getLocalY(valueNext!)
            let point = CGPoint(x: ix + plotWidth / 2, y: iys)
            //第一个点移动路径起始
            if !isStartDraw {
                linePath.move(to: point)
                isStartDraw = true
                endX = point.x
            } else {
                linePath.addLine(to: point)
                endX = ix + plotWidth
            }
            
            //记录最大值信息
            if value > maxValue {
                maxValue = value
                maxPoint = point
            }
            
            //记录最小值信息
            if value < minValue {
                minValue = value
                minPoint = point
            }
        }
    
        modelLayer.path = linePath.cgPath
        
        serieLayer.addSublayer(modelLayer)
        
        // 绘制填充区域
        let fillLayer = CAShapeLayer()
        linePath.addLine(to: CGPoint(x: endX, y: (minPoint?.y)!))
        linePath.addLine(to: CGPoint(x: 0, y: (minPoint?.y)!))

        fillLayer.path = linePath.cgPath
        fillLayer.frame = CGRect(x:self.section.padding.left, y: 0, width:self.section.frame.width, height: self.section.frame.height + self.section.padding.top)
        fillLayer.fillColor = UIColor.ThemeLabel.colorHighlight.withAlphaComponent(0.3).cgColor
        fillLayer.strokeColor = UIColor.clear.cgColor
        fillLayer.lineCap = CAShapeLayerLineCap.round
        fillLayer.lineJoin = CAShapeLayerLineJoin.round

        // 绘制渐变图层，然后使用填充区域的frame来截取
        let fillGradientLayer = CAGradientLayer()
        fillGradientLayer.frame = fillLayer.frame
        fillGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        fillGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        fillGradientLayer.colors = [
            UIColor.ThemeLabel.colorHighlight.withAlphaComponent(0.8).cgColor,
            UIColor.clear.cgColor
        ]
        fillGradientLayer.zPosition -= 1
        fillGradientLayer.mask = fillLayer
        serieLayer.addSublayer(fillGradientLayer)
        
        // 显示最大最小值
        if self.showMaxVal && maxValue != 0 {
            let highPrice = maxValue.kr_toString(maxF: section.decimal)
            let maxLayer = self.drawGuideValue(value: highPrice, section: section, point: maxPoint!, trend: KRChartItemTrend.up)
            
            serieLayer.addSublayer(maxLayer)
        }
        
        // 显示最大最小值
        if self.showMinVal && minValue != CGFloat.greatestFiniteMagnitude {
            let lowPrice = minValue.kr_toString(maxF: section.decimal)
            let minLayer = self.drawGuideValue(value: lowPrice, section: section, point: minPoint!, trend: KRChartItemTrend.down)
            
            serieLayer.addSublayer(minLayer)
        }
        
        return serieLayer
    }
}


extension KRChartModel {
    /// 生成一个分时线样式
    class func getTimeLine(_ color: UIColor, title: String, key: String) -> KRTimeLineModel {
        let model = KRTimeLineModel(upStyle: (color, true), downStyle: (color, true),
                                titleColor: color)
        model.title = title
        model.key = key
        return model
    }
}


extension KRSeries {
    /// 返回一个标准的时分价格系列样式
    ///
    /// - Parameters:
    ///   - color: 线段颜色
    ///   - section: 分区
    ///   - showGuide: 是否显示最大最小值
    /// - Returns: 线系列模型
    class func getLightingTimeLine(color: UIColor, section: KRSection, showGuide: Bool = false, lineWidth: CGFloat = 1) -> KRSeries {
        let series = KRSeries()
        series.key = KRSeriesKey.timeline
        let timeline = KRChartModel.getTimeLine(color, title: "price", key: "\(KRSeriesKey.timeline)_\(KRSeriesKey.timeline)")
        timeline.section = section
        timeline.useTitleColor = false
        timeline.showMaxVal = showGuide
        timeline.showMinVal = showGuide
        timeline.lineWidth = lineWidth
        series.chartModels = [timeline]
        return series
    }
}
