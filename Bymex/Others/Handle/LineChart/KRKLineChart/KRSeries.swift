//
//  KRSeries.swift
//  CHKLineChart
//
//  Created by Chance on 16/9/13.
//  Copyright © 2016年 Chance. All rights reserved.
//

import UIKit

/**
 系列对应的key值
 */
public struct KRSeriesKey {
    public static let candle = "Candle"
    public static let timeline = "Timeline"
    public static let volume = "Volume"
    public static let ma = "MA"
    public static let ema = "EMA"
    public static let kdj = "KDJ"
    public static let macd = "MACD"
    public static let boll = "BOLL"
    public static let sar = "SAR"
    public static let sam = "SAM"
    public static let rsi = "RSI"
}

public enum KRSeriesName: String {
    case candle = "Candle"
    case timeline = "Timeline"
    case volume = "Volume"
    case ma = "MA"
    case ema = "EMA"
    case kdj = "KDJ"
    case macd = "MACD"
    case boll = "BOLL"
    case sar = "SAR"
    case sam = "SAM"
    case rsi = "RSI"
}


/// 线段组
/// 在图表中一个要显示的“线段”都是以一个KRSeries进行封装。
/// 蜡烛图线段：包含一个蜡烛图点线模型（KRCandleModel）
/// 时分线段：包含一个线点线模型（KRLineModel）
/// 交易量线段：包含一个交易量点线模型（KRColumnModel）
/// MA/EMA线段：包含一个线点线模型（KRLineModel）
/// KDJ线段：包含3个线点线模型（KRLineModel），3个点线的数值根据KDJ指标算法计算所得
/// MACD线段：包含2个线点线模型（KRLineModel），1个条形点线模型
open class KRSeries: NSObject {
    
    open var key = ""
    open var title: String = ""
    open var chartModels = [KRChartModel]()          //每个系列包含多个点线模型
    open var hidden: Bool = false
    open var showTitle: Bool = true                                 //是否显示标题文本
    open var baseValueSticky = false                 //是否以固定基值显示最小或最大值，若超过范围
    open var symmetrical = false                     //是否以固定基值为中位数，对称显示最大最小值
    var seriesLayer: KRShapeLayer = KRShapeLayer()      //点线模型的绘图层
    /// 最后一个蜡烛图x+width
    var lastCandleLayerXAddW: CGFloat?

    public var algorithms: [KRChartAlgorithmProtocol] = [KRChartAlgorithmProtocol]()
    
    /// 清空图表的子图层
    func removeLayerView() {
        _ = self.seriesLayer.sublayers?.map { $0.removeFromSuperlayer() }
        self.seriesLayer.sublayers?.removeAll()
    }
}

// MARK: - 工厂方法
extension KRSeries {
    
    
    /// 返回一个标准的时分价格系列样式
    ///
    /// - Parameters:
    ///   - color: 线段颜色
    ///   - section: 分区
    ///   - showGuide: 是否显示最大最小值
    /// - Returns: 线系列模型
    public class func getTimelinePrice(color: UIColor, section: KRSection, showGuide: Bool = false, ultimateValueStyle: KRUltimateValueStyle = .none, lineWidth: CGFloat = 1) -> KRSeries {
        let series = KRSeries()
        series.key = KRSeriesKey.timeline
        let timeline = KRChartModel.getLine(color, title: NSLocalizedString("Price", comment: ""), key: "\(KRSeriesKey.timeline)_\(KRSeriesKey.timeline)")
        timeline.section = section
        timeline.useTitleColor = false
        timeline.ultimateValueStyle = ultimateValueStyle
        timeline.showMaxVal = showGuide
        timeline.showMinVal = showGuide
        timeline.lineWidth = lineWidth
        series.chartModels = [timeline]
        return series
    }
    
    /**
     返回一个标准的蜡烛柱价格系列样式
     */
    public class func getCandlePrice(upStyle: (color: UIColor, isSolid: Bool),
                                     downStyle: (color: UIColor, isSolid: Bool),
                                     titleColor: UIColor,
                                     section: KRSection,
                                     showGuide: Bool = false,
                                     ultimateValueStyle: KRUltimateValueStyle = .none) -> KRSeries {
        let series = KRSeries()
        series.key = KRSeriesKey.candle
        let candle = KRChartModel.getCandle(upStyle: upStyle, downStyle: downStyle, titleColor: titleColor)
        candle.section = section
        candle.useTitleColor = false
        candle.showMaxVal = showGuide
        candle.showMinVal = showGuide
        candle.ultimateValueStyle = ultimateValueStyle
        series.chartModels = [candle]
        return series
    }
    
