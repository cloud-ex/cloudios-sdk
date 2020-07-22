//
//  KRSection.swift
//  CHKLineChart
//
//  Created by Chance on 16/8/31.
//  Copyright © 2016年 Chance. All rights reserved.
//

import UIKit

/// 分区图类型
public enum KRSectionValueType {
    case master              //主图
    case assistant             //副图

}


/**
 *  K线的区域
 */
open class KRSection: NSObject {
    
    public enum Key: String {
        case none = ""
        case price = "price"
        case volume = "volume"
        case analysis = "analysis"
        case master = "master"
    }
    
    //MARK: - 成员变量
    /// 涨的颜色
    open var upColor: UIColor = UIColor.green
    /// 跌的颜色
    open var downColor: UIColor = UIColor.red
    /// 文字颜色
    open var titleColor: UIColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    open var labelFont = UIFont.systemFont(ofSize: 10)
    open var valueType: KRSectionValueType = KRSectionValueType.master
    open var key: Key = .none
    /// 区域的名称
    open var name: String = ""
    open var hidden: Bool = false
    open var paging: Bool = false
    open var selectedIndex: Int = 0
    open var padding: UIEdgeInsets = UIEdgeInsets.zero
    /// 每个分区包含多组系列，每个系列包含多个点线模型
    open var series = [KRSeries]()
    open var tickInterval: Int = 0
    /// 标题
    open var title: String = ""
    /// 标题是否显示在外面
    open var titleShowOutSide: Bool = false
    /// 是否显示标题文本
    open var showTitle: Bool = true
    /// 小数位的长度
    open var decimal: Int = 2
    /// 所占区域比例
    open var ratios: Int = 0
    /// 固定高度，为0则通过ratio计算高度
    open var fixHeight: CGFloat = 0
    open var frame: CGRect = CGRect.zero
    /// Y轴参数
    open var yAxis: KRYAxis = KRYAxis()
    /// X轴参数
    open var xAxis: KRXAxis = KRXAxis()
    open var backgroundColor: UIColor = UIColor.black
    open var index: Int = 0
    open var enableGradient = false
    open var logo: UIImage?
    open var gradientColor: [UIColor]? {
        didSet {
            self.gradientLayer.colors = gradientColor?.map({ (elem) -> CGColor in
                return elem.cgColor
            })
        }
    }
    /// 显示标题内容的层
    var titleLayer: KRShapeLayer = KRShapeLayer()
    /// 分区的绘图层
    var sectionLayer: KRShapeLayer = KRShapeLayer()
    /// 用户自定义的View
    var titleView: UIView?
    /// 渐变背景
    var gradientLayer = CAGradientLayer()
    /// logo
    var logoLayer = CALayer()
    /// 最后一个蜡烛图x+width
    var lastCandleLayerXAddW: CGFloat?
    
    /// 初始化分区
    ///
    /// - Parameter valueType: 分区类型
    convenience init(valueType: KRSectionValueType, key: Key) {
        self.init()
        self.valueType = valueType
        self.key = key
    }
    
    
    
}


// MARK: - 内部方法
extension KRSection {
    
