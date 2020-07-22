//
//  KRThemeManager.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import SwiftTheme

let THEME_CHANGE_NOTI = "THEME_CHANGE_NOTI"
let KLINE_CHANGE_NOTI = "KLINE_CHANGE_NOTI"

private let lastThemeIndexKey = "lastedThemeIndex"
private let lastedKlineIndex = "lastedKlineIndex"

private let defaults = UserDefaults.standard

enum KRThemeManager : Int {
    case day   = 0
    case night = 1
    // MARK: -
    static var current = KRThemeManager.night
    static var before = KRThemeManager.night
    
    // MARK: - Switch Theme
    static func switchTo(theme: KRThemeManager) {
        before = current
        current = theme
        switch theme {
        case .day:
            ThemeManager.setTheme(plistName: "DayTheme", path: .mainBundle)
        case .night:
            ThemeManager.setTheme(plistName: "NightTheme", path: .mainBundle)
        }
        saveLastTheme()
        NotificationCenter.default.post(name: NSNotification.Name.init(THEME_CHANGE_NOTI),object: nil)
    }
    
    static func switchNight(isToNight: Bool) {
        switchTo(theme: isToNight ? .night : before)
    }
    
    static func isNight() -> Bool {
        return current == .night
    }
    
    static func restoreLastTheme() {
        let idx = defaults.integer(forKey: lastThemeIndexKey)
        let temptheme = KRThemeManager(rawValue: idx)
        if let themem = temptheme {
            switchTo(theme:themem)
        }else {
            switchTo(theme: .day)
        }
        KRKLineManager.restoreLastKline()
    }
    
    static func saveLastTheme() {
        defaults.set(current.rawValue, forKey: lastThemeIndexKey)
    }
    
    static func setStatusBarStyle(_ style : UIStatusBarStyle) {
        UIApplication.shared.statusBarStyle = style
    }
}

enum KRKLineManager: Int {
    case green = 0
    case red = 1
    // MARK: -
    static var current = KRKLineManager.green
    static var before = KRKLineManager.green
    
    // MARK: - Switch Theme
    static func switchTo(theme: KRKLineManager) {
        before = current
        current = theme
        switch theme {
        case .green:
            break
        case .red:
            break
        }
        saveLastKline()
        NotificationCenter.default.post(name: NSNotification.Name.init(KLINE_CHANGE_NOTI),object: nil)
    }

    static func isGreen() -> Bool {
        return current == .green
    }
    
    static func restoreLastKline() {
        let idx = defaults.integer(forKey: lastedKlineIndex)
        let temptheme = KRKLineManager(rawValue: idx)
        if let themem = temptheme {
            switchTo(theme:themem)
        }else {
            switchTo(theme: .green)
        }
    }
    
    static func saveLastKline() {
        defaults.set(current.rawValue, forKey: lastedKlineIndex)
    }
    
}
