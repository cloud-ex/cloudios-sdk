//
//  KRTextSheet.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/3.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRTextSheet: KRBaseV {
    
    lazy var mainView :UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeTab.bg
        return object
    }()
    
    lazy var iconV : UIImageView = {
        let object = UIImageView()
        return object
    }()
    
    lazy var titleLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.systemFont(ofSize: 16), textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    
    lazy var contentLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        object.numberOfLines = 0
        return object
    }()
    lazy var cancelLine : UIButton = {
        let object = UIButton()
        object.backgroundColor = UIColor.ThemeLabel.colorDark
        object.extSetCornerRadius(2)
        object.rx.tap.subscribe(onNext:{
            EXAlert.dismiss()
        }).disposed(by: disposeBag)
        return object
    }()
    func configTextAlert(_ imgStr:String="",title:String,content:String) {
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mainView.addSubViews([titleLabel,contentLabel,cancelLine])
        cancelLine.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(4)
            make.width.equalTo(40)
            make.centerX.equalToSuperview()
        }
        if imgStr.count > 0 {
            mainView.addSubview(iconV)
            iconV.image = UIImage.themeImageNamed(imageName: imgStr)
        }
        titleLabel.text = title
        contentLabel.text = content
        var left = 26
        if imgStr.count > 0 {
            iconV.snp.makeConstraints { (make) in
                make.left.equalTo(26)
                make.top.equalTo(40)
                make.width.height.equalTo(24)
            }
            left = 62
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(left)
            make.top.equalTo(42)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-26)
        }
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 4
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                          NSAttributedString.Key.paragraphStyle: paraph]
        contentLabel.attributedText = NSAttributedString(string: content, attributes: attributes)
        contentLabel.textColor = UIColor.ThemeLabel.colorDark
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(26)
            make.right.equalTo(-26)
            make.top.equalTo(titleLabel.snp.bottom).offset(17)
            make.bottom.equalToSuperview().offset(-TABBAR_BOTTOM - 20)
        }
        self.layoutSubviews()
    }
}
