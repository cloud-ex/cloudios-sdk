//
//  KRBasicParameter.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/10.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import YYText
import RxSwift
import Reachability


public let isiPhoneX = (UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896) ? true : false

public let MARGIN_SPACE = 12 // 间隔

public let MARGIN_LEFT = 20

public let SCREEN_WIDTH = UIScreen.main.bounds.width//屏幕宽度

public let SCREEN_HEIGHT = UIScreen.main.bounds.height//屏幕高度

public let NAV_TOP : CGFloat = isiPhoneX ? 24 : 0//距离顶部

public let NAV_SCREEN_HEIGHT :CGFloat = isiPhoneX ? 88 : 64//导航栏高度
public let NAV_SAFEAERA_HEIGHT :CGFloat = isiPhoneX ? 44 : 44//导航栏高度
public let NAV_STATUS_HEIGHT :CGFloat = isiPhoneX ? 44 : 20//导航栏高度

public let TABBAR_BOTTOM : CGFloat = isiPhoneX ? 34 : 0//距离底部
public let BANG_HEIGHT : CGFloat = isiPhoneX ? 44 : 0

public let CONTENTVIEW_HEIGHT :CGFloat = SCREEN_HEIGHT - NAV_SCREEN_HEIGHT

public let TABBAR_HEIGHT :CGFloat = isiPhoneX ? 83.5 : 49.5//tabbar高度

public let TABBAR_CONTENTVIEW_HEIGHT = CONTENTVIEW_HEIGHT - TABBAR_HEIGHT//tabbar contentview的高度
public var CUSTOM_LABEL_SIZE : CGFloat = 18 //默认的文字大小
public var CUSTOM_LABEL_FONT : UIFont = UIFont.systemFont(ofSize: CUSTOM_LABEL_SIZE)

public var HEIGHT_PROPORTION = SCREEN_HEIGHT / 667
public var WIDTH_PROPORTION = SCREEN_WIDTH / 375

public var Margin_FieldH = 56


@objcMembers class KRBasicParameter: NSObject {
    
    //MARK:获取appVersion
    class func getAppVersion() -> String{
        let dict = Bundle.main.infoDictionary
        if dict != nil{
            if let appVersion = dict!["CFBundleVersion"] as? String{
                return appVersion
            }
        }
        return ""
    }
    
