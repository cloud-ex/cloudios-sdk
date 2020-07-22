//
//  KRLabelEx.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import YYText

extension UILabel {
    
    func h1Medium() { self.font = UIFont.ThemeFont.H1Medium }
    
    func h2Medium() { self.font = UIFont.ThemeFont.H2Medium }
    
    func headBold() { self.font = UIFont.ThemeFont.HeadBold }
    
    func headRegular() { self.font = UIFont.ThemeFont.HeadRegular }
    
    func bodyBold() { self.font = UIFont.ThemeFont.BodyBold }
    
    func bodyRegular() { self.font = UIFont.ThemeFont.BodyRegular }
    
    func secondaryBold() { self.font = UIFont.ThemeFont.SecondaryBold }
    
    func secondaryRegular() { self.font = UIFont.ThemeFont.SecondaryRegular }
    
    func minimumBold() { self.font = UIFont.ThemeFont.MinimumBold }
    
    func minimumRegular() { self.font = UIFont.ThemeFont.MinimumRegular }
    
}

extension UILabel {

    func setLabelMap(_ name : String , leftColor : UIColor = UIColor.ThemeLabel.colorLite , leftFont : UIFont =  UIFont().themeHNBoldFont(size: 16) , rightColor : UIColor = UIColor.ThemeLabel.colorMedium , rightFont : UIFont = UIFont.ThemeFont.SecondaryRegular, separated : String = "/") {
        let array = name.components(separatedBy: separated)
        if array.count >= 2{
            self.setLabelMapWith(array[0], leftColor: leftColor, leftFont: leftFont, rightStr: array[1], rightColor: rightColor, rightFont: rightFont)
        }else{
            self.setLabelMapWith(name, leftColor: leftColor, leftFont: leftFont, rightStr: "", rightColor: rightColor, rightFont: rightFont)
        }
    }
    
    func setLabelMapWith(_ leftStr : String ,leftColor : UIColor = UIColor.ThemeLabel.colorLite ,leftFont : UIFont = UIFont.ThemeFont.HeadBold, rightStr : String , rightColor : UIColor = UIColor.ThemeLabel.colorMedium,rightFont : UIFont = UIFont.ThemeFont.SecondaryRegular){
        var att = NSMutableAttributedString().add(string: leftStr, attrDic: [NSAttributedString.Key.foregroundColor : leftColor,NSAttributedString.Key.font : leftFont])
        if rightStr != ""{
            att = att.add(string: "\(rightStr)", attrDic: [NSAttributedString.Key.foregroundColor : rightColor,NSAttributedString.Key.font : rightFont])
        }
        self.attributedText = att
    }
    
    /**
      设置颜色 字体大小
      
      - parameter textColor: 字体颜色
      - parameter fontSize:  字体大小
      */
     public final func extSetTextColor(_ textColor : UIColor , fontSize : CGFloat){
         
         self.textColor = textColor;
         self.font = UIFont.systemFont(ofSize: fontSize)
         
     }
     
     /**
      设置颜色 字体大小
      
      - parameter textColor: 字体颜色
      - parameter fontSize:  字体大小
      - parameter textAlignment : 文字对齐方式
      */
     public final func extSetTextColor(_ textColor : UIColor , fontSize : CGFloat , textAlignment : NSTextAlignment , isBold : Bool = false , numberOfLines : Int = 1){
         
         self.textColor = textColor;
         if isBold{
             self.font = UIFont.boldSystemFont(ofSize: fontSize)
         }else{
             self.font = UIFont.systemFont(ofSize: fontSize)
         }
         
         self.numberOfLines = numberOfLines
         self.textAlignment = textAlignment
     }
     
     
     /**
      设置内容 颜色 字体大小
      
      - parameter text:      内容
      - parameter textColor: 字体颜色
      - parameter fontSize:  字体大小
      */
     public final func extSetText(_ text : String , textColor : UIColor , fontSize : CGFloat){
         
         self.extSetTextColor(textColor, fontSize: fontSize)
         self.text = text;
         
     }
     
     /**
      设置内容 颜色 字体大小 对齐方式
      
      - parameter text:      内容
      - parameter textColor: 字体颜色
      - parameter fontSize:  字体大小
      - parameter textAlignment:  对齐方式
      */
     public final func extSetText(_ text : String , textColor : UIColor , fontSize : CGFloat , textAlignment : NSTextAlignment){
         
         self.extSetText(text, textColor: textColor, fontSize: fontSize)
         self.textAlignment = textAlignment
         
     }
     
     public var attributedLabelFrame : CGRect {
         get {
             guard let attributedText = self.attributedText else {
                 return .zero
             }
             return attributedText.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.frame.height), options: .usesLineFragmentOrigin, context: nil)
         }
    }
    
    public convenience init(text: String?, font: UIFont?, textColor: UIColor?, alignment: NSTextAlignment) {
        self.init(text: text, frame: CGRect.zero, font: font, textColor: textColor, alignment: alignment)
    }
    
    public convenience init(text: String?, frame: CGRect, font: UIFont?, textColor: UIColor?, alignment: NSTextAlignment) {
        self.init()
        self.text = text
        if frame != .zero {
            self.frame = frame
        }
        self.font = font
        self.textColor = textColor
        self.textAlignment = alignment
    }
    
    /// 获取内容对应的宽度
    func textWidth() -> CGFloat {
        return self.text?.getWidth(height: self.ext_height(), font: self.font) ?? 0
    }
    
    /// 获取内容对应的高度
    func textHeight() -> CGFloat {
        return self.text?.getHeight(width: self.ext_width(), font: self.font) ?? 0
    }
    
    //倒计时，btn的type需要为custom
    public func countdown(_ num : Int ,unit : String = "s" ,defaultValue : String = "" , complete : (() -> ())? = nil){
        if num >= 0{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.text = defaultValue + "\(num)" + unit
                self.countdown(num - 1,defaultValue:defaultValue,complete : complete)
            }
            self.isUserInteractionEnabled = false
        }else{
            self.text = defaultValue
            self.isUserInteractionEnabled = true
            if complete != nil{
                complete!()
            }
        }
    }
}
