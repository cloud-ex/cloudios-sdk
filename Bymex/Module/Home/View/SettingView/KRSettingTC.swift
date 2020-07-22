//
//  KRSettingTC.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/5/21.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import YYWebImage
import YYText

class BaseSettingTC: UITableViewCell {
    var entity = KRSettingVEntity()
    //名字
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.extSetTextColor(UIColor.ThemeLabel.colorLite, fontSize: 14)
        return label
    }()
    lazy var rightImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.themeImageNamed(imageName: "setting_selected")
        imgV.isHidden = true
        return imgV
    }()
    //底部的线
    lazy var hlineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        contentView.addSubViews([nameLabel,hlineV,rightImgV])
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.lessThanOrEqualTo(200)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
        rightImgV.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.width.height.equalTo(21)
            make.centerY.equalTo(nameLabel)
        }
        hlineV.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
    }
    
    func setCell(_ entity : KRSettingVEntity){
        nameLabel.text = entity.name
        if entity.isSelected {
            rightImgV.isHidden = false
        } else {
            rightImgV.isHidden = true
        }
    }
}

class KRSettingTC: BaseSettingTC {
    
    //默认展示
    lazy var defaultLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.isUserInteractionEnabled = false
        label.extSetTextColor(UIColor.ThemeLabel.colorDark, fontSize: 12)
        return label
    }()
    
    lazy var tipsImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.themeImageNamed(imageName: "setting_tips_common")
        return imgV
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        rightImgV.isHidden = false
        rightImgV.image = UIImage.themeImageNamed(imageName: "account_next")
    }
    
    override func addConstraints() {
        super.addConstraints()
        contentView.addSubViews([defaultLabel])
        defaultLabel.snp.makeConstraints { (make) in
            make.right.equalTo(rightImgV.snp.left).offset(-5)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    override func setCell(_ entity : KRSettingVEntity){
        nameLabel.text = entity.name
        defaultLabel.text = entity.defaule
    }
    
    func showTips() {
        contentView.addSubview(tipsImgV)
        defaultLabel.textColor = UIColor.ThemeState.warning
        tipsImgV.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.right.equalTo(defaultLabel.snp.left).offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class KRSwitchTC: BaseSettingTC {
    typealias ClickSwitchBlock = (Bool) -> ()//点击switch的回调
    var clickSwitchBlock : ClickSwitchBlock?
    
    lazy var switchBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.backgroundColor = UIColor.clear
        btn.extSetAddTarget(self, #selector(clickSwitchV))
        return btn
    }()
    
    lazy var switchV : KRSwitch = {
        let view = KRSwitch()
        view.extUseAutoLayout()
        view.layoutIfNeeded()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(switchV)
        contentView.addSubview(switchBtn)
        switchBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalTo(33)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
        }
        switchV.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    override func setCell(_ entity : KRSettingVEntity){
        nameLabel.text = entity.name
        switchBtn.isSelected = entity.switchType == "1"
        switchV.setOn(isOn: entity.switchType == "1")
    }
    
    func setSwitch(_ status:Bool) {
        switchBtn.isSelected = status
        switchV.setOn(isOn:status)
        if nameLabel.text == "手势密码".localized() {
            if status == false {
                 XUserDefault.setGesturesPassword("")
            }
        }
    }
    
    @objc func clickSwitchV(_ btn : UIButton){
        if nameLabel.text == "Face ID".localized() {
            if XUserDefault.getFaceIdOrTouchIdPassword() != nil {
                btn.isSelected = false
                switchV.setOn(isOn:false)
            }else{
                btn.isSelected = !btn.isSelected
                switchV.setOn(isOn: btn.isSelected)
            }
            clickSwitchBlock?(switchV.isOn)

        } else if nameLabel.text == "手势密码".localized() {
            if XUserDefault.getGesturesPassword() != nil {
                btn.isSelected = false
                switchV.setOn(isOn:false)
            } else {
                btn.isSelected = !btn.isSelected
                switchV.setOn(isOn: btn.isSelected)
            }
            clickSwitchBlock?(switchV.isOn)
        } else {
            btn.isSelected = !btn.isSelected
            switchV.setOn(isOn: btn.isSelected)
            clickSwitchBlock?(switchV.isOn)
            XUserDefault.setComfirmSwapAlert(switchV.isOn) // 设置下单二次确认
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SettingIconTC : BaseSettingTC {
    lazy var iconImg : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.themeImageNamed(imageName: "home_account")
        return imgV
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        rightImgV.isHidden = false
        rightImgV.image = UIImage.themeImageNamed(imageName: "account_next")
        contentView.addSubview(iconImg)
        iconImg.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightImgV.snp_left).offset(-10)
            make.width.height.equalTo(40)
        }
    }
    
    override func setCell(_ entity : KRSettingVEntity){
        nameLabel.text = entity.name
        if entity.image_url != "", let url = URL.init(string: entity.image_url) {
            iconImg.yy_setImage(with: url, options: YYWebImageOptions.allowBackgroundTask)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SelectedTC: BaseSettingTC {
    lazy var iconV : UIImageView = {
        let object = UIImageView.init()
        return object
    }()
    
    override func addConstraints() {
        super.addConstraints()
        iconV.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        nameLabel.snp.updateConstraints { (make) in
            make.left.equalTo(iconV.snp.right).offset(10)
        }
    }
    override func setCell(_ entity : KRSettingVEntity){
        super.setCell(entity)
//        iconV.image = 
    }
}
