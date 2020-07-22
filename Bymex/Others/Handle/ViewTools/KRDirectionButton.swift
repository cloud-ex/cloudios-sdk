//
//  KRDirectionButton.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/24.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

enum DirectionActionType:Int {
    case none = 0
    case ascending = 1 // a<b
    case descending = 2 // a>b
}

enum HorizontalMargin {
    case marginLeft
    case marginCenter
    case marginRight
}

class KRDirectionPassThroughView :UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

class KRDirectionButton: UIControl {
    var container :KRDirectionPassThroughView  = KRDirectionPassThroughView.init()
    var titleLabel :UILabel = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
    var imgV = UIImageView.init(image: UIImage.themeImageNamed(imageName: "swap_triangle"))
    private var alighment :HorizontalMargin = .marginLeft
    var dirState :DirectionActionType = .none
    
    var lableRightmargin :Int = 4
    var triangleWidth :CGFloat = 15
    var isChecked:Bool = false
    //上下俩个三角的样式开关,排序的地方用到了
    var doubleTriangleStyle:Bool = false {
        didSet {
            if doubleTriangleStyle  {
                lableRightmargin = 5
            }
//            triangleView.doubleTriangleStyle = doubleTriangleStyle
            self.setNeedsDisplay()
        }
    }

    func checked(check:Bool){
        isChecked = check
//        triangleView.isChecked = check
    }
    
    func text(content:String) {
        titleLabel.text = content
        self.setNeedsDisplay()
    }
    
    func setAlighment(margin:HorizontalMargin) {
        switch margin {
        case .marginLeft:
            container.snp.remakeConstraints { (make) in
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.lessThanOrEqualToSuperview()
            }
            break
        case .marginRight:
            container.snp.remakeConstraints { (make) in
                make.width.lessThanOrEqualToSuperview()
                make.right.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            break
        case .marginCenter:
            container.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.lessThanOrEqualToSuperview()
            }
            break
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    func reset(idx:Int = 0) {
//        triangleView.isChecked = idx == 0 ? false : true
//        triangleView.highlightIdx = idx
    }
    
    func config(){
        self.alighment = .marginLeft
        self.addSubview(container)
        self.backgroundColor = UIColor.ThemeView.bg
        container.backgroundColor = UIColor.ThemeView.bg
        
        container.addSubview(titleLabel)
        container.addSubview(imgV)
        
        titleLabel.secondaryRegular()
        titleLabel.textColor = UIColor.ThemeLabel.colorMedium
        titleLabel.layoutIfNeeded()
        titleLabel.snp.makeConstraints { (make ) in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.equalTo(16)
        }
        
        imgV.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(lableRightmargin)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.equalTo(triangleWidth)
            make.height.equalTo(15)
            make.right.equalToSuperview()
        }
        self .setAlighment(margin: .marginLeft)
        
        NotificationCenter.default.addObserver(self, selector: #selector(normalStyle), name:  NSNotification.Name.init("EXSheetDissmissed"), object: nil)
    }
    
    @objc func normalStyle() {
        self.checked(check: false)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        click(check:!isChecked)
        return true
    }
    
    func click(check:Bool){
//        triangleView.isChecked = check
//        triangleView.setDoubleTriangleTapped()
//        dirState = DirectionActionType(rawValue: triangleView.highlightIdx)!
        isChecked = check
    }
}


class KRDirectionTriangle: UIView {
    
    var fillColor:UIColor = UIColor.ThemeView.bgIcon
    var highlight:UIColor = UIColor.ThemeLabel.colorLite
    var triangleWidth :CGFloat = 8
    var triangleHeight :CGFloat = 5
    
    var doubleTriangleStyleHeight :CGFloat = 4
    var doubleTriangleGap :CGFloat = 2
    
    var highlightIdx:Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }

    var doubleTriangleStyle:Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var isChecked:Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    func config(){
        self.backgroundColor = UIColor.clear
    }
    
    func setDoubleTriangleTapped() {
        highlightIdx += 1
        if highlightIdx > 2 {
            highlightIdx = 0
        }
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        fillColor .setFill()
        
        if doubleTriangleStyle {
            let center = CGPoint(x:(self.bounds.size.width - triangleWidth)+triangleWidth/2, y: (self.bounds.size.height)/2)
            self.drawDoubleTriangle(center: center)
        }else {
            let center = CGPoint(x:(self.bounds.size.width - triangleWidth)+triangleWidth/2, y: (self.bounds.size.height - triangleHeight)/2)
            
            self.drawTriangle(upSideDown: isChecked,center:center)
        }
    }
    
    
    func drawTriangle(upSideDown:Bool,center:CGPoint){
        fillColor.setFill()
        let trianglePath = self.trainglePathWithCenter(center: center, checked:upSideDown)
        trianglePath.fill()
    }
    
    func trainglePathWithCenter(center: CGPoint, checked: Bool) -> UIBezierPath {
        let path = UIBezierPath()
        if checked {
            let startX = center.x
            let startY = center.y
            path.move(to: CGPoint(x: startX, y: startY))
            path.addLine(to: CGPoint(x: startX - triangleWidth/2, y: startY+triangleHeight))
            path.addLine(to: CGPoint(x:startX + triangleWidth/2, y: startY+triangleHeight))
        }else {
            let startX = center.x - triangleWidth/2
            let startY = center.y
            path.move(to: CGPoint(x: startX, y: startY))
            path.addLine(to: CGPoint(x: startX + triangleWidth/2, y: startY+triangleHeight))
            path.addLine(to: CGPoint(x: startX + triangleWidth, y: startY))
        }
        path.close()
        return path
    }
    
    func drawDoubleTriangle(center:CGPoint,style:Int = 0) {
        
        let fullheight = doubleTriangleStyleHeight * 2 + doubleTriangleGap
        let path = UIBezierPath()
        let upTriangleX = center.x
        let upTriangleY = center.y - fullheight/2
        path.move(to: CGPoint(x: upTriangleX, y: upTriangleY))
        
        path.addLine(to: CGPoint(x: upTriangleX - triangleWidth/2, y: upTriangleY + doubleTriangleStyleHeight))
        path.addLine(to: CGPoint(x: upTriangleX + triangleWidth/2, y: upTriangleY + doubleTriangleStyleHeight))
        path.close()
        if highlightIdx == 1 {
            highlight.setFill()
        }else {
            fillColor.setFill()
        }
        path.fill()
        
        let downPath = UIBezierPath()
        let downTriangleX = center.x
        let downTriangleY = center.y + fullheight/2
        downPath.move(to: CGPoint(x: downTriangleX, y: downTriangleY))
        
        downPath.addLine(to: CGPoint(x: downTriangleX - triangleWidth/2, y: downTriangleY - doubleTriangleStyleHeight))
        downPath.addLine(to: CGPoint(x: downTriangleX + triangleWidth/2, y: downTriangleY - doubleTriangleStyleHeight))
        downPath.close()
        if highlightIdx == 2 {
            highlight.setFill()
        }else {
            fillColor.setFill()
        }
        downPath.fill()
    }
}
