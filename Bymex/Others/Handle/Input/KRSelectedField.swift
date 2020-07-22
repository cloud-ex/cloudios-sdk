//
//  KRSelectedField.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/14.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRSelectedField: KRBaseField {
    typealias TxtFieldDidTappedBlock = () -> ()
    var textfieldDidTapBlock : TxtFieldDidTappedBlock?
    
    lazy var input : UITextField = {
        let object = UITextField()
        object.backgroundColor = UIColor.ThemeView.bg
        object.font = UIFont.ThemeFont.HeadRegular
        object.textColor = UIColor.ThemeLabel.colorLite
        object.isUserInteractionEnabled = false
        return object
    }()
    
    lazy var titleLabel : UILabel = {
        let object = UILabel.init(text: "register_text_country".localized(), frame: .zero, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    
    lazy var baseLine : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    
    lazy var arrowIcon : UIImageView = {
        let object = UIImageView()
        object.image = UIImage.themeImageNamed(imageName: "drop_arrow")
        return object
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addCreate() {
        super.addCreate()
        let tapGesture = UITapGestureRecognizer.init()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(tapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapped(){
        self.textfieldDidTapBlock?()
    }
}

extension KRSelectedField {
    private func setupSubviewsLayout() {
        addSubViews([input,titleLabel,baseLine,arrowIcon])
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(16)
        }
        input.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.height.equalTo(24)
            make.right.equalTo(arrowIcon.snp_left).offset(-5)
        }
        arrowIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(input)
            make.right.equalToSuperview()
            make.width.height.equalTo(24)
        }
        baseLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
