//
//  KRLaunguageBase.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/10.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import RxSwift

class KRLaunguageBase: NSObject {

    public var subject : BehaviorSubject<Int> = BehaviorSubject.init(value: 0)
    
    var items : [(Any,Selector)] = []
    
    //MARK:单例
    public static var sharedInstance : KRLaunguageBase {
        struct Static {
            static let instance : KRLaunguageBase = KRLaunguageBase()
        }
        return Static.instance
    }
    
    //订阅，会更改语言的热信号
    class func getSubjectAsobsever() -> BehaviorSubject<Int>{
        return KRLaunguageBase.sharedInstance.subject.asObserver()
    }
    
}
