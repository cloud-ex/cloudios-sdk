//
//  KRTextViewEx.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/10.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

extension UITextView {
    public final func extSelectRange() -> NSRange {
        let beginning = self.beginningOfDocument
        let selectedRange = self.selectedTextRange
        let selectionStart = selectedRange!.start
        let selectionEnd = selectedRange!.end
    
        let location: NSInteger = self.offset(from: beginning, to: selectionStart)
        let length: NSInteger = self.offset(from: selectionStart, to: selectionEnd)
        
        return NSMakeRange(location, length)
    }
    
    public func extSetSelectRange(_ range: NSRange) -> Void {
        let beginning = self.beginningOfDocument
        
        let startPosition = self.position(from: beginning, offset:  range.location + range.length)
        let endPosition = self.position(from: beginning, offset:  range.location + range.length)
    
        if startPosition != nil && endPosition != nil {
            let selectionRange = self.textRange(from: startPosition!, to: endPosition!)

            self.selectedTextRange = selectionRange
        } else {
        }
        
    }
}