    //MARK:获取渠道来源
    class func getChannel() -> String {
        guard let provision = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision")  else {
            return "TestFlight"
        }
        if provision.isEmpty {
            return "TestFlight"
        }
        return "Enterprise"
    }
    
    //MARK:获取bundleid
    class func getBundleIdentifier() ->String {
        let bundleID = Bundle.main.bundleIdentifier
        return bundleID ?? ""
    }
    
    //MARK:获取deviceVersion
    class func getDeviceVersion() -> String{
        return UIDevice.current.systemVersion
    }
    
    //MARK:获取bundleid
    class func getBundleId() -> String{
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    //MARK:获取设备型号
    class func getPhoneModel() -> String{
        return UIDevice.current.model
    }
    
    //MARK:获取设备系统
    class func getPhoneOS() -> String{
        return UIDevice.current.systemName
    }
    
    //MARK:获取13位时间戳
    class func getNonce13() -> String {
        return KRDateTools.getMillTimeInterval()
    }
    
    //MARK:获取16位时间戳
    class func getNonce16() -> String {
        return KRDateTools.getHunMillTimeInterval()
    }
    
    //MARK:谷歌序列码
    class func getGoogleAuthAlignment(_ name:String,ga_key:String) -> String {
        let strArr = name.components(separatedBy: " ")
        var str = ""
        if strArr.count == 2 {
            str = String(format: "%@%@", strArr[0],strArr[1])
        } else {
            str = name
        }
        let result = String(format: "otpauth://totp/%@?secret=%@&issuer=Bymex", str,ga_key)
        return result
    }
    
    
    @objc  static var phoneLanguage = ""
    
    //MARK:获取手机语言，忽略服务端用希腊语替代繁体中文
    class func getPhoneLanguage(ignoreServer:Bool = false) -> String{
    
        var string:String = UserDefaults.standard.value(forKey: UserLanguage) as! String? ?? ""
        
        if string == "" {
            
            let languages = UserDefaults.standard.object(forKey: AppleLanguages) as? NSArray
            
            if languages?.count != 0 {
                
                let current = languages?.object(at: 0) as? String
                
                if current != nil {
                    string = current!
                    string = string.replacingOccurrences(of: "-", with: "_")
                    return string
                }
            }
        }
        

        if (string.range(of: "zh") != nil){
            if (string.range(of: "zh-Hant") != nil){
                if ignoreServer {
                    phoneLanguage = "zh-Hant"
                }else {
                    phoneLanguage = KRLaunguageTools.el
                }
            }else{
                phoneLanguage = KRLaunguageTools.ch
            }
            
        }else if (string.range(of: "en") != nil){
            phoneLanguage = KRLaunguageTools.en
        }else if (string.range(of: "ko") != nil){
            phoneLanguage = KRLaunguageTools.ko
        }else if (string.range(of: "ja") != nil){
            phoneLanguage = KRLaunguageTools.jp
        }else if (string.range(of: "vi") != nil){
            phoneLanguage = KRLaunguageTools.vi
        }else if (string.range(of: "es") != nil){
            phoneLanguage = KRLaunguageTools.es
        }else{
            if KRLaunguageTools.shareInstance.supportLan(string) {
                var key = string
                key = key.replacingOccurrences(of: "-", with: "_")
                phoneLanguage = key
            }else {
                phoneLanguage = KRLaunguageTools.en
            }
        }

        return phoneLanguage
    }
    
    //是否为汉语
    class func isHan()->Bool{
        if KRBasicParameter.getPhoneLanguage() == KRLaunguageTools.ch || KRBasicParameter.getPhoneLanguage() == KRLaunguageTools.el{
            return true
        }else{
            return false
        }
    }
    
    //MARK:获取UDID
    class func getUUID()-> String {
        var str = ""
        
        if let uuid = XUserDefault.getVauleForKey(key: XUserDefault.XUUID) as? String{
            str = uuid
        }
        
        if str == ""{
            if let uuid = UIDevice.current.identifierForVendor{
                XUserDefault.setValueForKey(String(describing:uuid),key:XUserDefault.XUUID)
            }
        }
        
        return str
    }
    
    //MARK:获取网络状态
    class func getNetStatus() -> String{
        var str = ""
        
        let reachability  = Reachability.forInternetConnection()
        if let networkStatus = reachability?.currentReachabilityStatus()  {
            switch networkStatus {
            case NetworkStatus.ReachableViaWiFi:
                str = "WIFI"
            case NetworkStatus.ReachableViaWWAN:
                str = "WWAN"
            default:
                str = "NONE"
            }
        }
        return str
    }
    
    //获取联系电话
    class func getContactPhoneNumber()->String{
        return "010-88888888"
    }
    
    class func handleDouble(_ a : Any) -> Double{
        switch a {
        case let val as Double:
            //            print("\(val)是个数字类型")
            return Double(val)
        case let val as String:
            //            print("\(val)是个字符串")
            return (val as NSString).doubleValue
        case let val as Int:
            //            print("\(val)是int")
            return Double(val)
            
        case let val as Float:
            //            print("\(val)是个float")
            return Double(val)
        default:
            print("啥都不是")
        }
        return 0
    }
    
    // 获取app名字
    class func getAppName() -> String{
        let bundle = KRLaunguageTools.shareInstance.bundle
        let dict = bundle?.localizedInfoDictionary
        if dict != nil{
            if let appDisplay = dict!["CFBundleDisplayName"] as? String{
                return appDisplay
            }
        }
        return ""
    }
    
    class func depthToDouble(_ i : Int) -> String{
        var d = "0."
        if i > 0{
            for _ in 0..<i-1{
                d = d + "0"
            }
            d = d + "1"
        }else{
            d = "1"
        }
        return d
    }
    
    //处理数量精度
    class func dealVolumFormate(_ str : String) -> String{
        let decimals = 8
        //如果是0，则返回0
        if Double(str) == 0{
            return "0"
        }
        //如果小于0.001 则返回0
        if let poor = (str as NSString).subtracting("0.001", decimals: decimals) , poor.contains("-"){
            return "0.000"
        }else if let f = Float((str as NSString).dividing(by: "1000", decimals: 2)) , f > 1 {
            return dealDataFormate(str)
        }else{
            return KRBasicParameter.dealDecimalPoint(str)
        }
        
        return str
    }
    
    //处理数据格式
    class func dealDataFormate(_ str : String) -> String{
        
        if let millionStr = NSString.init(string: str).dividing(by: "1000000000", decimals: 2){
            if let m = Float(millionStr) , m > 1{
                return KRBasicParameter.dealDecimalPoint(millionStr,digits:4) + "B"
            }
        }
        
        if let millionStr = NSString.init(string: str).dividing(by: "1000000", decimals: 2){
            if let m = Float(millionStr) , m > 1{
                return KRBasicParameter.dealDecimalPoint(millionStr,digits:4) + "M"
            }
        }
        
        if let kStr = NSString.init(string: str).dividing(by: "1000", decimals: 2){
            if let k = Float(kStr) , k > 1{
                return KRBasicParameter.dealDecimalPoint(kStr,digits:4) + "K"
            }
        }
        
        return str
    }
    
    //digits必须大于0
    class func dealDecimalPoint(_ str : String,digits : Int = 5 , precision : Int = 3) -> String{
        var tmpStr = (str as NSString).decimalString1(precision)
        if let s = tmpStr , s.count > digits{
            tmpStr = s[0...digits]
        }
        if let last = tmpStr?.last, last == "."{
            tmpStr?.removeLast()
        }
        if tmpStr != nil{
            return tmpStr!
        }
        return str
    }
    
    //处理数字的颜色
    class func dealNumColor(_ num : String) -> UIColor{
        var color = UIColor.ThemeLabel.colorLite
        if num.contains("-"){
            color = UIColor.ThemekLine.down
        }else{
            if let n = Int(num) , n > 0{
                color = UIColor.ThemekLine.up
            }
        }
        return color
    }
    
    class func share(_ vc : UIViewController , text : String = "", url : String = "",image : UIImage? = nil ,completionHandler : @escaping (() -> ()) ){
        //初始化一个UIActivity
        let activity = UIActivity()
        var activityItems : [Any] = []
        if text != ""{
            activityItems.append(text)
        }
        if url != "" , let shareUrl = URL.init(string: url){
            activityItems.append(shareUrl)
        }
        if image != nil{
            activityItems.append(image ?? UIImage())
        }
        let activities = [activity]
        //初始化UIActivityViewController
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: activities)
        //排除一些服务：例如复制到粘贴板，拷贝到通讯录
        activityController.excludedActivityTypes = [UIActivity.ActivityType.copyToPasteboard,UIActivity.ActivityType.assignToContact]
        //iphone中为模式跳转
        activityController.modalPresentationStyle = .fullScreen
        vc.present(activityController, animated: true) { () -> Void in
        }
        //结束后执行的Block，可以查看是那个类型执行，和是否已经完成
        activityController.completionWithItemsHandler = {activityType, completed, returnedItems, activityError in
            if activityError == nil , completed == true{
            }else{
                NSLog("失败")
            }
            completionHandler()
        }
//        activityController.completionHandler = { activityType, error in
//            if error == false{
//            }
//        }
    }
    
    //把精度转成小数
    class func strToPrecision(_ str : String) -> String{
        var precision = "0"
        let num = Int(KRBasicParameter.handleDouble(str))
        if num == 0{
            return "1"
        }else{
            precision = precision + "."
            for _ in 0..<num{
               precision = precision + "0"
            }
            return precision + "1"
        }
    }
    
    static let dispose = DisposeBag()
    
    //获取版本号，请求publininfo
    class func getVersionForPublicInfo(){
        
    }
    
    class func firstVCDismiss(){
        guard let appDelegate  = UIApplication.shared.delegate else {
            return
        }
        if appDelegate.window != nil   {
            let vc = appDelegate.window??.rootViewController?.presentedViewController
            vc?.popBack()
        }
    }
    
    //获取第一个vc
    class func getFirstVC(_ type : String = "push") -> UIViewController?{
        guard let appDelegate  = UIApplication.shared.delegate else {
            return nil
        }
        if type == "push"{
            if appDelegate.window != nil   {
                if let vc = appDelegate.window??.rootViewController?.children.last{
                    return vc
                }
            }
        }else{
            if appDelegate.window != nil   {
                if let vc = appDelegate.window??.rootViewController?.presentedViewController{
                    return vc
                }
            }
        }
        return nil
    }
    
    
}


extension NSMutableAttributedString{
    
    func highLightTap(_ range : NSRange , _ tapAction : @escaping ((UIView, NSAttributedString, NSRange, CGRect) -> ())){
        let highLightOfReplyUser = YYTextHighlight()
        highLightOfReplyUser.tapAction = tapAction
        self.yy_setTextHighlight(highLightOfReplyUser, range:range)
    }
    
    func add(string : String, attrDic : [NSAttributedString.Key : Any])-> NSMutableAttributedString{
        //        if let imageBoundsAttributeName = attrDic["NSImageAttributeName"] as? String , let imageAttributeName =  attrDic["NSImageBoundsAttributeName"] as? UIImage{
        //            let attach = NSTextAttachment.init(data: nil, ofType: nil)
        //            let rect = CGRectFromString(imageBoundsAttributeName)
        //            attach.bounds = rect
        //            attach.image = imageAttributeName
        //            self.append(NSAttributedString.init(attachment: attach))
        //        }else{
        self.append(NSAttributedString.init(string: string, attributes: attrDic))
        //        }
        return self
    }
    
    func appendAttributedString(_  att : NSAttributedString) -> NSMutableAttributedString{
        self.append(att)
        return self
    }
    
}