    /**
     返回一个标准的交易量系列样式
     */
    public class func getDefaultVolume(upStyle: (color: UIColor, isSolid: Bool),
                                       downStyle: (color: UIColor, isSolid: Bool),
                                       section: KRSection) -> KRSeries {
        let series = KRSeries()
        series.key = KRSeriesKey.volume
        let vol = KRChartModel.getVolume(upStyle: upStyle, downStyle: downStyle)
        vol.section = section
        vol.useTitleColor = false
        series.chartModels = [vol]
        return series
    }
    
    
    /// 获取交易量的MA线
    ///
    public class func getVolumeMA(isEMA: Bool = false, num: [Int], colors: [UIColor], section: KRSection) -> KRSeries {
        let valueKey = KRSeriesKey.volume
        let series = self.getMA(isEMA: isEMA, num: num, colors: colors, valueKey: valueKey, section: section)
        return series
    }
    
    /**
     返回一个交易量+MA组合系列样式
     */
    public class func getVolumeWithMA(upStyle: (color: UIColor, isSolid: Bool),
                                       downStyle: (color: UIColor, isSolid: Bool),
                                       isEMA: Bool = false,
                                       num: [Int],
                                       colors: [UIColor],
                                       section: KRSection) -> KRSeries {
        let series = KRSeries()
        series.key = KRSeriesKey.volume
        let volumeSeries = KRSeries.getDefaultVolume(upStyle: upStyle, downStyle: downStyle, section: section)
        
        let volumeMASeries = KRSeries.getVolumeMA(
            isEMA: isEMA,
            num: num,
            colors: colors,
            section: section)
        
        series.chartModels.append(contentsOf: volumeSeries.chartModels)
        series.chartModels.append(contentsOf: volumeMASeries.chartModels)
        return series
    }
    
    /**
     返回一个交易量+SAM组合系列样式
     */
    public class func getVolumeWithSAM(upStyle: (color: UIColor, isSolid: Bool),
                                      downStyle: (color: UIColor, isSolid: Bool),
                                      num: Int,
                                      barStyle: (color: UIColor, isSolid: Bool),
                                      lineColor: UIColor,
                                      section: KRSection) -> KRSeries {
        let series = KRSeries()
        series.key = KRSeriesKey.sam
        let volumeSeries = KRSeries.getDefaultVolume(upStyle: upStyle, downStyle: downStyle, section: section)
        
        let volumeSAMSeries = KRSeries.getVolumeSAM(num: num, barStyle: barStyle, lineColor: lineColor, section: section)
        
        series.chartModels.append(contentsOf: volumeSeries.chartModels)
        series.chartModels.append(contentsOf: volumeSAMSeries.chartModels)
        return series
    }
    
    /// 获取交易量的MA线
    ///
    public class func getPriceMA(isEMA: Bool = false, num: [Int], colors: [UIColor], section: KRSection) -> KRSeries {
        let valueKey = KRSeriesKey.timeline
        let series = self.getMA(isEMA: isEMA, num: num, colors: colors, valueKey: valueKey, section: section)
        return series
    }
    
    /**
     返回一个移动平均线系列样式
     */
    public class func getMA(isEMA: Bool = false, num: [Int], colors: [UIColor], valueKey: String, section: KRSection) -> KRSeries {
        var key = ""
        if isEMA {
            key = KRSeriesKey.ema
        } else {
            key = KRSeriesKey.ma
        }
        
        let series = KRSeries()
        series.key = key
        for (i, n) in num.enumerated() {
            
            let ma = KRChartModel.getLine(colors[i], title: "\(key)\(n)", key: "\(key)_\(n)_\(valueKey)")
            ma.section = section
            series.chartModels.append(ma)
        }
        return series
    }
    
        
    /**
     返回一个移动平均线系列样式
     */
    public class func getRSI(num: [Int], colors: [UIColor], section: KRSection) -> KRSeries {
        let series = KRSeries()
        series.key = KRSeriesKey.rsi
        for (i, n) in num.enumerated() {
            let ma = KRChartModel.getLine(colors[i], title: "\(series.key)(\(n))", key: "\(series.key)_\(n)_\(KRSeriesKey.timeline)")
            ma.section = section
            series.chartModels.append(ma)
        }
        return series
    }
    
    /**
     返回一个KDJ系列样式
     */
    public class func getKDJ(_ kc: UIColor, dc: UIColor, jc: UIColor, section: KRSection) -> KRSeries {
        let series = KRSeries()
        series.key = KRSeriesKey.kdj
        let k = KRChartModel.getLine(kc, title: "K", key: "\(KRSeriesKey.kdj)_K")
        k.section = section
        let d = KRChartModel.getLine(dc, title: "D", key: "\(KRSeriesKey.kdj)_D")
        d.section = section
        let j = KRChartModel.getLine(jc, title: "J", key: "\(KRSeriesKey.kdj)_J")
        j.section = section
        series.chartModels = [k, d, j]
        return series
    }
    
