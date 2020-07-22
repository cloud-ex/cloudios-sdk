//
//  KRFlatBtn.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/7.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class KRFlatBtn: EXButton {
    
    var bgColor:UIColor = UIColor.ThemeView.highlight {
        didSet {
            self.color = bgColor
            self.highlightedColor = UIColor.ThemeView.highlight
            self.selectedColor = UIColor.ThemeView.highlight
            self.disabledColor = bgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
    
    fileprivate func configure() {
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
        self.bgColor = UIColor.ThemeView.bg
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.ThemeView.border.cgColor
        adjustsImageWhenDisabled = false
        adjustsImageWhenHighlighted = false
    }
}

class KRFrameBtn: EXButton {
    var bgColor:UIColor = UIColor.ThemeView.highlight {
        didSet {
            self.color = bgColor
            self.highlightedColor = UIColor.ThemeView.highlight
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
    
    fileprivate func configure() {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.bgColor = UIColor.ThemeTab.bg
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.ThemeLabel.colorHighlight.cgColor
        adjustsImageWhenDisabled = false
        adjustsImageWhenHighlighted = false
    }
}