    /// 清空图表的子图层
    func removeLayerView() {
        _ = self.sectionLayer.sublayers?.map { $0.removeFromSuperlayer() }
        self.sectionLayer.sublayers?.removeAll()
        
        _ = self.titleLayer.sublayers?.map { $0.removeFromSuperlayer() }
        self.titleLayer.sublayers?.removeAll()
    }
    
    
    /**
     建立Y轴左边对象，由起始位到结束位
     */
    func buildYAxisPerModel(_ model: KRChartModel, startIndex: Int, endIndex: Int) {
        let datas = model.datas
        if datas.count == 0 {
            return  //没有数据返回
        }
        
        if !self.yAxis.isUsed {
            self.yAxis.decimal = self.decimal
            
            self.yAxis.max = 0
            self.yAxis.min = CGFloat.greatestFiniteMagnitude
            self.yAxis.isUsed = true
        }
        
        
        for i in stride(from: startIndex, to: endIndex, by: 1) {
            
            
            let item = datas[i]
            
            switch model {
            case is KRCandleModel:
                
                let high = item.highPrice
                let low = item.lowPrice
                
                //判断数据集合的每个价格，把最大值和最少设置到y轴对象中
                if high > self.yAxis.max {
                    self.yAxis.max = high
                }
                if low < self.yAxis.min {
                    self.yAxis.min = low
                }
                
            case is KRLineModel, is KRBarModel, is KRTimeLineModel:
                
                let value = model[i].value
                
                if value == nil{
                    continue  //无法计算的值不绘画
                }
                
                //判断数据集合的每个价格，把最大值和最少设置到y轴对象中
                if value! > self.yAxis.max {
                    self.yAxis.max = value!
                }
                if value! < self.yAxis.min {
                    self.yAxis.min = value!
                }
                
            case is KRColumnModel:
                
                let value = item.vol
                
                //判断数据集合的每个价格，把最大值和最少设置到y轴对象中
                if value > self.yAxis.max {
                    self.yAxis.max = value
                }
                if value < self.yAxis.min {
                    self.yAxis.min = value
                }
            default:break
                
            }
            
            
            
        }
    }
    
