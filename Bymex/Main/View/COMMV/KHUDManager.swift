//
//  KHUDManager.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/13.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import SVProgressHUD
import JGProgressHUD

public class ProgressHUDManager {
    
    static let time = TimeInterval.init(3)
    
    public class func setBackgroundColor(_ color: UIColor) {
        SVProgressHUD.setBackgroundColor(color)
    }
    
    public class func setForegroundColor(_ color: UIColor) {
        SVProgressHUD.setForegroundColor(color)
    }
    
    public class func setFont(_ font: UIFont) {
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 16))
    }
    
    public class func showImage(_ image: UIImage?, status: String) {
        
        SVProgressHUD.show(image, status: status)
    }
    
    public class func show() {
        SVProgressHUD.show()
    }
    
    public class func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    public class func setMinimumDismissTimeInterval(_ delay : TimeInterval){
        SVProgressHUD.setMinimumDismissTimeInterval(delay)
    }
    
    public class func showWithStatus(_ status: String?) {
        SVProgressHUD.show(withStatus: status)
    }
    
    public class func isVisible() -> Bool {
        return SVProgressHUD.isVisible()
    }
    
    public class func loading(_ string : String = ""){
        SVProgressHUD.setBackgroundColor(UIColor.ThemeView.bg)
        SVProgressHUD.setForegroundColor(UIColor.ThemeView.bg)
        SVProgressHUD.show(UIImage.themeImageNamed(imageName: "icon_loading"), status: "")
    }
    
    public class func showSuccessWithStatus(_ string: String) {
//        EXAlert.showSuccess(msg: string)
        XHUDManager.dismiss()
    }
    
    public class func showFailWithStatus(_ string : String){
//        EXAlert.showFail(msg: string)
        XHUDManager.dismiss()
    }
    
    public class func showProgress(_ progress: Float) {
        SVProgressHUD.showProgress(progress)
    }
    
    public class func showProgress(_ progress: Float,status:String) {
        SVProgressHUD.showProgress(progress, status: status)
//
    }
    
    public class func showErrorWithStatus(_ string: String) {
//        EXAlert.showFail(msg: string)
        XHUDManager.dismiss()
//
    }
    
    public class func showSuccessWithStatus(_ string: String!, maskType: SVProgressHUDMaskType) {
        SVProgressHUD.showSuccess(withStatus: string)
        SVProgressHUD.setDefaultMaskType(maskType)
        
    }
    
    public class func showErrorWithStatus(_ string: String, maskType: SVProgressHUDMaskType) {
//        EXAlert.showFail(msg: string)
        XHUDManager.dismiss()
    }
    
    public class func showWithStatus(_ status: String!, maskType: SVProgressHUDMaskType) {
        SVProgressHUD.show(withStatus: status)
        SVProgressHUD.setDefaultMaskType(maskType)
        
    }
    
    public class func showStatus(_ status: String!, maskType: SVProgressHUDMaskType) {
        SVProgressHUD.show(withStatus: status)
        SVProgressHUD.setDefaultMaskType(maskType)
    }
    
    public class func showStatusWithTime(_ status: [String], maskType: SVProgressHUDMaskType){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
        }
    }

    public class func dismissWithDelay(_ f : @escaping (() -> ())){
        SVProgressHUD.dismiss(withDelay: 0) {
            f()
        }
    }
    
}

class XHUDManager : UIView{
    
    //MARK:单例
    public static var sharedInstance : XHUDManager{
        struct Static {
            static let instance : XHUDManager = XHUDManager()
        }
        return Static.instance
    }
    
    var imgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        self.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
    }
    
    func getImgV(){
        DispatchQueue.main.async {
            self.imgV = UIImageView()
            self.imgV.image = UIImage.themeImageNamed(imageName: "icon_loading")
            self.imgV.extUseAutoLayout()
            self.imgV.layer.add(self.animation(), forKey: "rotate")
            self.addSubview(self.imgV)
            self.imgV.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.width.height.equalTo(40)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loading() {
        dismissWithDelay{}
        guard let appDelegate = UIApplication.shared.delegate else {
            return
        }
        getImgV()
        appDelegate.window??.rootViewController?.view.addSubview(self)
    }
    
    func animation() -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        animation.fillMode = CAMediaTimingFillMode.forwards;
        animation.toValue = Double.pi * 2.0
        animation.duration = 1
        animation.repeatCount = Float.greatestFiniteMagnitude
        return animation
    }
    
    func dismissWithDelay(_ f : @escaping (() -> ())){
        imgV.removeFromSuperview()
        self.removeFromSuperview()
        f()
    }
    
    static func show() {
        XHUDManager.sharedInstance.loading()
    }
    
    static func dismiss() {
        XHUDManager.sharedInstance.dismissWithDelay {
        }
    }
}