    /**
     返回一个MACD系列样式
     */
    public class func getMACD(_ difc: UIColor,
                              deac: UIColor,
                              barc: UIColor,
                              upStyle: (color: UIColor, isSolid: Bool),
                              downStyle: (color: UIColor, isSolid: Bool),
                              section: KRSection) -> KRSeries {
        let series = KRSeries()
        series.key = KRSeriesKey.macd
        let dif = KRChartModel.getLine(difc, title: "DIF", key: "\(KRSeriesKey.macd)_DIF")
        dif.section = section
        let dea = KRChartModel.getLine(deac, title: "DEA", key: "\(KRSeriesKey.macd)_DEA")
        dea.section = section
        let bar = KRChartModel.getBar(upStyle: upStyle, downStyle: downStyle, titleColor: barc, title: "MACD", key: "\(KRSeriesKey.macd)_BAR")
        bar.section = section
        series.chartModels = [bar, dif, dea]
        return series
    }
    
    /**
     返回一个BOLL系列样式
     */
    public class func getBOLL(_ bollc: UIColor, ubc: UIColor, lbc: UIColor, section: KRSection) -> KRSeries {
        let series = KRSeries()
        series.key = KRSeriesKey.boll
        let boll = KRChartModel.getLine(bollc, title: "BOLL", key: "\(KRSeriesKey.boll)_BOLL")
        boll.section = section
        let ub = KRChartModel.getLine(ubc, title: "UB", key: "\(KRSeriesKey.boll)_UB")
        ub.section = section
        let lb = KRChartModel.getLine(lbc, title: "LB", key: "\(KRSeriesKey.boll)_LB")
        lb.section = section
        series.chartModels = [boll, ub, lb]
        return series
    }
    
    
    /**
     返回一个SAR系列样式
     */
    public class func getSAR(
        upStyle: (color: UIColor, isSolid: Bool),
        downStyle: (color: UIColor, isSolid: Bool),
        titleColor: UIColor,
        plotPaddingExt: CGFloat = 0.3,
        section: KRSection) -> KRSeries {
        
        let series = KRSeries()
        series.key = KRSeriesKey.sar
        let sar = KRChartModel.getRound(upStyle: upStyle, downStyle: downStyle, titleColor: titleColor, title: "SAR", plotPaddingExt: plotPaddingExt, key: "\(KRSeriesKey.sar)")
        sar.section = section
        sar.useTitleColor = true
        series.chartModels = [sar]
        return series
    }
    
    /// 获取交易量的SAM线
    ///
    public class func getVolumeSAM(num: Int,
                                   barStyle: (color: UIColor, isSolid: Bool),
                                   lineColor: UIColor,
                                   section: KRSection) -> KRSeries {
        let valueKey = KRSeriesKey.volume
        
        let series = KRSeries()
        series.key = KRSeriesKey.sam
        
        let sam = KRChartModel.getLine(lineColor, title: "\(KRSeriesKey.sam)\(num)", key: "\(KRSeriesKey.sam)_\(num)_\(valueKey)")
        sam.section = section
        sam.useTitleColor = true
        
        let vol = KRChartModel.getVolume(upStyle: barStyle, downStyle: barStyle, key: "\(KRSeriesKey.sam)_\(num)_\(valueKey)_BAR")
        vol.section = section
        
        series.chartModels = [sam, vol]
        
        return series
    }
    
    /// 获取主图价格的SAM线
    ///
    public class func getPriceSAM(num: Int,
                                  barStyle: (color: UIColor, isSolid: Bool),
                                  lineColor: UIColor,
                                  section: KRSection) -> KRSeries {
        let valueKey = KRSeriesKey.timeline
        
        let series = KRSeries()
        series.key = KRSeriesKey.sam
        
        let sam = KRChartModel.getLine(lineColor, title: "\(KRSeriesKey.sam)\(num)", key: "\(KRSeriesKey.sam)_\(num)_\(valueKey)")
        sam.section = section
        sam.useTitleColor = true
        
        let candle = KRChartModel.getCandle(upStyle: barStyle, downStyle: barStyle, titleColor: barStyle.color, key: "\(KRSeriesKey.sam)_\(num)_\(valueKey)_BAR")
        candle.drawShadow = false
        candle.section = section
        
        series.chartModels = [sam, candle]
        return series
    }
    
}
