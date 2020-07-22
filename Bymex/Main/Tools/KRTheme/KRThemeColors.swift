//
//  KRThemeColors.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import SwiftTheme

extension UIColor {
    
    public struct ThemeLabel {
        public static var colorLite :UIColor { return UIColor.themeColor(keyPath:label_litecolor_key)}
        public static var colorMedium :UIColor { return UIColor.themeColor(keyPath:label_medidumcolor_key)}
        public static var colorDark :UIColor { return UIColor.themeColor(keyPath:label_darkcolor_key)}
        public static var colorHighlight :UIColor { return UIColor.themeColor(keyPath:label_highlight_key)}
        public static var white :UIColor { return UIColor.themeColor(keyPath:label_white_key)}
        public static var share :UIColor { return UIColor.themeColor(keyPath:label_share_key)}
    }
    
    public struct ThemeBtn {
        public static var normal :UIColor { return UIColor.themeColor(keyPath:btn_normal_key)}
        public static var disable :UIColor { return UIColor.themeColor(keyPath:btn_disable_key)}
        public static var highlight :UIColor { return UIColor.themeColor(keyPath:btn_highlight_key)}
        public static var selected :UIColor { return UIColor.themeColor(keyPath:btn_selected_key)}
        
        public static var normal1 :UIColor { return UIColor.themeColor(keyPath:btn_normal_key1)}
        public static var disable1 :UIColor { return UIColor.themeColor(keyPath:btn_disable_key1)}
        public static var highlight1 :UIColor { return UIColor.themeColor(keyPath:btn_highlight_key1)}
        
        public static var colorTitle :UIColor { return UIColor.themeColor(keyPath:btn_colorTitle_key)}
    }
    
    public struct ThemekLine {
        public static var up :UIColor {
            if KRKLineManager.isGreen() {
                return UIColor.themeColor(keyPath:kline_up_key)
            }else {
                return UIColor.themeColor(keyPath:kline_down_key)
            }
        }
        public static var up15 :UIColor {
            if KRKLineManager.isGreen() {
                return UIColor.themeColor(keyPath:kline_up15_key)
            }else {
                return UIColor.themeColor(keyPath:kline_down15_key)
            }
        }
        public static var down :UIColor {
            if KRKLineManager.isGreen() {
                return UIColor.themeColor(keyPath:kline_down_key)
            }else {
                return UIColor.themeColor(keyPath:kline_up_key)
            }
        }
        public static var down15 :UIColor {
            if KRKLineManager.isGreen() {
                return UIColor.themeColor(keyPath:kline_down15_key)
            }else {
                return UIColor.themeColor(keyPath:kline_up15_key)
            }
        }
        public static var yellow :UIColor { return UIColor.themeColor(keyPath:kline_yellow_key)}
        public static var green :UIColor { return UIColor.themeColor(keyPath:kline_green_key)}
        public static var purple :UIColor { return UIColor.themeColor(keyPath:kline_purple_key)}
        public static var pink :UIColor { return UIColor.themeColor(keyPath:kline_pink_key)}
        public static var tagbg :UIColor { return UIColor.themeColor(keyPath:kline_tagbg_key)}
        public static var seperator :UIColor { return UIColor.themeColor(keyPath:kline_seperator_key)}

    }
    
    public struct ThemeView {
        public static var mask :UIColor { return UIColor.black.withAlphaComponent(0.7)}
        public static var highlight :UIColor { return UIColor.themeColor(keyPath:view_highlight_key)}
        public static var highlight50 :UIColor { return UIColor.themeColor(keyPath:view_highlight50_key)}
        public static var highlight25 :UIColor { return UIColor.themeColor(keyPath:view_highlight25_key)}
        public static var highlight15 :UIColor { return UIColor.themeColor(keyPath:view_highlight15_key)}
        public static var bg :UIColor {
            return UIColor.themeColor(keyPath:view_bg_key)}
        public static var bgIcon :UIColor {
            return UIColor.themeColor(keyPath:view_bgIcon_key)}
        public static var bgIcon50 :UIColor {
            return UIColor.themeColor(keyPath:view_bgIcon50_key)}
        public static var bgIcon25 :UIColor {
            return UIColor.themeColor(keyPath:view_bgIcon25_key)}
        public static var bgIconh :UIColor {
            return UIColor.themeColor(keyPath:view_bgIconh_key)}
        public static var bgIconh50 :UIColor {
            return UIColor.themeColor(keyPath:view_bgIconh50_key)}
        public static var bgGap :UIColor { return UIColor.themeColor(keyPath:view_bggap_key)}
        public static var bgTab :UIColor { return UIColor.themeColor(keyPath:view_bgtab_key)}
        public static var seperator :UIColor { return UIColor.themeColor(keyPath:view_seperator_key)}
        public static var border :UIColor { return UIColor.themeColor(keyPath:view_border_key)}
        public static var borderSelected :UIColor { return UIColor.themeColor(keyPath:view_borderSelected_key)}
        public static var bgCard :UIColor { return UIColor.themeColor(keyPath:view_bgcard_key)}
        public static var mySign :UIColor {return UIColor.themeColor(keyPath: view_mySign_key)}
    }
    
