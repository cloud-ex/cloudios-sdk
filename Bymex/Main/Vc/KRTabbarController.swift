//
//  KRTabbarController.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {
    
    override  public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ThemeView.bg
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(  animated)
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public override var shouldAutorotate: Bool {
        return false
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
}

extension UITabBarController {
    /// 获取所有tabbar的vc
    @objc func getAllTabVC() -> [UIViewController] {
        if self.viewControllers != nil {
            return self.viewControllers!
        }
        return []
    }
    
    /// 获取当前vc的位置
    func getVCIndex(_ vc : UIViewController) -> Int {
        let array = getAllTabVC()
        for i in 0..<array.count{
            if array[i].classForCoder == vc.classForCoder {
                return i
            }
        }
        //如果没有就找首页
        return 0
    }
    
    /// 选中vc
    func selectIndexWith(_ vc : UIViewController) {
        let index = getVCIndex(vc)
        selectIndex(index)
    }
    
    /// 选中某个tab
    func selectIndex(_ index : Int , showLogin : Bool = true) {
        self.selectedIndex = index
        for view in (self.view.subviews){
            if view is KRTabbarView {
                (view as! KRTabbarView).changeItem(1000 + index)
            }
        }
    }
    
    /// 获取某个vc
    func getTabbarVC(_ index : Int) -> UIViewController {
        if let count = viewControllers?.count , let vc = viewControllers {
            if count > index{
                return vc[index]
            }else if count > 0{
                return vc[0]
            }
        }
        return UIViewController()
    }
    
    /// 获取当前的vc
    func getCurrentTabbarVC() -> UIViewController {
        let index = self.selectedIndex
        let vc = getTabbarVC(index)
        return vc
    }
}