    /// 绘制header上的标题信息
    ///
    /// - Parameter title: 标题内容
    func drawTitleForHeader(title: NSAttributedString) {
        
        guard self.showTitle else {
            return
        }
        
        _ = self.titleLayer.sublayers?.map { $0.removeFromSuperlayer() }
        self.titleLayer.sublayers?.removeAll()
        
        var yPos: CGFloat = 0
        var containerWidth: CGFloat = 0
        let textSize = title.string.kr_sizeWithConstrained(self.labelFont, constraintRect: CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        if titleShowOutSide {
            yPos = self.frame.origin.y - textSize.height - 4
            containerWidth = self.frame.width
        } else {
            yPos = self.frame.origin.y + 2
            containerWidth = self.frame.width - self.padding.left - self.padding.right
        }
        
        let startX = self.frame.origin.x + self.padding.left + 2
        
        let point = CGPoint(x: startX, y: yPos)
        
        let titleText = KRTextLayer()
        titleText.frame = CGRect(origin: point, size: CGSize(width: containerWidth, height: textSize.height + 20))
        titleText.string = title
        titleText.fontSize = self.labelFont.pointSize
        //        titleText.foregroundColor =  self.titleColor.cgColor
        titleText.backgroundColor = UIColor.clear.cgColor
        titleText.contentsScale = UIScreen.main.scale
        titleText.isWrapped = true
        
        self.titleLayer.addSublayer(titleText)
        
    }
    
    func drawGradientBG(_ superLayer: CALayer) {
        
        guard enableGradient else {
            gradientLayer.removeFromSuperlayer()
            return
        }
        //sectionLayer.addSublayer(gradientLayer)
        //sectionLayer.insertSublayer(gradientLayer, at: 0)
        superLayer.addSublayer(gradientLayer)
        
        gradientLayer.locations = [0, 1]
        gradientLayer.colors = gradientColor?.map({ (elem) -> CGColor in
            return elem.cgColor
        })
        gradientLayer.frame = self.frame//CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    func drawLogo(_ superLayer: CALayer) {
        
        guard logo != nil else {
            logoLayer.removeFromSuperlayer()
            return
        }
        superLayer.addSublayer(logoLayer)
        
        logoLayer.contents = logo!.cgImage
        logoLayer.frame = CGRect.init(origin: CGPoint.init(x: 12, y: self.frame.height-logo!.size.height+6),
                                          size: logo!.size)
    }
    
    //切换到下一个系列显示
    func nextPage() {
        if(self.selectedIndex < self.series.count - 1){
            self.selectedIndex += 1
        } else {
            self.selectedIndex = 0
        }
    }
}


// MARK: - 公开方法
extension KRSection {
    
    
    /// 建立Y轴的数值范围
    ///
    /// - Parameters:
    ///   - startIndex: 计算范围的开始数据点
    ///   - endIndex: 计算范围的结束数据点
    ///   - datas: 数据集合
    public func buildYAxis(startIndex: Int, endIndex: Int, datas: [KRChartItem]) {
        self.yAxis.isUsed = false
        var baseValueSticky = false
        var symmetrical = false
        if self.paging {     //如果分页，计算当前选中的系列作为坐标系的数据源
            //建立分区每条线的坐标系
            let serie = self.series[self.selectedIndex]
            baseValueSticky = serie.baseValueSticky
            symmetrical = serie.symmetrical
            for serieModel in serie.chartModels {
                serieModel.datas = datas
                self.buildYAxisPerModel(serieModel,
                                        startIndex: startIndex,
                                        endIndex: endIndex)
            }
        } else {
            for serie in self.series {   //不分页，计算所有系列作为坐标系的数据源
                
                //隐藏的不计算
                if serie.hidden {
                    continue
                }
                
                baseValueSticky = serie.baseValueSticky
                symmetrical = serie.symmetrical
                for serieModel in serie.chartModels {
                    serieModel.datas = datas
                    self.buildYAxisPerModel(serieModel,
                                            startIndex: startIndex,
                                            endIndex: endIndex)
                }
            }
        }
        
        //让边界溢出些，这样图表不会占满屏幕
        //        self.yAxis.max += (self.yAxis.max - self.yAxis.min) * self.yAxis.ext
        //        self.yAxis.min -= (self.yAxis.max - self.yAxis.min) * self.yAxis.ext
        
        if !baseValueSticky {        //不使用固定基值
            if self.yAxis.max >= 0 && self.yAxis.min >= 0 {
                self.yAxis.baseValue = self.yAxis.min
            } else if self.yAxis.max < 0 && self.yAxis.min < 0 {
                self.yAxis.baseValue = self.yAxis.max
            } else {
                self.yAxis.baseValue = 0
            }
        } else {                                //使用固定基值
            if self.yAxis.baseValue < self.yAxis.min {
                self.yAxis.min = self.yAxis.baseValue
            }
            
            if self.yAxis.baseValue > self.yAxis.max {
                self.yAxis.max = self.yAxis.baseValue
            }
        }
        
        //如果使用水平对称显示y轴，基本基值计算上下的边界值
        if symmetrical {
            if self.yAxis.baseValue > self.yAxis.max {
                self.yAxis.max = self.yAxis.baseValue + (self.yAxis.baseValue - self.yAxis.min)
            } else if self.yAxis.baseValue < self.yAxis.min {
                self.yAxis.min =  self.yAxis.baseValue - (self.yAxis.max - self.yAxis.baseValue)
            } else {
                if (self.yAxis.max - self.yAxis.baseValue) > (self.yAxis.baseValue - self.yAxis.min) {
                    self.yAxis.min = self.yAxis.baseValue - (self.yAxis.max - self.yAxis.baseValue)
                } else {
                    self.yAxis.max = self.yAxis.baseValue + (self.yAxis.baseValue - self.yAxis.min)
                }
            }
        }
    }
    
    
    /**
     获取y轴上标签数值对应在坐标系中的y值
     
     - parameter val: 标签值
     
     - returns: 坐标系中实际的y值
     */
    public func getLocalY(_ val: CGFloat) -> CGFloat {
        let max = self.yAxis.max
        let min = self.yAxis.min
        
        if (max == min) {
            return 0
        }
        
        /*
         计算公式：
         y轴有值的区间高度 = 整个分区高度-（paddingTop+paddingBottom）
         当前y值所在位置的比例 =（当前值 - y最小值）/（y最大值 - y最小值）
         当前y值的实际的相对y轴有值的区间的高度 = 当前y值所在位置的比例 * y轴有值的区间高度
         当前y值的实际坐标 = 分区高度 + 分区y坐标 - paddingBottom - 当前y值的实际的相对y轴有值的区间的高度
         */
        let baseY = self.frame.size.height + self.frame.origin.y - self.padding.bottom - (self.frame.size.height - self.padding.top - self.padding.bottom) * (val - min) / (max - min)
        //        NSLog("baseY(val) = \(baseY)(\(val))")
        //        NSLog("fra.size.height = \(self.frame.size.height)");
        //        NSLog("max = \(max)");
        //        NSLog("min = \(min)");
        return baseY
    }
    
