//
//  KRViewControllerEx.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/10.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     弹出模态视图控制器
     
     - parameter vc:              控制器
     - parameter backgroundColor: 背景色 可不传 有默认值
     - parameter animated:        是否动画 可不传 有默认值 默认无动画
     */
    public final func extShowModalVC(_ vc :UIViewController , backgroundColor :UIColor = UIColor.extRGBA(red: 66.0, green: 66.0, blue: 66.0, alpha: 0.4) , animated :Bool = false){
        
        guard let appDelegate  = UIApplication.shared.delegate else {
            return
        }

        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        if appDelegate.window != nil   {
            appDelegate.window??.rootViewController!.present(vc, animated: animated, completion: {
                    //背景色 透明
                vc.view.backgroundColor  = backgroundColor
                    
            })
        }
    }
    
    func popBack(_ animated : Bool = true){
        if let vcs = self.navigationController?.viewControllers ,  vcs.count > 1 {
            self.navigationController!.popViewController(animated: animated)
        } else {
            self.dismiss(animated: animated, completion: nil)
        }
    }
    
    func pushDrawerVc(_ animated : Bool = true,_ vc : UIViewController) {
        if let vcs = self.navigationController?.viewControllers ,  vcs.count > 1 {
            self.navigationController!.pushViewController(vc, animated: animated)
        }
    }
}

