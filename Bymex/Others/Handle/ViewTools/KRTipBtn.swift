//
//  KRTipBtn.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/22.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRTipBtn: UIView {

    typealias ClickShowTipBlock = () -> ()
    var clickShowTipBlock : ClickShowTipBlock?
    
    lazy var titleLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .center)
        return object
    }()
    
    lazy var imgV : UIImageView = {
        let object = UIImageView()
        return object
    }()
    
    lazy var bottomLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeLabel.colorMedium
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: {[weak self] recognizer in
            self?.clickShowTipBlock?()
        }).disposed(by: disposeBag)
    }
    
    public func layoutBottomLine() {
        addSubview(bottomLine)
        if (self.titleLabel.text?.length ?? 0) > 0 {
            bottomLine.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.titleLabel)
                make.top.equalTo(self.titleLabel.snp.bottom)
                make.height.equalTo(1)
            }
        }
    }
    
    public func setImgLayout(_ imgStr : String,_ alignment: NSTextAlignment) {
        imgV.image = UIImage.themeImageNamed(imageName: imgStr)
        addSubview(imgV)
        addSubview(bottomLine)
        if alignment == .left {
            imgV.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.height.equalTo(12)
                make.centerY.equalToSuperview()
            }
            titleLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(imgV.snp.right).offset(2)
                make.centerY.equalTo(imgV)
                make.height.equalTo(16)
                make.width.lessThanOrEqualToSuperview()
            }
            
        } else if alignment == .right {
            titleLabel.snp.remakeConstraints { (make) in
                make.right.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(16)
                make.width.lessThanOrEqualToSuperview()
            }
            imgV.snp.makeConstraints { (make) in
                make.width.height.equalTo(12)
                make.right.equalTo(titleLabel.snp.left).offset(-2)
                make.centerY.equalToSuperview()
            }
        }
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(1)
        }
    }
    
    public func setTitle(_ title : String) {
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