    /**
     获取坐标系中y坐标对应的y值
     
     - parameter y:
     
     - returns:
     */
    public func getRawValue(_ y: CGFloat) -> CGFloat {
        let max = self.yAxis.max
        let min = self.yAxis.min
        
        let ymax = self.getLocalY(self.yAxis.min)       //y最大值对应y轴上的最高点，则最小值
        let ymin = self.getLocalY(self.yAxis.max)       //y最小值对应y轴上的最低点，则最大值
        
        if (max == min) {
            return 0
        }
        
        let value = (y - ymax) / (ymin - ymax) * (max - min) + min
        
        return value
    }
    
    /**
     画分区的标题
     */
    public func drawTitle(_ chartSelectedIndex: Int) {
        
        guard self.showTitle else {
            return
        }
        
        if chartSelectedIndex == -1 {
            return       //没有数据返回
        }
        
        if self.paging {     //如果分页
            let series = self.series[self.selectedIndex]
            if let attributes = self.getTitleAttributesByIndex(chartSelectedIndex, series: series) {
                self.setHeader(titles: attributes)
            }
            
            
        } else {
            var titleAttr = [(title: String, color: UIColor)]()
            for serie in self.series {   //不分页
                if let attributes = self.getTitleAttributesByIndex(chartSelectedIndex, series: serie) {
                    titleAttr.append(contentsOf: attributes)
                }
                
                
            }
            
            self.setHeader(titles: titleAttr)
        }
        
        
    }
    
    
    /// 添加用户自定义的View层到主页面
    ///
    /// - Parameter view: 用户自定义view
    public func addCustomView(_ view: UIView, inView mainView: UIView) {
        
        if self.titleView !== view {
            
            //移除以前的view
            self.titleView?.removeFromSuperview()
            self.titleView = nil
            
            var yPos: CGFloat = 0
            var containerWidth: CGFloat = 0
            if titleShowOutSide {
                yPos = self.frame.origin.y - self.padding.top
                containerWidth = self.frame.width
            } else {
                yPos = self.frame.origin.y
                containerWidth = self.frame.width - self.padding.left - self.padding.right
            }
            
            let startX = self.frame.origin.x + self.padding.left
            containerWidth = self.frame.width - self.padding.left - self.padding.right
            
            var frame = view.frame
            frame.origin.x = startX
            frame.origin.y = yPos
            frame.size.width = containerWidth
            view.frame = frame
            
            self.titleView = view
            mainView.addSubview(view)
            
        }
        
        mainView.bringSubviewToFront(self.titleView!)
        
    }
    
    /// 设置分区头部文本显示内容
    ///
    /// - Parameters:
    ///   - titles: 文本内容及颜色元组
    public func setHeader(titles: [(title: String, color: UIColor)])  {
        
        var start = 0
        let titleString = NSMutableAttributedString()
        for (title, color) in titles {
            titleString.append(NSAttributedString(string: title))
            let range = NSMakeRange(start, title.kr_length)
            //            NSLog("title = \(title)")
            //            NSLog("range = \(range)")
            let colorAttribute = [NSAttributedString.Key.foregroundColor: color]
            titleString.addAttributes(colorAttribute, range: range)
            start += title.kr_length
        }
        
        self.drawTitleForHeader(title: titleString)
    }
    
