//
//  KRKLineLatestPriceIndicator.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/20.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class KRKLineLatestPriceIndicator: UIView {
    
    var dashColor = UIColor.gray {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var lineWidth: CGFloat = 1 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var lineDashPattern = [NSNumber(value: 5), NSNumber(value: 2)] {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var frameHeight: CGFloat = 24
    
    lazy var btn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.ThemeLabel.colorHighlight
        btn.setTitle("0.0000 >", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.layer.cornerRadius = 2
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = dashColor.cgColor
        
        return btn
    }()
    
    /// 上一次X的位置
    private var lastSelfX: CGFloat?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //绘画虚线
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.frame = self.bounds
        shapeLayer.strokeColor = dashColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = lineDashPattern
        
        //路径
        let path = CGMutablePath()
        let p1 = CGPoint.init(x: 0, y: (bounds.height-lineWidth)/2)
        let p2 = CGPoint.init(x: bounds.width, y: p1.y)
        path.move(to: p1)
        path.addLines(between: [p1, p2])
        
        //设置路径
        shapeLayer.path = path
        
        //添加到self.layer
        self.layer.addSublayer(shapeLayer)
        
        self.addSubview(btn)
    }
    
    
    /// 重绘
    /// - Parameters:
    ///   - frame: 预计显示的frame，注意：右边适配时，如果按钮显示不下，按钮会向左偏移，frame的x和width会重新计算和布局，就不会显示传递的frame
    ///   - latestPrice: 最新价格
    ///   - isRightestShow: 是否最右边蜡烛图显示在屏幕上
    ///   - lastCandleLayerXAddW: 最右边蜡烛图的右边框X
    func reDraw(_ frame: CGRect, latestPrice: String, isRightestShow: Bool = false, lastCandleLayerXAddW: CGFloat = 0) {
        // 按钮标题计算的宽度
        let textWidth = latestPrice.kr_sizeWithConstrained(btn.titleLabel!.font!).width
        let showBtnOnRight = isRightestShow && textWidth < frame.width-lastCandleLayerXAddW
        
        var selfFrame = frame
        if showBtnOnRight {//最新价格需要显示在最右边
            frameHeight = 12
            btn.setTitle(latestPrice, for: .normal)
            selfFrame.origin.x = lastCandleLayerXAddW
            selfFrame.size.width = frame.width-lastCandleLayerXAddW
            btn.frame = CGRect.init(x: selfFrame.size.width-textWidth, y: (height-frameHeight) / 2, width: textWidth, height: frameHeight)
        }else {//最新价格显示右边偏移一定距离，并且按钮可点击
            frameHeight = 24
            self.btn.setTitle(latestPrice+" ▷", for: .normal)
            var btnWidth = (btn.currentTitle?.kr_sizeWithConstrained(btn.titleLabel!.font!).width ?? 0) + 12
            btnWidth = max(btnWidth, 64)
            btn.frame = CGRect.init(x: bounds.width-btnWidth-70, y: (height-frameHeight) / 2, width: btnWidth, height: frameHeight)
        }
        
        btn.layer.borderWidth = showBtnOnRight ? 0 : 1
        btn.layer.cornerRadius = showBtnOnRight ? 2 : frameHeight/2
        
        UIView.animate(withDuration: self.lastSelfX == selfFrame.origin.x ? 0.35 : 0) {
            self.frame = selfFrame
            self.layoutIfNeeded()
            self.setNeedsDisplay()
        }
        self.lastSelfX = selfFrame.origin.x
    }

}
