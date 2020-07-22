//
//  ExButton.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import UIKit

enum ButtonStyles {
    static func buttonImage(
        color: UIColor,
        shadowHeight: CGFloat,
        shadowColor: UIColor,
        cornerRadius: CGFloat) -> UIImage {
        
        return buttonImage(color: color, shadowHeight: shadowHeight, shadowColor: shadowColor, cornerRadius: cornerRadius, frontImageOffset: 0)
    }
    
    static func highlightedButtonImage(
        color: UIColor,
        shadowHeight: CGFloat,
        shadowColor: UIColor,
        cornerRadius: CGFloat,
        buttonPressDepth: Double) -> UIImage {
        
        return buttonImage(color: color, shadowHeight: shadowHeight, shadowColor: shadowColor, cornerRadius: cornerRadius, frontImageOffset: shadowHeight * CGFloat(buttonPressDepth))
    }
    
    static func buttonImage(
        color: UIColor,
        shadowHeight: CGFloat,
        shadowColor: UIColor,
        cornerRadius: CGFloat,
        frontImageOffset: CGFloat) -> UIImage {
        
        // Create foreground and background images
        let width = max(1, cornerRadius * 2 + shadowHeight)
        let height = max(1, cornerRadius * 2 + shadowHeight)
        let size = CGSize(width: width, height: height)
        
        let frontImage = image(color: color, size: size, cornerRadius: cornerRadius)
        var backImage: UIImage? = nil
        if shadowHeight != 0 {
            backImage = image(color: shadowColor, size: size, cornerRadius: cornerRadius)
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height + shadowHeight)
        
        // Draw background image then foreground image
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        backImage?.draw(at: CGPoint(x: 0, y: shadowHeight))
        frontImage.draw(at: CGPoint(x: 0, y: frontImageOffset))
        let nonResizableImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Create resizable image
        let capInsets = UIEdgeInsets(top: cornerRadius + frontImageOffset, left: cornerRadius, bottom: cornerRadius + shadowHeight - frontImageOffset, right: cornerRadius)
        let resizableImage = nonResizableImage?.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
        
        return resizableImage ?? UIImage()
    }
    
    static func image(color: UIColor, size: CGSize, cornerRadius: CGFloat) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let nonRoundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Clip it with a bezier path
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: cornerRadius
            ).addClip()
        nonRoundedImage?.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}

@IBDesignable
class EXButton: UIButton,LoadingAnimation {
    
    var activityIndicator: LoadingView  { get {return self.loading}}
    var loading = LoadingView.init(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
    var storedTitleColor:UIColor?

    //默认高亮按钮,须使用customtype
    public enum EXColors {
        public static var color = UIColor.ThemeLabel.colorHighlight
        public static var highlightedColor =  color.overlayWhite()
        public static var selectedColor =  color.overlayWhite()
        public static var disabledColor = UIColor.ThemeBtn.disable
        public static var cornerRadius: CGFloat = 1.5
    }
    
    public var color: UIColor = UIColor.ThemeLabel.colorHighlight {
        didSet {
            self.updateBackgroundImages()
            setNeedsDisplay()
        }
    }
    
    public var highlightedColor: UIColor = UIColor.ThemeLabel.colorHighlight.overlayWhite() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var selectedColor: UIColor = UIColor.ThemeLabel.colorHighlight {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var disabledColor: UIColor = UIColor.ThemeBtn.disable {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 4 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public func clearColors() {
        self.color = UIColor.clear
        self.highlightedColor = UIColor.clear
        self.disabledColor = UIColor.clear
        self.selectedColor = UIColor.clear
    }
    
    @IBInspectable
    public var ibcolor :String = "" {
        didSet {
            if !ibcolor.isEmpty {
                color = UIColor.themeColor(keyPath: ibcolor)
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable
    public var ibHighlight:String = "" {
        didSet {
            highlightedColor = UIColor.themeColor(keyPath: ibHighlight)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var ibselected :String = "" {
        didSet {
            if !ibselected.isEmpty {
                selectedColor = UIColor.themeColor(keyPath: ibselected)
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable
    public var ibdisable :String = "" {
        didSet {
            if !ibdisable.isEmpty {
                disabledColor = UIColor.themeColor(keyPath: ibdisable)
                setNeedsDisplay()
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setNeedsDisplay()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
        setNeedsDisplay()
    }
    
    override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        if self.storedTitleColor == nil {
            self.storedTitleColor = color
        }
        super.setTitleColor(color, for: state)
    }
    
    override open func draw(_ rect: CGRect) {
        updateBackgroundImages()
        super.draw(rect)
    }
    
    fileprivate func configure() {
        setFont()
        adjustsImageWhenDisabled = false
        adjustsImageWhenHighlighted = false
    }
    
    fileprivate func updateBackgroundImages() {
        
        let normalImage = ButtonStyles.buttonImage(color: color, shadowHeight: 0, shadowColor: .clear, cornerRadius: cornerRadius)
        let highlightedImage = ButtonStyles.highlightedButtonImage(color: highlightedColor, shadowHeight: 0, shadowColor: .clear, cornerRadius: cornerRadius, buttonPressDepth: 0)
        let selectedImage = ButtonStyles.buttonImage(color: selectedColor, shadowHeight: 0, shadowColor: .clear, cornerRadius: cornerRadius)
        let disabledImage = ButtonStyles.buttonImage(color: disabledColor, shadowHeight: 0, shadowColor: .clear, cornerRadius: cornerRadius)
        
        setBackgroundImage(normalImage, for: .normal)
        setBackgroundImage(highlightedImage, for: .highlighted)
        setBackgroundImage(selectedImage, for: .selected)
        setBackgroundImage(disabledImage, for: .disabled)
    }
    
    func setFont(_ font : UIFont = UIFont.ThemeFont.HeadBold){
        self.titleLabel?.font = font
    }
    
    func isAnimating() {
        self.setTitleColor(UIColor.clear, for: .normal)
    }
    
    func animationStopped() {
        if let titlec = self.storedTitleColor {
            self.setTitleColor(titlec, for: .normal)
        }
    }
}