    /// 根据seriesKey获取线段的数值标题
    ///
    public func getTitleAttributesByIndex(_ chartSelectedIndex: Int, seriesKey: String) -> [(title: String, color: UIColor)]? {
        guard let series = self.getSeries(key: seriesKey) else {
            return nil
        }
        return self.getTitleAttributesByIndex(chartSelectedIndex, series: series)
    }
    
    /// 获取标题属性元组
    ///
    /// - Parameters:
    ///   - chartSelectedIndex: 图表选中位置
    ///   - series: 线
    /// - Returns: 标题属性
    public func getTitleAttributesByIndex(_ chartSelectedIndex: Int, series: KRSeries) -> [(title: String, color: UIColor)]? {
        
        if series.hidden {
            return nil
        }
        
        guard series.showTitle else {
            return nil
        }
        
        if chartSelectedIndex == -1 {
            return nil      //没有数据返回
        }
        
        var titleAttr = [(title: String, color: UIColor)]()
        
        if !series.title.isEmpty {
            let seriesTitle = series.title + "  "
            
            titleAttr.append((title: seriesTitle, color: self.titleColor))
            
        }
        
        for model in series.chartModels {
            var title = ""
            var textColor: UIColor
            if chartSelectedIndex < model.datas.count {
                let item = model[chartSelectedIndex]
                switch model {
                case is KRCandleModel:
                    
                    if model.key != KRSeriesKey.candle {
                        continue  //不限蜡烛柱
                    }
                    
                    //振幅
                    var amplitude: CGFloat = 0
                    if item.openPrice > 0 {
                        amplitude = (item.closePrice - item.openPrice) / item.openPrice * 100
                    }
                    
                    
                    title += NSLocalizedString("O", comment: "") + ": " +
                        item.openPrice.kr_toString(maxF: self.decimal) + "  "   //开始
                    title += NSLocalizedString("H", comment: "") + ": " +
                        item.highPrice.kr_toString(maxF: self.decimal) + "  "   //最高
                    title += NSLocalizedString("L", comment: "") + ": " +
                        item.lowPrice.kr_toString(maxF: self.decimal) + "  "    //最低
                    title += NSLocalizedString("C", comment: "") + ": " +
                        item.closePrice.kr_toString(maxF: self.decimal) + "  "  //收市
                    title += NSLocalizedString("R", comment: "") + ": " +
                        amplitude.kr_toString(maxF: self.decimal) + "%   "        //振幅
                    
                case is KRColumnModel:
                    
                    if model.key != KRSeriesKey.volume {
                        continue  //不是量线
                    }
                    
                    title += model.title + ": " + item.vol.kr_toString(maxF: self.decimal) + "  "
                default:
                    if item.value != nil {
                        title += model.title + ": " + item.value!.kr_toString(maxF: self.decimal) + "  "
                    }  else {
                        title += model.title + ": --  "
                    }
                    
                }
                if model.useTitleColor {    //是否用标题颜色
                    textColor = model.titleColor
                } else {
                    switch item.trend {
                    case .up, .equal:
                        textColor = model.upStyle.color
                    case .down:
                        textColor = model.downStyle.color
                    }
                }
                
                titleAttr.append((title: title, color: textColor))
            }
            
        }
        
        return titleAttr
    }
    
    
    /// 查找线段对象
    ///
    /// - Parameter key: 线段唯一key
    /// - Returns: 线段对象
    public func getSeries(key: String) -> KRSeries? {
        var series: KRSeries?
        for s in self.series {
            if s.key == key {
                series = s
                break
            }
        }
        return series
    }
    
    
    /// 删除线段
    ///
    /// - Parameter key: 线段主键名
    public func removeSeries(key: String) {
        for (index, s) in self.series.enumerated() {
            if s.key == key {
                self.series.remove(at: index)
                break
            }
        }
    }
}
