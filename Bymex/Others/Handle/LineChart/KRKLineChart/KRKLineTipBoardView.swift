//
//  KRKLineTipBoardView.swift
//  Growdex
//
//  Created by zhiyong yin on 2019/10/31.
//  Copyright © 2019 YUXI. All rights reserved.
//

import UIKit

//获取屏幕宽高
fileprivate let KScreenWidth = UIScreen.main.bounds.width
fileprivate let KScreenHeight = UIScreen.main.bounds.height
fileprivate let kScreen_Bounds = UIScreen.main.bounds
fileprivate let SafeAreaTopHeight: CGFloat = ((KScreenHeight >= 812.0) && (UIDevice.current.model == "iPhone") ? 24 : 0)
fileprivate let SafeAreaBottomHeight: CGFloat = ((KScreenHeight >= 812.0) && (UIDevice.current.model == "iPhone")  ? 34 : 0)

func RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, a: CGFloat = 1) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
func RGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    return RGBA(r, g, b)
}

class KRKLineTipBoardView: UIView {
    
    struct UIConfigure {
        
        static let `default` = UIConfigure()
        
        var baseTextColor = UIColor.ThemeLabel.colorMedium //RGB(193, 197, 222)
        
        /**
        *  填充色
        */
        var strockColor: UIColor = UIColor.ThemeTab.bg //RGB(193, 197, 222)
        
        /**
        *  边框颜色
        */
        var borderColor: UIColor = UIColor.ThemeView.seperator
        
        /**
        *  边框颜色
        */
        var borderWidth: CGFloat = 1
        
        /**
         *  圆角弧度
         */
        var radius: CGFloat = 4

        /**
         *  字体， 默认系统字体，大小 10
         */
        var font: UIFont = UIFont.systemFont(ofSize: 10)
        
        /**
         *  隐藏时间, 默认3s
         */
        var hideDuration: CGFloat = 2.5
        
        
        /**
         *  开盘价颜色
         */
        var openColor = UIColor.ThemeLabel.colorMedium

        /**
         *  收盘价颜色
         */
        var closeColor = UIColor.ThemeLabel.colorMedium

        /**
         *  最高价颜色
         */
        var highColor = UIColor.ThemeLabel.colorMedium

        /**
         *  最低价颜色
         */
        var lowColor = UIColor.ThemeLabel.colorMedium

        /**
         *  时间
         */
        var timeColor = UIColor.ThemeLabel.colorMedium
        /**
         *  涨
         */
        var riseColor = UIColor.ThemekLine.up
        
        /**
         *  跌
         */
        var fallColor = UIColor.ThemekLine.down

        /**
         *  成交量
         */
        var volColor = UIColor.ThemeLabel.colorMedium
    }
    
    struct Datas {
        /**
         *  开盘价
         */
        var open = "--"

        /**
         *  收盘价
         */
        var close = "--"

        /**
         *  最高价
         */
        var high = "--"

        /**
         *  最低价
         */
        var low = "--"

        /**
         *  时间
         */
        var time = "--"
        /**
         *  涨跌额
         */
        var riseDrop = "--"

        /**
         *  涨跌幅
         */
        var percent = "--"

        /**
         *  成交量
         */
        var vol = "--"
    }
    
    var uiConfigure: UIConfigure = .default
    var datas = Datas()
    
    
    private var tipPoint: CGPoint!

    /**
     *  画背景图
     */
    func drawInContext() {
        let context = UIGraphicsGetCurrentContext()
            /*画矩形*/
        context?.stroke(CGRect.init(x: 0.5, y: 0.5, width: bounds.width, height: bounds.height))//画方框
        //context?.fill(CGRect.init(x: 0.5, y: 0.5, width: bounds.width, height: bounds.height))//填充框
        //矩形，并填弃颜色
        context?.setLineWidth(1.0)//线的宽度
        //context?.setFillColor(self.fillColor.CGColor)//填充颜色
        //context?.setStrokeColor(RGB(193, 197, 222).CGColor)//线框颜色
        context?.drawPath(using: .fillStroke)//绘画路径
    }
    
    func show(tipPoint: CGPoint, klineViewWidth: CGFloat) {
        self.isHidden = false
        self.layer.removeAllAnimations()
        
        guard self.tipPoint != tipPoint else {
            return
        }
        
        var frame = self.frame

        if (tipPoint.x > klineViewWidth/2.0) {
            frame.origin.x = 8
        }else {
            frame.origin.x = klineViewWidth-self.width-8
        }
        
        frame.origin.y = tipPoint.y
        self.tipPoint = tipPoint
        self.frame = frame
        self.setNeedsDisplay()
    }

