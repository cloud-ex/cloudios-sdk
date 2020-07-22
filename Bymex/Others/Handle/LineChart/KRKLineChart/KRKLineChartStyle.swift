//
//  KRKLineChartStyle.swift
//  CHKLineChart
//
//  Created by 麦志泉 on 16/9/19.
//  Copyright © 2016年 Chance. All rights reserved.
//

import Foundation
import UIKit


/// 最大最小值显示风格
///
/// - none: 不显示
/// - arrow: 箭头风格
/// - circle: 空心圆风格
/// - tag: 标签风格
public enum KRUltimateValueStyle {
    
    case none
    case arrow(UIColor)
    case circle(UIColor, Bool)
    case tag(UIColor)
    case line(UIColor)
}

// MARK: - 图表样式配置类
open class KRKLineChartStyle {
    
    /// 分区样式配置
    open var sections: [KRSection] = [KRSection]()
    
    /// 要处理的算法
    open var algorithms: [KRChartAlgorithmProtocol] = [KRChartAlgorithmProtocol]()
    
    
    /// 背景颜色
    open var backgroundColor: UIColor = UIColor.white
    
    /// 显示边线上左下有
    open var borderWidth: (top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) = (0.5, 0.5, 0.5, 0.5)
    
    /**
     边距
     
     - returns:
     */
    open var padding: UIEdgeInsets!
    
    //字体大小
    open var labelFont: UIFont!
    
    //线条颜色
    open var lineColor: UIColor = UIColor.clear
    
    //文字颜色
    open var textColor: UIColor = UIColor.clear
    
    //选中点的显示的框背景颜色
    open var selectedBGColor: UIColor = UIColor.clear
    open var selectedBGBorderColor: UIColor = UIColor.clear

    //选中点的显示的横线背景色
    open var verticalLineViewBGColor: UIColor = UIColor(white: 0.4, alpha: 1)
    open var horizontalLineViewBGColor: UIColor = UIColor(white: 0.4, alpha: 1)
    open var sightViewBGColor: UIColor = UIColor.white
    
    //选中点的显示的文字颜色
    open var selectedTextColor: UIColor = UIColor.clear
    
    //显示y的位置，默认右边
    open var showYAxisLabel = KRYAxisShowPosition.right
    
    /// 是否把y坐标内嵌到图表仲
    open var isInnerYAxis: Bool = false
    
    //是否可缩放
    open var enablePinch: Bool = true
    //是否可滑动
    open var enablePan: Bool = true
    //是否可点选
    open var enableTap: Bool = true
    //是否可长按
    open var enableLongPress = true
    
    /// 是否显示选中的内容
    open var showSelection: Bool = true
    
    /// 是否显示选中的详细弹框数据
    open var showSelectBoardView = false
    
    /// 把X坐标内容显示到哪个索引分区上，默认为-1，表示最后一个，如果用户设置溢出的数值，也以最后一个
    open var showXAxisOnSection: Int = -1
    
    /// 是否显示X轴标签
    open var showXAxisLabel: Bool = true
    
    /// 是否显示所有内容
    open var isShowAll: Bool = false
    
    
    /// 买方深度图层颜色
    open var bidColor: (stroke: UIColor, fill: UIColor, lineWidth: CGFloat) = (.white, .white, 1)
    
    /// 卖方深度图层颜色
    open var askColor: (stroke: UIColor, fill: UIColor, lineWidth: CGFloat) = (.white, .white, 1)
    
    /// 买单居右
    open var bidChartOnDirection:KRKDepthChartOnDirection = .right
    
    public init() {
        
    }
}

// MARK: - 扩展样式
public extension KRKLineChartStyle {
    
