//
//  KRTabbarView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/10.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

import UIKit

class KRTabbarView: UIView {
    
    var tabbarModel = KRTabbarModels()
    
    var tabbarItemModel : [KRTabbarModel] = []

    var tabbarcontroller : UITabBarController?//真实的tabbar
    
    //顶部的线
    lazy var topLine : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    public init(_ tabbarcontroller : UITabBarController){
        super.init(frame: CGRect.zero)
        setTabbarItemModel()
        self.tabbarcontroller = tabbarcontroller
        setTabbarItem()
        _ = KRLaunguageBase.getSubjectAsobsever().subscribe({[weak self] (event) in
            guard let mySelf = self else {return}
            mySelf.reloadTabbarItem()
        })
        addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
    func setTabbarItemModel(){
        //场外 和 合约 EXHomeVC(),MarketVC(),EXTransactionVC(),otc,ContractVC()
        tabbarItemModel = [tabbarModel.homeModel,tabbarModel.swapModel,tabbarModel.assetModel]
    }
    
    //MARK:设置tabbar的视图
    public func setTabbarItem(){
        guard let count = self.tabbarcontroller?.viewControllers?.count else{return}
        if count <= 5{
            let width = SCREEN_WIDTH / CGFloat(count)
            for i in 0..<count{
                initTabbarItem(i, width: width)
            }
        }else{
            let width = SCREEN_WIDTH / 5
            for i in 0..<5{
               initTabbarItem(i, width: width)
            }
        }
    }
    
    //MARK:添加tabbar的item
    func initTabbarItem(_ tag : Int , width : CGFloat){
        let tabbarItem = KRTabbarItem()
        tabbarItem.tag = tag + 1000
        tabbarItem.setImageAndLabel(tabbarItemModel[tag])
        addSubview(tabbarItem)
        tabbarItem.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(width * CGFloat((tag)))
            make.width.equalTo(width)
        }
        
        if tag == self.tabbarcontroller?.selectedIndex{
            tabbarItem.subject.onNext(true)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickTabbarItem))
        tap.numberOfTapsRequired = 1
        tabbarItem.addGestureRecognizer(tap)
    }

    @objc func reloadTabbarItem(){
        for view in subviews{
            if view is KRTabbarItem{
                view.removeFromSuperview()
            }
        }
        tabbarModel = KRTabbarModels()
        setTabbarItemModel()
        setTabbarItem()
    }
    
    //MARK:点击tabbarItem
    @objc func clickTabbarItem(_ tap : UITapGestureRecognizer){
        if let view = tap.view as? KRTabbarItem{
            let vc = self.tabbarcontroller?.getTabbarVC(view.tag - 1000)
            if vc is KRAssetVc{ // 资产页面未登录弹出登录框
//                if KRBusinessTools.loginStatus() == false {
//                    // 弹出登录
//                    KRBusinessTools.showLoginVc(self.yy_viewController)
//                    return
//                }
            }
            self.tabbarcontroller?.selectIndex(view.tag - 1000)
        }
    }
    
    //MARK:改变item
    func changeItem(_ tag : Int){
        for subview in self.subviews{
            if let v = subview as? KRTabbarItem{
                v.subject.onNext(v.tag == tag)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
