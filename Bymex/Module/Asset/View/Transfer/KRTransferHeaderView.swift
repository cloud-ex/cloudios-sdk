//
//  KRTransferHeaderView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/24.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRTransferHeaderView: KRBaseV {
    
    override func setupSubViewsLayout() {
        layer.cornerRadius = 10
        backgroundColor = UIColor.ThemeTab.bg
        addSubViews([fromView,lineV,toView,switchBtn,fromTitle,toTitle,dottedV])
        fromTitle.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(25)
            make.height.equalTo(20)
        }
        toTitle.snp.makeConstraints { (make) in
            make.left.height.equalTo(fromTitle)
            make.bottom.equalTo(-25)
        }
        lineV.snp.makeConstraints { (make) in
            make.left.equalTo(70)
            make.height.equalTo(0.5)
            make.right.equalTo(-76)
            make.centerY.equalToSuperview()
        }
        switchBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        fromView.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineV)
            make.height.equalTo(50)
            make.bottom.equalTo(lineV.snp_top)
        }
        toView.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineV)
            make.height.equalTo(50)
            make.top.equalTo(lineV.snp_bottom)
        }
    }
    
    //MARK:- lazy
    lazy var fromView : KRTransferItemView = {
        let object = KRTransferItemView()
        return object
    }()
    lazy var lineV : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    lazy var toView : KRTransferItemView = {
        let object = KRTransferItemView()
        return object
    }()
    lazy var switchBtn : UIButton = {
        let object = UIButton()
        object.extSetImages([UIImage.themeImageNamed(imageName: "transfer_switch")], controlStates: [.normal])
        return object
    }()
    
    lazy var fromTitle : UILabel = {
        let object = UILabel.init(text: "从", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    lazy var toTitle : UILabel = {
        let object = UILabel.init(text: "到", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    lazy var dottedV : UIImageView = {
        let object = UIImageView.init(image: UIImage.themeImageNamed(imageName: ""))
        return object
    }()
}

class KRTransferItemView: KRBaseV {
    
    override func setupSubViewsLayout() {
        backgroundColor = UIColor.ThemeTab.bg
        addSubViews([nameLabel,tapBtn])
        nameLabel.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        tapBtn.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    //MARK:- lazy
    lazy var nameLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    
    lazy var tapBtn : UIButton = {
        let object = UIButton()
        object.setImage(UIImage.themeImageNamed(imageName: "account_next"), for: .normal)
        return object
    }()
}