    //实现一个最基本的样式，开发者可以自由扩展配置样式
    public static var base: KRKLineChartStyle {
        let style = KRKLineChartStyle()
        style.labelFont = UIFont.systemFont(ofSize: 10)
        style.lineColor = UIColor(white: 0.2, alpha: 1)
        style.textColor = UIColor(white: 0.8, alpha: 1)
        style.selectedBGColor = UIColor(white: 0.4, alpha: 1)
        style.selectedTextColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        style.padding = UIEdgeInsets(top: 32, left: 8, bottom: 4, right: 0)
        style.backgroundColor = UIColor.kr_hex(0x1D1C1C)
        style.showYAxisLabel = .right
        
        //配置图表处理算法
        style.algorithms = [
            KRChartAlgorithm.timeline,
            KRChartAlgorithm.sar(4, 0.02, 0.2), //默认周期4，最小加速0.02，最大加速0.2
            KRChartAlgorithm.ma(5),
            KRChartAlgorithm.ma(10),
            KRChartAlgorithm.ma(20),        //计算BOLL，必须先计算到同周期的MA
            KRChartAlgorithm.ma(30),
            KRChartAlgorithm.ema(5),
            KRChartAlgorithm.ema(10),
            KRChartAlgorithm.ema(12),       //计算MACD，必须先计算到同周期的EMA
            KRChartAlgorithm.ema(26),       //计算MACD，必须先计算到同周期的EMA
            KRChartAlgorithm.ema(30),
            KRChartAlgorithm.boll(20, 2),
            KRChartAlgorithm.macd(12, 26, 9),
            KRChartAlgorithm.kdj(9, 3, 3),
        ]
        
        //分区点线样式
        let upcolor = (UIColor.kr_hex(0xF80D1F), true)
        let downcolor = (UIColor.kr_hex(0x1E932B), true)
        let priceSection = KRSection()
        priceSection.backgroundColor = style.backgroundColor
        priceSection.titleShowOutSide = true
        priceSection.valueType = .master
        priceSection.key = .master
        priceSection.hidden = false
        priceSection.ratios = 3
        priceSection.padding = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        
        /// 时分线
        let timelineSeries = KRSeries.getTimelinePrice(
            color: UIColor.kr_hex(0xAE475C),
            section: priceSection,
            showGuide: true,
            ultimateValueStyle: .circle(UIColor.kr_hex(0xAE475C), true),
            lineWidth: 2)
        
        timelineSeries.hidden = true
        
        /// 蜡烛线
        let priceSeries = KRSeries.getCandlePrice(
            upStyle: upcolor,
            downStyle: downcolor,
            titleColor: UIColor(white: 0.8, alpha: 1),
            section: priceSection,
            showGuide: true,
            ultimateValueStyle: .arrow(UIColor(white: 0.8, alpha: 1)))
        
        priceSeries.showTitle = true
        
        priceSeries.chartModels.first?.ultimateValueStyle = .arrow(UIColor(white: 0.8, alpha: 1))
        
        let priceMASeries = KRSeries.getPriceMA(
            isEMA: false,
            num: [5,10,30],
            colors: [
                UIColor.kr_hex(0xDDDDDD),
                UIColor.kr_hex(0xF9EE30),
                UIColor.kr_hex(0xF600FF),
                ],
            section: priceSection)
        priceMASeries.hidden = false
        
        let priceEMASeries = KRSeries.getPriceMA(
            isEMA: true,
            num: [5,10,30],
            colors: [
                UIColor.kr_hex(0xDDDDDD),
                UIColor.kr_hex(0xF9EE30),
                UIColor.kr_hex(0xF600FF),
                ],
            section: priceSection)
        
        priceEMASeries.hidden = true
        
        let priceBOLLSeries = KRSeries.getBOLL(
            UIColor.kr_hex(0xDDDDDD),
            ubc: UIColor.kr_hex(0xF9EE30),
            lbc: UIColor.kr_hex(0xF600FF),
            section: priceSection)
        
        priceBOLLSeries.hidden = true
        
        let priceSARSeries = KRSeries.getSAR(
            upStyle: upcolor,
            downStyle: downcolor,
            titleColor: UIColor.kr_hex(0xDDDDDD),
            section: priceSection)
        
        priceSARSeries.hidden = true
        
        priceSection.series = [
            timelineSeries,
            priceSeries,
            priceMASeries,
            priceEMASeries,
            priceBOLLSeries,
            priceSARSeries
        ]
        
        let volumeSection = KRSection()
        volumeSection.backgroundColor = style.backgroundColor
        volumeSection.valueType = .assistant
        volumeSection.key = .volume
        volumeSection.hidden = false
        volumeSection.ratios = 1
        volumeSection.yAxis.tickInterval = 4
        volumeSection.padding = UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0)
        let volumeSeries = KRSeries.getDefaultVolume(upStyle: upcolor, downStyle: downcolor, section: volumeSection)
        
        let volumeMASeries = KRSeries.getVolumeMA(
            isEMA: false,
            num: [5,10,30],
            colors: [
                UIColor.kr_hex(0xDDDDDD),
                UIColor.kr_hex(0xF9EE30),
                UIColor.kr_hex(0xF600FF),
                ],
            section: volumeSection)
        
        let volumeEMASeries = KRSeries.getVolumeMA(
            isEMA: true,
            num: [5,10,30],
            colors: [
                UIColor.kr_hex(0xDDDDDD),
                UIColor.kr_hex(0xF9EE30),
                UIColor.kr_hex(0xF600FF),
                ],
            section: volumeSection)
        
        volumeEMASeries.hidden = true
        volumeSection.series = [volumeSeries, volumeMASeries, volumeEMASeries]
        
        let trendSection = KRSection()
        trendSection.backgroundColor = style.backgroundColor
        trendSection.valueType = .assistant
        trendSection.key = .analysis
        trendSection.hidden = false
        trendSection.ratios = 1
        trendSection.paging = true
        trendSection.yAxis.tickInterval = 4
        trendSection.padding = UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0)
        let kdjSeries = KRSeries.getKDJ(
            UIColor.kr_hex(0xDDDDDD),
            dc: UIColor.kr_hex(0xF9EE30),
            jc: UIColor.kr_hex(0xF600FF),
            section: trendSection)
        kdjSeries.title = "KDJ(14,1,3)"
        
        let macdSeries = KRSeries.getMACD(
            UIColor.kr_hex(0xDDDDDD),
            deac: UIColor.kr_hex(0xF9EE30),
            barc: UIColor.kr_hex(0xF600FF),
            upStyle: upcolor, downStyle: downcolor,
            section: trendSection)
        macdSeries.title = "MACD(12,26,9)"
        macdSeries.symmetrical = true
        trendSection.series = [
            kdjSeries,
            macdSeries]
        
        style.sections = [priceSection, volumeSection, trendSection]
        
        
        return style
    }
}
