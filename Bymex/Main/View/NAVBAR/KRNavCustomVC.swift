//
//  KRNavCustomVC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/10.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum NavType {
    case normal//普通
    case list//表单
    case listtitle//表单title
    case notitle//没有标题
    case nopopback//没有返回按钮
    case swap// 合约顶部
}

@objcMembers class KRNavCustomVC: KRBaseVc , UIGestureRecognizerDelegate {
    
    var lastVC = false
    {
        didSet{
            navCustomView.backView.backgroundColor = UIColor.ThemeView.bg
        }
    }
    
    var navtype = NavType.normal
    {
        didSet{
            switch navtype {
            case .list:
                navCustomView.snp.remakeConstraints { (make) in
                    make.top.left.right.equalTo(self.view)
                    make.height.equalTo(NAV_SCREEN_HEIGHT + 62)
                }
                navCustomView.middleTitle.snp.remakeConstraints { (make) in
                    make.top.equalTo(navCustomView.popBtn.snp.bottom).offset(24)
                    make.height.equalTo(40)
                    make.left.equalToSuperview().offset(15)
                    make.width.lessThanOrEqualTo(SCREEN_WIDTH - 100)
                }
                navCustomView.middleTitle.font = UIFont.ThemeFont.H1Bold
            case .listtitle:
                navCustomView.middleTitle.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(navCustomView.popBtn)
                    make.height.equalTo(33)
                    make.left.equalTo(navCustomView.popBtn).offset(10)
//                    make.centerX.equalToSuperview()
                    make.width.lessThanOrEqualTo(SCREEN_WIDTH - 100)
                }
                navCustomView.snp.remakeConstraints { (make) in
                    make.top.left.right.equalTo(self.view)
                    make.height.equalTo(NAV_SCREEN_HEIGHT)
                }
                navCustomView.middleTitle.font = UIFont.ThemeFont.H3Bold
            case .notitle:
                self.navCustomView.middleTitle.isHidden = true
            case .nopopback:
                navCustomView.middleTitle.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(navCustomView.popBtn)
                    make.height.equalTo(25)
                    make.left.equalToSuperview().offset(15)
                    make.width.lessThanOrEqualTo(SCREEN_WIDTH - 100)
                }
                self.navCustomView.popBtn.isHidden = true
            case .swap:
                navCustomView.popBtn.setImage(UIImage.themeImageNamed(imageName: "swap_action_drawer"), for: .normal)
                navCustomView.middleTitle.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(navCustomView.popBtn)
                    make.height.equalTo(25)
                    make.left.equalTo(navCustomView.popBtn.snp_right).offset(5)
                    make.width.lessThanOrEqualTo(SCREEN_WIDTH - 100)
                }
            default:
                break
            }
        }
    }
    
    var xscrollView = UIScrollView()
    {
        didSet{
//            xscrollView.rx.contentOffset.subscribe(onNext: { (point) in
//                //do something
//                let y = point.y
//                if self.navtype == .list{
//                    if y > 0{
//                        self.navtype = .listtitle
//                    }
//                }else if self.navtype == .listtitle{
//                    if y < 0{
//                        self.navtype = .list
//                    }
//                }
//            }).disposed(by: disposeBag)
//            self.navtype = .list
        }
    }
    
    //顶部导航栏
    lazy var navCustomView : KRNavCustomView = {
        let view = KRNavCustomView()
        view.extUseAutoLayout()
        view.clickPopBtnBlock = {[weak self]() in
            guard let mySelf = self else{return}
            if mySelf.navtype == .swap {
                mySelf.pushVc()
            } else {
                mySelf.navBack()
            }
        }
        return view
    }()
    
    //统一的view
    lazy var contentView : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = UIColor.ThemeView.bg
        setNavCustomV()
        setNavLeft()
    }
    
    func setNavLeft(){
        if (self.navigationController != nil && (self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)))!) {
            self.navigationController!.interactivePopGestureRecognizer!.delegate = self
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        XHUDManager.dismiss()
    }
    
    override func addConstraint() {
        super.addConstraint()
        view.addSubViews([contentView,navCustomView])
//        contentView.addSubview(voidView)
        navCustomView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(NAV_SCREEN_HEIGHT)
        }
//        bottomLine.snp.makeConstraints { (make) in
//            make.bottom.equalTo(navCustomView)
//            make.height.equalTo(0.5)
//            make.left.right.equalTo(self.view)
//        }
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(navCustomView.snp.bottom)
            make.bottom.left.right.equalTo(self.view)
        }
//        voidView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer{
            if let count = self.navigationController?.viewControllers.count , count < 2 || self.navigationController?.visibleViewController == self.navigationController?.viewControllers[0]{
                return false
            }
        }
        return true
    }
    
    public func tobecomeFirstResponder(){
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(setEndEditing))
        self.contentView.addGestureRecognizer(tap)
    }
    
    open func forbidMoveFromScreenLeft(){
        //导航控制器根控制器禁止左滑 否则 左滑 易出现卡顿现象
        let screenPan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(rightSliderScreen))
        screenPan.edges = UIRectEdge.left
        self.view.addGestureRecognizer(screenPan)
        
    }
    
    @objc open func rightSliderScreen(_ pan : UIScreenEdgePanGestureRecognizer){
        //do nothing
    }
    
    //结束编辑
    @objc func setEndEditing(){
        self.contentView.endEditing(true)
    }
    
    public func setNavCustomV(){
        
    }
    
    public func setVoidViewHidden(_ hidden : Bool){
//        voidView.isHidden = hidden
    }
    
    //MARK:设置title
    public func setTitle(_ title : String , color : UIColor = UIColor.ThemeLabel.colorLite , font : CGFloat = 18){
        navCustomView.middleTitle.text = title
    }
    
    //MARK:设置是否展示navbar的线和是否展示线
    public func showNavBar(_ showNav : Bool = true){
        navCustomView.isHidden = !showNav
//        bottomLine.isHidden = !showNavBottomLine
    }
    
    //MARK:设置右边的按钮
    public func setRightModule(_ views : [UIView]){
        navCustomView.setRightModule(views)
    }
    
    //MARK:设置左边的按钮
    public func setLeftModule(_ views : [UIView] , _ showPopBtn : Bool = true){
        navCustomView.setLeftModule(views,showPopBtn)
    }
    
    //MARK:重新设置颜色
    public func reloadNavbackgroundColor(){
        //TODO:颜色
        navCustomView.backView.backgroundColor = UIColor.white
    }
    
    //MARK:自定义contentview的位置
    public func contentViewBottom(_ bottom : CGFloat = 0){
        contentView.snp.updateConstraints { (make) in
            make.bottom.equalTo(view).offset(-bottom)
        }
    }
    
    func navBack(){
        self.popBack()
    }
    
    func pushVc() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension KRNavCustomVC : UIScrollViewDelegate{
    
}