    public struct ThemeNav {
        public static var bg :UIColor { return UIColor.themeColor(keyPath:nav_bg_key)}
    }
    
    public struct ThemeTab {
        public static var bg :UIColor { return UIColor.themeColor(keyPath:tab_bg_key)}
        public static var icon :UIColor { return UIColor.themeColor(keyPath:tab_icon_key)}
    }
    
    public struct ThemeState {
        public static var normal :UIColor { return
            UIColor.themeColor(keyPath:state_normal_key)}
        public static var normal80 :UIColor { return
            UIColor.themeColor(keyPath:state_normal80_key)}
        public static var success :UIColor { return UIColor.themeColor(keyPath:state_success_key)}
        public static var success80 :UIColor { return UIColor.themeColor(keyPath:state_success80_key)}
        public static var fail :UIColor { return UIColor.themeColor(keyPath:state_fail_key)}
        public static var fail80 :UIColor { return UIColor.themeColor(keyPath:state_fail80_key)}
        public static var warning :UIColor { return UIColor.themeColor(keyPath:state_warning_key)}
        public static var warning80 :UIColor { return UIColor.themeColor(keyPath:state_warning80_key)}
    }
    
    public struct ThemePageControl{
        public static var select :UIColor { return
            UIColor.themeColor(keyPath:pagecontrol_select_key)}
        public static var unselect :UIColor { return
            UIColor.themeColor(keyPath:pagecontrol_unselect_key)}
        public static var bannerSelect :UIColor { return
            UIColor.themeColor(keyPath:pagecontrol_bannerSelect_key)}
        public static var bannerUnselect :UIColor { return
            UIColor.themeColor(keyPath:pagecontrol_bannerUnselect_key)}
    }
    
    public struct ThemeTextField{
        public static var seperator :UIColor { return
            UIColor.themeColor(keyPath:textfield_seperator_key)}
    }
    
    static func themeColor(keyPath:String) -> UIColor{
        let hexColor = ThemeManager.currentTheme?.value(forKeyPath: keyPath)
        if let colorValue = hexColor as? String {
            if colorValue.hasPrefix("#") {
                if colorValue.count == 7 {
                    return UIColor.extColorWithHex(colorValue)
                }else if colorValue.count == 9 {
                    let hexValue = colorValue.suffix(8)
                    var color: UInt64 = 0
                    let hexString: String = hexValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    let scanner = Scanner(string: String(hexString))
                    scanner.scanHexInt64(&color)
                    let mask = 0x000000FF
                    let a = Int(color >> 24) & mask
                    let alpha = CGFloat(a)/CGFloat(255)
                    
                    return UIColor.extColorWithHex("#"+colorValue.suffix(6),alpha:alpha)
                }
            }
        }
        return UIColor.white
    }
}

extension UIColor {
    public final class func extRGBA(red : CGFloat , green : CGFloat , blue : CGFloat , alpha : CGFloat)-> UIColor{
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    
    public final class func extColorWithHex(_ hex : String, alpha:CGFloat = 1) -> UIColor{
        var hexColor = hex
        hexColor = hexColor.replacingOccurrences(of: " ", with: "")
        if(hexColor.hasPrefix("#")){
            hexColor = String(hexColor.suffix(from: hexColor.index(hexColor.startIndex, offsetBy: 1)))
        }
        let rStr = String(hexColor[hexColor.startIndex ..< hexColor.index(hexColor.startIndex, offsetBy: 2)])
        let gStr = String(hexColor[hexColor.index(hexColor.startIndex, offsetBy: 2) ..< hexColor.index(hexColor.startIndex, offsetBy: 4)])
        let bStr = String(hexColor[hexColor.index(hexColor.startIndex, offsetBy: 4) ..< hexColor.index(hexColor.startIndex, offsetBy: 6)])
        var r = UInt64()
        var g = UInt64()
        var b = UInt64()
        Scanner.init(string: rStr).scanHexInt64(&r)
        Scanner.init(string: gStr).scanHexInt64(&g)
        Scanner.init(string: bStr).scanHexInt64(&b)
        let color : UIColor = UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
        return color;
    }
    
    func overlayWhite()->UIColor {
        return self.add(overlay: UIColor.black.withAlphaComponent(0.1))
    }
    
    func add(overlay: UIColor) -> UIColor {
        var bgR: CGFloat = 0
        var bgG: CGFloat = 0
        var bgB: CGFloat = 0
        var bgA: CGFloat = 0
        
        var fgR: CGFloat = 0
        var fgG: CGFloat = 0
        var fgB: CGFloat = 0
        var fgA: CGFloat = 0
        
        self.getRed(&bgR, green: &bgG, blue: &bgB, alpha: &bgA)
        overlay.getRed(&fgR, green: &fgG, blue: &fgB, alpha: &fgA)
        
        let r = fgA * fgR + (1 - fgA) * bgR
        let g = fgA * fgG + (1 - fgA) * bgG
        let b = fgA * fgB + (1 - fgA) * bgB
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

