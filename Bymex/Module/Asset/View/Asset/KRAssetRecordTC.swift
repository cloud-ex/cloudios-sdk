//
//  KRAssetRecordTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/6/1.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation

class KRAssetRecordTC: UITableViewCell {
    lazy var nameLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.HeadRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    lazy var timeLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    lazy var resultLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .right)
        return object
    }()
    lazy var arrowV : UIImageView = {
        let object = UIImageView.init(image: UIImage.themeImageNamed(imageName: "account_next"))
        return object
    }()
    lazy var volumeLabel : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("数量".localized())
        return object
    }()
    lazy var toAccountLabel : KRVerDetailLabel = {
        let object = KRVerDetailLabel()
        object.setTopText("转入账户".localized())
        return object
    }()
    
    lazy var cancelBtn : KRFlatBtn = {
        let object = KRFlatBtn()
        object.extSetTitle("撤销".localized(), 12, UIColor.ThemeLabel.colorHighlight, .normal)
        object.isHidden = true
        return object
    }()
    
    lazy var addressLabel : UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    lazy var duplicatBtn : UIButton = {
        let object = UIButton()
        object.extSetImages([UIImage.themeImageNamed(imageName: "account_copy")], controlStates: [.normal])
        object.rx.tap.subscribe(onNext:{ [weak self] in
            UIPasteboard.general.string = self?.addressLabel.text
            EXAlert.showSuccess(msg: "common_tip_copySuccess".localized())
        }).disposed(by: disposeBag)
        object.isHidden = true
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        extSetCell()
        if reuseIdentifier == "KRAssetRecordTC1" {
            setupSubviewsLayout1()
        } else if reuseIdentifier == "KRAssetRecordTC2" {
            setupSubviewsLayout2()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KRAssetRecordTC {
    func setupSubviewsLayout1() {
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
        contentView.addSubViews([nameLabel,timeLabel,resultLabel,arrowV,volumeLabel,addressLabel,duplicatBtn,cancelBtn])
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(15)
            make.height.equalTo(20)
        }
        arrowV.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalTo(nameLabel)
        }
        resultLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowV.snp.left)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.equalTo(16)
        }
        volumeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-60)
            make.height.equalTo(34)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(volumeLabel.snp.right).offset(10)
            make.centerY.equalTo(volumeLabel)
            make.right.equalTo(-10)
            make.height.equalTo(24)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(volumeLabel.snp.bottom).offset(25)
            make.right.equalToSuperview().offset(-70)
            make.height.equalTo(20)
        }
        duplicatBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerY.equalTo(addressLabel)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func setupSubviewsLayout2() {
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
        contentView.addSubViews([nameLabel,timeLabel,volumeLabel,toAccountLabel,arrowV])
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(15)
            make.height.equalTo(20)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.equalTo(16)
        }
        volumeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.height.equalTo(34)
        }
        toAccountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(volumeLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.width.height.equalTo(volumeLabel)
        }
        arrowV.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalTo(nameLabel.snp.bottom)
        }
    }
}

class KRAssetRecordDetailTC: UITableViewCell {
    
    lazy var nameLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: .left)
        return object
    }()
    
    lazy var contentLabel : UILabel = {
        let object = UILabel.init(text: "--", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        object.numberOfLines = 0
        return object
    }()
    
    lazy var lineV : UIView = {
        let object = UIView()
        object.backgroundColor = UIColor.ThemeView.seperator
        return object
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        extSetCell()
        contentView.addSubViews([nameLabel,contentLabel,lineV])
        contentLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(143)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(contentLabel)
            make.height.equalTo(18)
            make.right.equalTo(contentLabel.snp.left).offset(-10)
        }
        lineV.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(contentLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(_ name :String,content: String) {
        nameLabel.text = name
        contentLabel.text = content
    }
}
