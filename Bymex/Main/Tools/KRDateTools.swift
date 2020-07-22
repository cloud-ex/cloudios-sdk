//
//  KRDateTools.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRDateTools : NSObject {
    /// 获取当前时间戳
    public class func getNowTimeInterval() -> Int{
        let date = Date()
        let timeInterval = Int(date.timeIntervalSince1970)
        return timeInterval
    }
    
    public class func getMillTimeInterval() -> String{
        let date = Date()
        let timeInterval: TimeInterval = date.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    public class func getHunMillTimeInterval() -> String{
        let date = Date()
        let timeInterval: TimeInterval = date.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000000))
        return "\(millisecond)"
    }
    
    /// 字符串类型转成时间
    public class func strToTimeString(_ string : String , dateFormat : String = "yyyy-MM-dd HH:mm:ss") -> String{
        var time = TimeInterval.init(0)
        if string.count >= 13{
            if let t = TimeInterval.init(string.prefix(10)){
                time = t
            }
        }else{
            if let t = TimeInterval.init(string){
                time = t
            }
        }
        return KRDateTools.dateToString(time ,dateFormat:dateFormat)
    }
    
    /// 数字类型转时间
    public class func dateToString(_ time : TimeInterval, dateFormat : String = "yyyy-MM-dd HH:mm:ss") -> String{
        let formatter = DateFormatter.init()
        formatter.dateFormat = dateFormat
            
        let date = Date.init(timeIntervalSince1970: time)
        let timestr = formatter.string(from: date)
            
        return timestr
    }
    
    /// 转成时分秒
    public class func stringToHourMinSec(_ str : String) -> (Int , Int , Int){
        if let intStr = Int(str){
            let hour = intStr / 3600
            let min = (intStr - hour * 3600) / 60
            let sec = intStr % 60
            return (hour , min , sec)
        }
        return (0,0,0)
    }
    
    /// 距离现在多少秒
    public class func nowSubTime(_ time : String) -> String{
        let date = Date().timeIntervalSince1970
        if let diff = NSString.init(string: "\(date)").subtracting(time, decimals: 0){
            return "\(diff)"
        }
        return "0"
    }
    
     /// 日期类型转成时间
    public class func dateToString(_ date : Date, dateFormat : String = "yyyy-MM-dd") -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
       
    public class func getNow() -> Date {
        let today = Date()
        let zone = NSTimeZone.system
        let interval = zone.secondsFromGMT()
        let now = today.addingTimeInterval(TimeInterval(interval))
        return now
    }
       
    public class func timeStampToString(_ timestamp:TimeInterval) -> String{
        let date = Date(timeIntervalSince1970: timestamp)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss" // 自定义时间格式q1
        return dateformatter.string(from: date)
    }
       
    /// 标准的yyyy-mm-dd 才可以使用
    public class func getMouth(_ time : String) -> String{
        let substr = time
        var mouth = ""
        let array = substr.components(separatedBy: "-")
        if array.count > 1{
            mouth = array[1]
        }
        return mouth
    }
       
    /// 标准的yyyy-mm-dd 才可以使用
    public class func getDay(_ time : String) -> String{
        let substr = time
        var day = ""
        let array = substr.components(separatedBy: "-")
        if array.count > 2{
            day = array[2]
            let arr = day.components(separatedBy: " ")
            if arr.count > 0{
                day = arr[0]
            }
        }
        return day
    }
}
