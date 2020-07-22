//
//  KRTabbarItem.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/10.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import UIKit
import RxSwift
import YYWebImage

class KRTabbarItem: UIView {
    
    //点击tabbarItem的热信号
    public var subject : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    //图案
    lazy var imageBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.isUserInteractionEnabled = false
        _ = subject.asObservable().subscribe({ (event) in
            if let b = event.element{
                btn.isSelected = b
            }
        })
        return btn
    }()
    
    //文字
    lazy var labelBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.isUserInteractionEnabled = false
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: UIControl.State.selected)
        _ = subject.asObservable().subscribe({ (event) in
            if let b = event.element{
                btn.isSelected = b
            }
        })
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([imageBtn , labelBtn])
        addConstraint()
        self.isUserInteractionEnabled = true
    }
    
    func addConstraint() {
        imageBtn.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.centerX.equalTo(self)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        labelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(imageBtn.snp.bottom).offset(5)
            make.height.equalTo(10)
            make.left.right.equalTo(self)
        }
    }
    
    //设置配置
    func setImageAndLabel(_ model : KRTabbarModel){
        
        if let url = URL.init(string: model.onlineDefIcon){
            imageBtn.yy_setImage(with: url, for: UIControl.State.normal, placeholder: UIImage.themeImageNamed(imageName: model.localDefIcon), options: YYWebImageOptions.allowBackgroundTask, completion: nil)
        } else {
            imageBtn.setImage(UIImage.themeImageNamed(imageName: model.localDefIcon), for: UIControl.State.normal)
        }
        if let url = URL.init(string: model.onlineSelIcon){
            imageBtn.yy_setImage(with: url, for: UIControl.State.selected, placeholder: UIImage.themeImageNamed(imageName: model.localSelIcon), options: YYWebImageOptions.allowBackgroundTask, completion: nil)
        }else{
             imageBtn.setImage(UIImage.themeImageNamed(imageName: model.localSelIcon), for: UIControl.State.selected)
        }
        
        if model.onlineTx == ""{
            labelBtn.setTitle(model.localTx, for: UIControl.State.normal)
        }else{
            labelBtn.setTitle(model.onlineTx, for: UIControl.State.normal)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
