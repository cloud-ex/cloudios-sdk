//
//  KRSpaceLabel.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/23.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSpaceLabel: UILabel {
    typealias ClickLabelBlock = () -> ()
    var clickLabelBlock : ClickLabelBlock?
    
    var textInsets: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = textInsets
        var rect = super.textRect(forBounds: bounds.inset(by: insets),
                                  limitedToNumberOfLines: numberOfLines)
        
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
    
    func showTapLabel() {
        backgroundColor = UIColor.ThemeView.bg
        textInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        extSetBorderWidth(1, color: UIColor.ThemeView.seperator)
        extSetCornerRadius(4)
        addTap()
    }
    
    func addTap() {
        self.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer()
        self.addGestureRecognizer(gesture)
        gesture.rx.event.bind(onNext: {[weak self] recognizer in
            self?.clickLabelBlock?()
        }).disposed(by: disposeBag)
    }
}
