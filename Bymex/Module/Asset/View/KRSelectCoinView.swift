//
//  KRSelectCoinView.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/24.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSelectCoinView: KRBaseV {
    
    typealias ClickSelectCoinBlock = () -> ()
    var clickSelectCoinBlock : ClickSelectCoinBlock?
    
    override func setupSubViewsLayout() {
        layer.cornerRadius = 6
        backgroundColor = UIColor.ThemeTab.bg
        let tapGesture = UITapGestureRecognizer()
        addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: {[weak self] recognizer in
            guard let mySelf = self else {return}
            mySelf.clickSelectCoinBlock?()
        }).disposed(by: disposeBag)
        
        addSubViews([imgV,titleLabel,rightLabel,arrowV])
        imgV.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgV.snp.right).offset(5)
            make.centerY.equalTo(imgV)
            make.right.equalTo(rightLabel.snp.left).offset(-10)
        }
        arrowV.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
        }
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowV.snp.left).offset(-4)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    public func setView(img: String, _ titleText : String, rightText : String) {
        imgV.image = UIImage.themeImageNamed(imageName: img)
        titleLabel.text = titleText
        rightLabel.text = rightText
    }
    
    //MARK:-lazy
    lazy var imgV : UIImageView = {
        let object = UIImageView()
        object.image = UIImage.themeImageNamed(imageName: "asset_coin_placeholder")
        return object
    }()
    
    lazy var titleLabel : UILabel = {
        let object = UILabel.init(text: "BTC", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    
    lazy var rightLabel : UILabel = {
        let object = UILabel.init(text: "选择币种".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor:  UIColor.ThemeLabel.colorDark, alignment: .right)
        return object
    }()
    
    lazy var arrowV : UIImageView = {
        let object = UIImageView.init(image: UIImage.themeImageNamed(imageName: "account_next"))
        return object
    }()
}
