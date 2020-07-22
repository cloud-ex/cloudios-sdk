//
//  KRNetDefine.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

public class NetDefine: NSObject {
    
    static let PRIVATE_KEY = "OZ1WNXAlbe84Kpq8"
    static let CaptchID = "98a6399274f34c229b81fd4f81cb2f77"
    
    static let http_host_url = "https://api.lpmex.com/v1"
    
    static let swap_host_url = "https://api.lpmex.com/swap/"
    
    static let swap_wss_url = "https://api.lpmex.com/wsswap/realTime"
    
    @objc class func domain_host_url() -> String{
        var hosturl = ""
        if let url = URL.init(string: NetDefine.http_host_url) , let host = url.host{
            let index = host.positionOf(sub: ".")
            hosturl = host.extStringSub(NSRange.init(location: index, length: host.count - index))
        }
        return hosturl
    }
}