    func hide() {
        let animation = CATransition()
        animation.type = .fade
        animation.duration = CFTimeInterval(self.uiConfigure.hideDuration)
        animation.startProgress = 0.0
        animation.endProgress = 0.35
        self.layer.add(animation, forKey: nil)
        self.isHidden = true
    }
    
    //MARK: - life cycle
    init() {
        super.init(frame: CGRect.zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup() {
        self.layer.borderWidth = self.uiConfigure.borderWidth
        self.layer.borderColor = self.uiConfigure.borderColor.cgColor
    }
    
    override func draw(_ rect: CGRect) {
        //画字
        let titles = ["时间".localized(),
                      "开".localized(),
                      "高".localized(),
                      "低".localized(),
                      "收".localized(),
                      "涨跌额".localized(),
                      "涨跌幅".localized(),
                      "成交量".localized()]
        let padding: CGFloat = 5
        
        for i in 0..<titles.count {
            let attString = NSAttributedString.init(string: titles[i], attributes: [NSAttributedString.Key.font : self.uiConfigure.font, NSAttributedString.Key.foregroundColor : UIColor.ThemeLabel.colorMedium])
            let originY = 5 + CGFloat(i) * (padding + self.uiConfigure.font.lineHeight)
            let originX: CGFloat = 5
            attString.draw(in: CGRect.init(x: originX, y: originY, width: self.frame.size.width, height: self.uiConfigure.font.lineHeight))
        }
        
        var riseFallColor: UIColor!
        let closeNum = NSDecimalNumber.init(string: self.datas.close)
        let openNum = NSDecimalNumber.init(string: self.datas.open)
        let changeNum = closeNum.subtracting(openNum)
        guard openNum.doubleValue != 0 else {
            return
        }
        var percentDouble: Double = 0
        if openNum.doubleValue != 0 {
            percentDouble = changeNum.dividing(by: openNum).multiplying(by: NSDecimalNumber.init(value: 100)).doubleValue
        }
        
        if (changeNum.doubleValue < 0) {//跌
            riseFallColor = self.uiConfigure.fallColor
            self.datas.riseDrop = changeNum.stringValue.deleteFloatAllZero()
            self.datas.percent = String.init(format: "%.2f%%", percentDouble)
        }else{
            riseFallColor = self.uiConfigure.riseColor
            self.datas.riseDrop = "+\(changeNum.stringValue)".deleteFloatAllZero()
            self.datas.percent = String.init(format: "+%.2f%%", percentDouble)
        }
        
        if openNum.doubleValue == 0 {
            self.datas.percent = "--"
        }
        
        let contents: [String] = [self.datas.time,
                                  self.datas.open,
                                  self.datas.high,
                                  self.datas.low,
                                  self.datas.close,
                                  self.datas.riseDrop,
                                  self.datas.percent,
                                  self.datas.vol]
        let contentColor: [UIColor] = [self.uiConfigure.timeColor,
                                       self.uiConfigure.openColor,
                                       self.uiConfigure.highColor,
                                       self.uiConfigure.lowColor,
                                       self.uiConfigure.closeColor,
                                       riseFallColor,
                                       riseFallColor,
                                       self.uiConfigure.volColor];

        for i in 0..<contents.count {
            let attString = NSAttributedString.init(string: contents[i], attributes: [NSAttributedString.Key.font : self.uiConfigure.font, NSAttributedString.Key.foregroundColor : contentColor[i]])
            let originY: CGFloat = 5 + CGFloat(i) * (padding + self.uiConfigure.font.lineHeight);
            let titleW: CGFloat = (contents[i] as NSString).size(withAttributes: [NSAttributedString.Key.font : self.uiConfigure.font]).width
            attString.draw(in: CGRect.init(x: self.width-titleW-padding, y: originY, width: self.width, height: self.uiConfigure.font.lineHeight))
        }
    }
}

extension String {
    func deleteFloatAllZero() -> String {
        let arrStr = self.components(separatedBy: ".")
        guard arrStr.count == 2 else {
            return self
        }
        var str1 = arrStr[1]
        while str1.hasSuffix("0") {
            str1 = str1.subString(start: 0, length: str1.length-1)
        }
        return str1.length > 0 ? "\(arrStr[0]).\(str1)" : arrStr[0]
    }
}
